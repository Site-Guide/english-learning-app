import 'dart:async';

import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/master_data.dart';
import 'package:english/cores/models/profile.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/ui/profile/providers/my_profile_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../cores/models/meet_session.dart';
import '../../../cores/providers/master_data_provider.dart';
import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../home/providers/topic_provider.dart';

final meetHandlerProvider =
    ChangeNotifierProvider.autoDispose((ref) => MeetHandler(ref)..init());

enum MeetStatus { init, meet }

class MeetHandler extends ChangeNotifier {
  final Ref _ref;

  MeetHandler(this._ref);

  List<Purchase> get _purchases =>
      _ref.read(purchasesProvider).asData?.value ?? [];
  List<Purchase> get elegiblePurchases =>
      _purchases.where((element) => !element.isExpired).toList();

  List<Topic> get _topics => _ref.read(topicsProvider).asData?.value ?? [];

  List<Topic> get elegibleTopics => _topics
      .where((topic) =>
          topic.courseId == null  ||
          elegiblePurchases
              .where(
                (purchase) => purchase.typeId == topic.courseId,
              )
              .isNotEmpty)
      .toList();

  Topic? _selectedTopic;
  Topic? get selectedTopic => _selectedTopic;
  set selectedTopic(Topic? value) {
    _selectedTopic = value;
    notifyListeners();
  }

  Purchase? get appliedPurchase => elegiblePurchases
      .where((element) => _selectedTopic!.courseId != null
          ? element.typeId == _selectedTopic!.courseId
          : true)
      .first;

  MasterData get _masterData => _ref.read(masterDataProvider).value!;

  Profile get _profile => _ref.read(profileProvider).value!;

  int get dailyLimit => _masterData.dailyCalls[_profile.level!]!;

  void init() async {
    await _ref.read(purchasesProvider.future);
    await _ref.read(topicsProvider.future);
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    audio = await Permission.microphone.status;
    camera = await Permission.camera.status;
    notifyListeners();
  }

  Future<void> requestAudio() async {
    final status = await Permission.microphone.request();
    audio = status;
    notifyListeners();
  }

  Future<void> requestCamera() async {
    final status = await Permission.camera.request();
    camera = status;
    notifyListeners();
  }

  void request() async {
    List<Permission> list = [Permission.camera, Permission.microphone];
    final map = await list.request();
    map.forEach((key, value) {
      if (key == Permission.camera) {
        print("camera: $value");
        camera = value;
      } else if (key == Permission.microphone) {
        print("audio: $value");
        audio = value;
        print(audio);
      }
    });
    notifyListeners();
  }

  PermissionStatus? audio;
  PermissionStatus? camera;

  int? _limit = 2;
  int? get limit => _limit;
  set limit(int? value) {
    _limit = value;
    notifyListeners();
  }

  bool busy = false;

  String? joinedId;

  MeetRepsitory get _repository => _ref.read(meetRepositoryProvider);

  StreamSubscription<List<MeetSession>>? subscription;
  Timer? _timer;

  void startRandomJoin({
    required Function(MeetSession session) onJoin,
  }) {
    final user = _ref.read(userProvider).value!;
    final stream = _repository.streamMeetSessions();
    print('Started');
    subscription = stream.listen((event) {
      final readyMeets =
          event.where((element) => element.isReadyForMeet(user.$id));
      if (readyMeets.isNotEmpty) {
        print('ready for meet');
        final meet = readyMeets.first;
        onJoin(meet);
        subscription?.cancel();
        subscription = null;
        _timer?.cancel();
        notifyListeners();
        return;
      }
      print("No ready meets");
      final needToWaitMeets =
          event.where((element) => element.needToWait(user.$id));
      if (needToWaitMeets.isNotEmpty) {
        print("wait meets");
        return;
      }
      print("No wait meets");
      if (busy) {
        print("Busy");
        return;
      }
      final meets = event.where((element) => element.isJoinReady(limit));
      if (meets.isNotEmpty) {
        print('joning meet');
        final meet = meets.first;
        joinMeet(meet);
      } else {
        print('creating meet');
        createMeet();
      }
    });
    notifyListeners();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _timer?.cancel();
      subscription?.cancel();
      subscription = null;
      notifyListeners();
    });
  }

  Future<void> createMeet() async {
    busy = true;
    final user = await _ref.read(userProvider.future);
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _repository.writeMeetSession(
        MeetSession(
          id: '',
          topic: selectedTopic!.name,
          limit: limit,
          participants: [user.$id],
          createdAt: DateTime.now(),
          topicId: selectedTopic!.id,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      busy = false;
    } catch (e) {
      print(e);
      busy = false;
      return Future.error(e);
    }
  }

  Future<void> joinMeet(MeetSession meetSession) async {
    busy = true;
    final user = await _ref.read(userProvider.future);
    final updated = meetSession.copyWith(
      participants: [
        ...meetSession.participants,
        user.$id,
      ],
    );
    try {
      await _repository.writeMeetSession(
        updated,
      );
      await Future.delayed(const Duration(seconds: 1));
      busy = false;
    } catch (e) {
      busy = false;
      return Future.error(e);
    }
  }
}

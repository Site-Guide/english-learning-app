import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/master_data.dart';
import 'package:english/cores/models/profile.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/ui/profile/providers/my_profile_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/meet_session.dart';
import '../../../cores/providers/master_data_provider.dart';
import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../home/providers/topic_provider.dart';

final meetHandlerProvider = ChangeNotifierProvider.autoDispose((ref) => MeetHandler(ref));

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
          topic.courseId == null ||
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
          : element.type == PurchaseType.plan)
      .first;

  MasterData get _masterData => _ref.read(masterDataProvider).value!;

  Profile get _profile => _ref.read(profileProvider).value!;

  int get dailyLimit => _masterData.dailyCalls[_profile.level!]!;

  void init() async {
    await _ref.read(purchasesProvider.future);
    await _ref.read(topicsProvider.future);
  }

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

  Timer? _meetTimer;

  void startRandomJoin(
      {required Function(MeetSession session) onJoin,
      required VoidCallback onEnd}) {
    final user = _ref.read(userProvider).value!;
    final stream = _repository.streamMeetSessions();
    subscription = stream.listen((event) {
      final readyMeets =
          event.where((element) => element.isReadyForMeet(user.$id));
      if (readyMeets.isNotEmpty) {
        final meet = readyMeets.first;
        onJoin(meet);
        _meetTimer = Timer(const Duration(seconds: 10), () {
          onEnd();
          _meetTimer?.cancel();
        });
        subscription?.cancel();
        subscription = null;
        _timer?.cancel();
        notifyListeners();
        return;
      }
      final needToWaitMeets =
          event.where((element) => element.needToWait(user.$id));
      if (needToWaitMeets.isNotEmpty) {
        return;
      }
      if (busy) {
        return;
      }
      final meets = event.where((element) => element.isJoinReady(limit));
      if (meets.isNotEmpty) {
        final meet = meets.first;
        joinMeet(meet);
      } else {
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
      await _repository.writeMeetSession(
        MeetSession(
          id: '',
          subject: _ref.read(topicsProvider).value!.first.name,
          limit: limit,
          participants: [user.$id],
          createdAt: DateTime.now(),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      busy = false;
    } catch (e) {
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

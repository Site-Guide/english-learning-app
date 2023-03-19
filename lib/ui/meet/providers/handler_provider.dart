import 'dart:async';

import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/master_data.dart';
import 'package:english/cores/models/profile.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/ui/meet/providers/sessions_stream_provider.dart';
import 'package:english/ui/profile/providers/my_profile_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
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
          (topic.courseId == null &&
              elegiblePurchases
                  .where((element) => element.type == PurchaseType.plan)
                  .isNotEmpty) ||
          elegiblePurchases
              .where(
                (purchase) => purchase.typeId == topic.courseId,
              )
              .isNotEmpty)
      .toList();

  bool isTopicElegible(String id) {
    return elegibleTopics.where((element) => element.id == id).isNotEmpty;
  }

  Topic? selectedTopic;

  Purchase? get appliedPurchase {
    final list = elegiblePurchases.where((element) =>
        selectedTopic!.courseId != null
            ? element.typeId == selectedTopic!.courseId
            : element.type == PurchaseType.plan);
    return list.isNotEmpty ? list.first : null;
  }

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

  bool _callLoading = false;

  bool get loading => subscription != null || _callLoading;

  void startRandomJoin(
      {required Function(MeetSession session, Topic topic, Purchase purchase,
              Room room, EventsListener<RoomEvent> listener)
          onJoin,
      required VoidCallback onSearchEnd}) {
    final stream = _ref.read(sessionsStreamProvider.stream);
    final meets = _ref
            .read(sessionsStreamProvider)
            .value
            ?.where((element) => !element.expired)
            .toList() ??
        [];

    final meet = handleEvents(meets);
    print("meet: $meet");
    if (meet != null) {
      print("meet: ${meet.id}");
      joinRoom(meet, onJoin);
    } else {
      subscription = stream.listen((event) {
        print("event: ${event.length}");
        final meet = handleEvents(event);
        if (meet != null) {
          joinRoom(meet, onJoin);
        }
      });
      notifyListeners();
      _timer = Timer(const Duration(minutes: 1), () {
        onSearchEnd();
        _timer?.cancel();
        subscription?.cancel();
        subscription = null;
        notifyListeners();
      });
    }
  }

  MeetSession? handleEvents(List<MeetSession> event) {
    final user = _ref.read(userProvider).value!;
    print(user.$id);
    print(event.length);
    final readyMeets =
        event.where((element) => element.isReadyForMeet(user.$id));
    print("ready meets: ${readyMeets.length}");
    if (readyMeets.isNotEmpty) {
      print('ready for meet');
      final meet = readyMeets.first;
      _callLoading = true;
      subscription?.cancel();
      subscription = null;
      print("canceling subscription");
      print(subscription == null);
      _timer?.cancel();
      notifyListeners();
      return meet;
    }
    print("No ready meets");
    final needToWaitMeets =
        event.where((element) => element.needToWait(user.$id));
    if (needToWaitMeets.isNotEmpty) {
      print("wait meets");
      return null;
    }
    print("No wait meets");
    if (busy) {
      print("Busy");
      return null;
    }
    final meets =
        event.where((element) => element.isJoinReady(limit, selectedTopic!.id));
    if (meets.isNotEmpty) {
      print('joning meet');
      final meet = meets.first;
      participate(meet);
    } else {
      createMeet();
    }
    return null;
  }

  Future<void> createMeet() async {
    busy = true;
    final user = await _ref.read(userProvider.future);
    print("creating meet");
    try {
      await _repository.writeMeetSession(
        MeetSession(
          id: '',
          limit: limit,
          participants: [user.$id],
          createdAt: DateTime.now(),
          topicId: selectedTopic!.id,
        ),
      );
      print("meet created");
      await Future.delayed(const Duration(seconds: 1));
      busy = false;
    } catch (e) {
      print(e);
      busy = false;
      return Future.error(e);
    }
  }

  Future<void> participate(
    MeetSession meetSession,
  ) async {
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

  Future<void> joinRoom(
      MeetSession session,
      Function(MeetSession session, Topic topic, Purchase purchase, Room room,
              EventsListener<RoomEvent> listener)
          onJoin) async {
    final token = await _repository.createLivekitToken(
      roomId: session.id,
      identity: _profile.id,
      name: _profile.name,
    );
    final room = Room();
    // Create a Listener before connecting
    final listener = room.createListener();
    await room.connect(
      "wss://livekit.engexpert.in",
      token,
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultVideoPublishOptions: VideoPublishOptions(
          simulcast: true,
        ),
        defaultScreenShareCaptureOptions:
            ScreenShareCaptureOptions(useiOSBroadcastExtension: true),
      ),
      fastConnectOptions: FastConnectOptions(
        microphone: const TrackOption(enabled: true),
        camera: const TrackOption(enabled: true),
      ),
    );

    onJoin(
      session,
      selectedTopic!,
      appliedPurchase!,
      room,
      listener,
    );
    print('joined 1');
    _callLoading = false;
  }

  void back(){
    subscription?.cancel();
    subscription = null;
    _timer?.cancel();
  }
}

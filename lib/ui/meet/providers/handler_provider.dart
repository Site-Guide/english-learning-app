import 'dart:async';

import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/call_request.dart';
import 'package:english/cores/models/master_data.dart';
import 'package:english/cores/models/profile.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/cores/providers/loading_provider.dart';
import 'package:english/cores/providers/messaging_provider.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:english/ui/profile/providers/my_profile_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../cores/providers/master_data_provider.dart';
import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import 'topics_provider.dart';

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

  void requestPermissions() async {
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

  int _limit = 2;
  int get limit => _limit;
  set limit(int value) {
    _limit = value;
    notifyListeners();
  }

  MeetRepsitory get _repository => _ref.read(meetRepositoryProvider);

  Loading get loading => _ref.read(loadingProvider);

  bool _joinLoading = false;
  bool get joinLoading => _joinLoading;
  set joinLoading(bool value) {
    _joinLoading = value;
    notifyListeners();
  }

  Future<void> request() async {
    loading.start();
    final user = await _ref.read(userProvider.future);
    try {
      final fcmToken = await _ref.read(messagingProvider).getToken();
      if (fcmToken == null) {
        return Future.error("Failed to get fcm token!");
      }
      await _repository.writeRequest(
        CallRequest(
          id: '',
          limit: limit,
          createdAt: DateTime.now(),
          topicId: selectedTopic!.id,
          uid: user.$id,
          fcmToken: fcmToken,
          name: user.name,
          purchaseId: appliedPurchase!.id,
        ),
      );
      _ref.refresh(requestsProvider);
      loading.end();
    } catch (e) {
      loading.stop();
      return Future.error(e);
    }
  }

  Future<void> joinRoom(
    String token,
    Function(Room room, EventsListener<RoomEvent> listener) onJoin,
  ) async {
    try {
      final room = Room();
      joinLoading = true;
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
        room,
        listener,
      );
      _joinLoading = false;
    } catch (e) {
      _joinLoading = false;
      return Future.error(e);
    }
  }
}

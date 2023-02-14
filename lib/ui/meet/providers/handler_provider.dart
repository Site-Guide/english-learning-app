import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import '../../../cores/models/meet_session.dart';
import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../home/providers/topic_provider.dart';

final meetHandlerProvider = ChangeNotifierProvider((ref) => MeetHandler(ref));

class MeetHandler extends ChangeNotifier{
  final Ref _ref;

  MeetHandler(this._ref);

  bool busy = false;

  int? _limit = 2;
  int? get limit => _limit;
  set limit(int? value) {
    _limit = value;
    notifyListeners();
  }

  Future<void> createMeet() async {
    busy = true;
    final user = await _ref.read(userProvider.future);

    try {
      await _ref.read(meetRepositoryProvider).writeMeetSession(
            MeetSession(
              id: '',
              subject: 'English',
              limit: 2,
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
      await _ref.read(meetRepositoryProvider).writeMeetSession(
            updated,
          );
      await Future.delayed(const Duration(seconds: 1));
      busy = false;
    } catch (e) {
      busy = false;
      return Future.error(e);
    }
  }


  void start(String id)async{
    busy = true;
    final user = await _ref.read(userProvider.future);
    final topic = await _ref.read(topicProvider.future);
        Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isInviteEnabled: false,

    };

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: id,
      serverUrl: 'https://jitsi.engexpert.in/',
      subject: topic!.topic,
      // token: tokenText.text,
      isAudioMuted: false,
      isAudioOnly: true,
      isVideoMuted: true,
      userDisplayName: user.name,
      userEmail: user.email,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
            "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () {
          debugPrint("onClosed");
          busy = false;
        },
        
      )
    );
  }
}

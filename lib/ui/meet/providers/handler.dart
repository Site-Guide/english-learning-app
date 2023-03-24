import 'dart:async';
import 'package:english/cores/models/call.dart';
import 'package:english/cores/providers/loading_provider.dart';
import 'package:english/cores/providers/messaging_provider.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final callHandlerProvider = ChangeNotifierProvider((ref) => CallHandler(ref));

enum MeetStatus { init, meet }

class CallHandler extends ChangeNotifier {
  final Ref _ref;

  CallHandler(this._ref);

  late StreamSubscription<RemoteMessage> _subscription;


  void initMessaging({
    required Function(JoinCall call) onJoin,
    required Function(String title, String body) onCallFailed,
  }) {
    _ref.read(messagingProvider).subscribeToTopic('call');
    _subscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (inCall) {
      //   return;
      // }
      final type = message.data['type'];
      if (type == 'call') {
        final String token = message.data['token']!;
        final String requestId = message.data['requestId']!;
        final String topicId = message.data['topicId']!;
        final String purchaseId = message.data['purchaseId']!;
        final call = JoinCall(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          token: token,
          requestId: requestId,
          topicId: topicId,
          purchaseId: purchaseId,
        );
        onJoin(call);
      } else if (type == 'call-failed') {
        if (message.notification != null) {
          onCallFailed(
            message.notification!.title ?? '',
            message.notification!.body ?? '',
          );
        }
      }
      _ref.refresh(requestsProvider);
    });
  }

  // bool inCall = false;

  // void onCallEnd() {
  //   print('onCallEnd');
  //   inCall = false;
  // }

  void disposeMessaging() {
    _subscription.cancel();
    super.dispose();
  }
}

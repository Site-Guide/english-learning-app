import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/providers/messaging_provider.dart';

final notificationSettingsProvider = FutureProvider<NotificationSettings>((ref) async {
  final messaging = ref.read(messagingProvider);
  final settings = await messaging.getNotificationSettings();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return settings;
  }
  return await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
});

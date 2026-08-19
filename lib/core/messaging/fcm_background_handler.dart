import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:psgy/firebase_options.dart';

/// Background FCM handler — must be a top-level function.
///
/// When the Cloud Function sends a `notification` payload, the OS displays it
/// automatically. This handler covers data-only fallbacks and logging.
@pragma('vm:entry-point')
Future<void> fcmBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    debugPrint(
      'FCM background: type=${message.data['type']} lotId=${message.data['lotId']}',
    );
  }
}

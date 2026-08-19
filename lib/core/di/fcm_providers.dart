import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/services/fcm_notification_service.dart';

final fcmNotificationServiceProvider = Provider<FcmNotificationService>((ref) {
  final service = FcmNotificationService();
  ref.onDispose(service.dispose);
  return service;
});

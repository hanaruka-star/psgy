import 'package:parking_link/core/services/fcm_notification_service.dart';
import 'package:parking_link/features/user/domain/ports/watchlist_notification_port.dart';
import 'package:parking_link/features/user/domain/ports/watchlist_cloud_function_port.dart';

/// Registers FCM topic interest for a watched lot (token-based via topics).
class FcmWatchlistNotificationPort implements WatchlistNotificationPort {
  final WatchlistCloudFunctionPort _cloudContract;
  final FcmNotificationService _fcmService;
  final Future<bool> Function() _notificationsEnabled;

  FcmWatchlistNotificationPort({
    WatchlistCloudFunctionPort? cloudContract,
    FcmNotificationService? fcmService,
    Future<bool> Function()? notificationsEnabled,
  })  : _cloudContract = cloudContract ?? WatchlistCloudFunctionContract(),
        _fcmService = fcmService ?? FcmNotificationService(),
        _notificationsEnabled = notificationsEnabled ?? (() async => true);

  @override
  Future<void> registerInterest(String lotId) async {
    if (!await _notificationsEnabled()) return;
    final topic = _cloudContract.lotOpeningTopic(lotId);
    await _fcmService.subscribeToTopic(topic);
  }

  Future<void> unregisterInterest(String lotId) async {
    final topic = _cloudContract.lotOpeningTopic(lotId);
    await _fcmService.unsubscribeFromTopic(topic);
  }
}

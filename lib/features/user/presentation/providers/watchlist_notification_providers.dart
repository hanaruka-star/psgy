import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/services/fcm_notification_service.dart';

/// Pending deep-link navigation from a watchlist push notification tap.
final pendingWatchlistLotNavigationProvider =
    StateProvider<WatchlistNotificationPayload?>((ref) => null);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/services/fcm_notification_service.dart';

/// Pending deep-link navigation from a watchlist push notification tap.
final pendingWatchlistLotNavigationProvider =
    StateProvider<WatchlistNotificationPayload?>((ref) => null);

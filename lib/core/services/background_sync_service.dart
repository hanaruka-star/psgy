import 'dart:async';

import 'package:psgy/core/cache/cache_sync_state.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/services/cache_invalidation_service.dart';
import 'package:psgy/core/services/sync_logger.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';

typedef CacheSyncStateListener = void Function(CacheSyncState state);
typedef GeoCoordinateProvider = GeoCoordinate? Function();

/// Background sync skeleton. Parking-lot sync was removed; keep start/stop
/// + connectivity hooks so gym/coach cache can plug in later.
class BackgroundSyncService {
  final ConnectivityService _connectivity;
  final CacheInvalidationService _cacheInvalidation;
  final CacheSyncStateListener _onStateChanged;

  StreamSubscription<ConnectivityEvent>? _connectivitySub;
  bool _isForeground = true;
  CacheSyncState _state = const CacheSyncState();

  BackgroundSyncService({
    required ConnectivityService connectivity,
    required CacheInvalidationService cacheInvalidation,
    required CacheSyncStateListener onStateChanged,
    GeoCoordinateProvider? getSearchCenter,
  })  : _connectivity = connectivity,
        _cacheInvalidation = cacheInvalidation,
        _onStateChanged = onStateChanged;

  CacheSyncState get state => _state;

  void start() {
    _connectivitySub?.cancel();
    _connectivitySub = _connectivity.events.listen((event) {
      SyncLogger.connectivityChanged(isConnected: event.isConnected);
    });
  }

  void dispose() {
    _connectivitySub?.cancel();
  }

  void onAppForeground() {
    _isForeground = true;
  }

  void onAppBackground() {
    _isForeground = false;
  }

  Future<void> syncNow({
    required SyncTrigger trigger,
    GeoCoordinate? center,
  }) async {
    _state = _state.copyWith(isSyncing: true, lastTrigger: trigger);
    _onStateChanged(_state);
    await _cacheInvalidation.purgeStaleEntries();
    _state = _state.copyWith(
      isSyncing: false,
      lastLotsSyncAt: DateTime.now(),
    );
    _onStateChanged(_state);
  }

  bool get isForeground => _isForeground;
}

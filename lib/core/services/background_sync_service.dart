import 'dart:async';

import 'package:psgy/core/cache/cache_metrics.dart';
import 'package:psgy/core/cache/cache_policy.dart';
import 'package:psgy/core/cache/cache_sync_state.dart';
import 'package:psgy/core/monitoring/performance_metrics.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/services/cache_invalidation_service.dart';
import 'package:psgy/core/services/monitoring_service.dart';
import 'package:psgy/core/services/sync_logger.dart';
import 'package:psgy/features/parking/data/datasources/parking_local_datasource.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/repositories/parking_repository.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';

typedef CacheSyncStateListener = void Function(CacheSyncState state);
typedef GeoCoordinateProvider = GeoCoordinate? Function();

class BackgroundSyncService {
  final ConnectivityService _connectivity;
  final ParkingLocalDataSource? _local;
  final UserRepository _userRepository;
  final ParkingRepository _parkingRepository;
  final CacheInvalidationService _cacheInvalidation;
  final MonitoringService? _monitoring;
  final CacheSyncStateListener _onStateChanged;
  final GeoCoordinateProvider _getSearchCenter;

  StreamSubscription<ConnectivityEvent>? _connectivitySub;
  Timer? _periodicTimer;
  Timer? _debounceTimer;
  bool _isForeground = true;
  bool _isRunning = false;
  CacheSyncState _state = const CacheSyncState();

  BackgroundSyncService({
    required ConnectivityService connectivity,
    required UserRepository userRepository,
    required ParkingRepository parkingRepository,
    required CacheInvalidationService cacheInvalidation,
    required CacheSyncStateListener onStateChanged,
    required GeoCoordinateProvider getSearchCenter,
    ParkingLocalDataSource? localDataSource,
    MonitoringService? monitoring,
  })  : _connectivity = connectivity,
        _userRepository = userRepository,
        _parkingRepository = parkingRepository,
        _cacheInvalidation = cacheInvalidation,
        _monitoring = monitoring,
        _onStateChanged = onStateChanged,
        _getSearchCenter = getSearchCenter,
        _local = localDataSource;

  CacheSyncState get state => _state;

  void start() {
    _connectivitySub?.cancel();
    _connectivitySub = _connectivity.events.listen((event) {
      SyncLogger.connectivityChanged(isConnected: event.isConnected);
      if (event.isConnected && event.wasOffline) {
        unawaited(syncNow(trigger: SyncTrigger.connectivity));
      }
    });

    _restartPeriodicTimer();
    unawaited(_refreshMetrics());
  }

  void onAppForeground() {
    _isForeground = true;
    _restartPeriodicTimer();
    unawaited(syncNow(trigger: SyncTrigger.foreground));
  }

  void onAppBackground() {
    _isForeground = false;
    _periodicTimer?.cancel();
  }

  void scheduleSync({
    required SyncTrigger trigger,
    GeoCoordinate? center,
  }) {
    if (!_connectivity.currentStatus) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(CachePolicy.manualSyncDebounce, () {
      unawaited(_runSync(trigger: trigger, center: center));
    });
  }

  Future<void> syncNow({
    required SyncTrigger trigger,
    GeoCoordinate? center,
  }) async {
    if (!_connectivity.currentStatus) return;
    _debounceTimer?.cancel();
    await _runSync(trigger: trigger, center: center);
  }

  Future<void> forceRefresh({GeoCoordinate? center}) async {
    await _cacheInvalidation.invalidateNearbyLots();
    await syncNow(trigger: SyncTrigger.invalidation, center: center);
  }

  Future<void> _runSync({
    required SyncTrigger trigger,
    GeoCoordinate? center,
  }) async {
    if (_isRunning || !_isForeground || !_connectivity.currentStatus) return;

    final searchCenter = center ?? _getSearchCenter();
    if (searchCenter == null) return;

    _isRunning = true;
    _emit(_state.copyWith(isSyncing: true, lastTrigger: trigger, clearError: true));
    SyncLogger.syncStarted(trigger);
    await _monitoring?.startTrace('background_sync');

    final startedAt = DateTime.now();
    var syncedLots = 0;
    var syncedVehicleTypeLots = 0;

    try {
      await _cacheInvalidation.purgeStaleEntries();

      final snapshot = await _userRepository.syncNearbyLots(center: searchCenter);
      syncedLots = snapshot.lots.length;

      syncedVehicleTypeLots = await _syncVehicleTypesForLots(snapshot.lots);

      final metrics = await _refreshMetrics();
      final duration = DateTime.now().difference(startedAt);

      final nextState = _state.copyWith(
        isSyncing: false,
        lastLotsSyncAt: DateTime.now(),
        lastVehicleTypesSyncAt: syncedVehicleTypeLots > 0 ? DateTime.now() : _state.lastVehicleTypesSyncAt,
        lastSyncDuration: duration,
        lastTrigger: trigger,
        metrics: metrics,
        clearError: true,
      );
      _emit(nextState);

      SyncLogger.syncCompleted(
        trigger: trigger,
        duration: duration,
        metrics: metrics,
        syncedLots: syncedLots,
        syncedVehicleTypeLots: syncedVehicleTypeLots,
      );

      _monitoring?.logEvent(
        'background_sync',
        PerformanceMetrics.fromSync(
          state: nextState,
          syncedLots: syncedLots,
          syncedVehicleTypeLots: syncedVehicleTypeLots,
        ),
      );
    } catch (error) {
      _emit(
        _state.copyWith(
          isSyncing: false,
          lastError: error.toString(),
          lastTrigger: trigger,
        ),
      );
      SyncLogger.syncFailed(trigger, error);
      unawaited(
        _monitoring?.recordError(
          error,
          StackTrace.current,
          context: {'trigger': trigger.name},
        ),
      );
    } finally {
      await _monitoring?.stopTrace('background_sync');
      _isRunning = false;
    }
  }

  Future<int> _syncVehicleTypesForLots(List<ParkingLotEntity> lots) async {
    final local = _local;
    if (local == null || lots.isEmpty) return 0;

    var syncedCount = 0;
    for (final lot in lots.take(CachePolicy.maxVehicleTypesLotsPerSync)) {
      try {
        final vehicleTypes = await _parkingRepository.fetchVehicleTypes(lot.id);
        await local.upsertVehicleTypes(lotId: lot.id, vehicleTypes: vehicleTypes);
        syncedCount++;
      } catch (_) {}
    }
    return syncedCount;
  }

  Future<CacheMetrics> _refreshMetrics() async {
    final local = _local;
    if (local == null) return CacheMetrics.empty;

    final metrics = await local.getMetrics();
    _emit(_state.copyWith(metrics: metrics));
    return metrics;
  }

  void _restartPeriodicTimer() {
    _periodicTimer?.cancel();
    if (!_isForeground) return;

    _periodicTimer = Timer.periodic(CachePolicy.backgroundSyncInterval, (_) {
      scheduleSync(trigger: SyncTrigger.periodic);
    });
  }

  void _emit(CacheSyncState next) {
    _state = next;
    _onStateChanged(next);
  }

  Future<void> dispose() async {
    _debounceTimer?.cancel();
    _periodicTimer?.cancel();
    await _connectivitySub?.cancel();
  }
}

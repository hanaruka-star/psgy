import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_link/core/debug/debug_logger.dart';
import 'package:parking_link/core/monitoring/performance_metrics.dart';
import 'package:parking_link/core/network/connectivity_service.dart';
import 'package:parking_link/core/services/monitoring_service.dart';
import 'package:parking_link/features/parking/data/datasources/parking_local_datasource.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/repositories/parking_repository.dart';
import 'package:parking_link/features/user/data/datasources/user_parking_datasource.dart';
import 'package:parking_link/features/user/data/datasources/user_surveying_datasource.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/entities/user_geo_query_config.dart';
import 'package:parking_link/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:parking_link/features/user/domain/entities/user_surveying_lots_snapshot.dart';
import 'package:parking_link/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ParkingRepository _parkingRepository;
  final UserParkingDataSource _parkingDataSource;
  final UserSurveyingDataSource _surveyingDataSource;
  final ParkingLocalDataSource? _local;
  final ConnectivityService? _connectivity;
  final MonitoringService? _monitoring;
  final DebugLogger? _debugLogger;
  List<ParkingLotEntity> _lastNearbyStickyCache = const [];
  List<SurveyingLotEntity> _lastSurveyingStickyCache = const [];

  UserRepositoryImpl(
    this._parkingRepository, {
    UserParkingDataSource? parkingDataSource,
    UserSurveyingDataSource? surveyingDataSource,
    ParkingLocalDataSource? localDataSource,
    ConnectivityService? connectivityService,
    MonitoringService? monitoring,
    DebugLogger? debugLogger,
    FirebaseFirestore? firestore,
  })  : _parkingDataSource = parkingDataSource ??
            UserParkingDataSource(
              firestore ?? FirebaseFirestore.instance,
            ),
        _surveyingDataSource = surveyingDataSource ??
            UserSurveyingDataSource(
              firestore ?? FirebaseFirestore.instance,
            ),
        _local = localDataSource,
        _connectivity = connectivityService,
        _monitoring = monitoring,
        _debugLogger = debugLogger;

  bool get _isOnline => _connectivity?.currentStatus ?? true;

  @override
  Stream<List<ParkingLotEntity>> watchAllLots() {
    return _parkingRepository.watchAllLots();
  }

  @override
  Stream<UserNearbyLotsSnapshot> watchNearbyLots({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxNearbyLots,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    final effectiveRadius = radiusKm.clamp(
      UserGeoQueryConfig.minRadiusKm,
      UserGeoQueryConfig.maxRadiusKm,
    );
    final effectiveMax = maxResults.clamp(1, UserGeoQueryConfig.maxNearbyLots);

    return Stream.multi((controller) async {
      StreamSubscription<UserNearbyLotsSnapshot>? subscription;
      StreamSubscription<List<ParkingLotEntity>>? cacheSub;
      var isCancelled = false;
      final local = _local;
      final startedAt = DateTime.now();
      var cacheEmitIndex = 0;

      await _monitoring?.startTrace('watch_nearby_lots');

      controller.onCancel = () async {
        isCancelled = true;
        await cacheSub?.cancel();
        await subscription?.cancel();
        await _monitoring?.stopTrace('watch_nearby_lots');
      };

      void logSnapshot(UserNearbyLotsSnapshot snapshot) {
        _monitoring?.logEvent(
          'watch_nearby_lots',
          PerformanceMetrics.fromNearbyQuery(
            lotCount: snapshot.lots.length,
            mode: snapshot.mode.name,
            durationMs: DateTime.now().difference(startedAt).inMilliseconds,
          ),
        );
      }

      void emitCache(List<ParkingLotEntity> cached) {
        if (isCancelled) return;
        final effective = cached.isEmpty && _lastNearbyStickyCache.isNotEmpty
            ? _lastNearbyStickyCache
            : cached;
        if (effective.isNotEmpty) {
          _lastNearbyStickyCache = effective;
        }
        cacheEmitIndex++;
        final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
        if (cacheEmitIndex <= 2) {
          _debugLogger?.logThrottled(
            'load_speed_nearby',
            '[LoadSpeed] cacheFirstEmit=$cacheEmitIndex nearby=${effective.length} time=${elapsedMs}ms',
            throttleMs: 1200,
            minLevel: DebugLogLevel.verbose,
          );
        }
        _debugLogger?.logThrottled(
          'nearby_cache_emit',
          '[Nearby] cache stream emit=${effective.length} '
              'center=${center.latitude.toStringAsFixed(4)},${center.longitude.toStringAsFixed(4)}',
          minLevel: DebugLogLevel.verbose,
        );
        final snapshot = UserNearbyLotsSnapshot(
          lots: effective,
          mode: UserNearbyLotsQueryMode.cache,
        );
        logSnapshot(snapshot);
        controller.add(snapshot);
      }

      if (enableCache && local != null) {
        if (_lastNearbyStickyCache.isNotEmpty) {
          emitCache(_lastNearbyStickyCache);
        }
        try {
          final quick = await _readNearbyParkingCache(
            local: local,
            center: center,
            radiusKm: effectiveRadius,
            maxResults: effectiveMax,
            widenIfEmpty: false,
          );
          emitCache(quick);
          if (quick.isEmpty) {
            unawaited(() async {
              final widened = await _readNearbyParkingCache(
                local: local,
                center: center,
                radiusKm: effectiveRadius,
                maxResults: effectiveMax,
                widenIfEmpty: true,
              );
              if (!isCancelled && widened.isNotEmpty) {
                emitCache(widened);
              }
            }());
          }
        } catch (_) {}

        cacheSub = local
            .watchNearbyLots(
          centerLat: center.latitude,
          centerLng: center.longitude,
          radiusKm: effectiveRadius,
          maxResults: effectiveMax,
        )
            .listen(
          (cached) {
            emitCache(cached);
            if (cached.isEmpty) {
              unawaited(() async {
                final widened = await _readNearbyParkingCache(
                  local: local,
                  center: center,
                  radiusKm: effectiveRadius,
                  maxResults: effectiveMax,
                  widenIfEmpty: true,
                );
                if (!isCancelled && widened.isNotEmpty) {
                  emitCache(widened);
                }
              }());
            }
          },
          onError: (_) {},
        );
      }

      if (!enableNetwork) {
        if (!enableCache || local == null) {
          await controller.close();
        }
        return;
      }

      if (!_isOnline) {
        if (!enableCache || local == null) {
          await controller.close();
        }
        return;
      }

      subscription = _watchNearbyLotsFromNetwork(
        center: center,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
        onSnapshot: logSnapshot,
      ).listen(
        (snapshot) {
          if (snapshot.lots.isEmpty) {
            _debugLogger?.logThrottled(
              'nearby_network_empty',
              '[Nearby] network empty — keep cache snapshot',
              throttleMs: 1500,
              minLevel: DebugLogLevel.verbose,
            );
            if (_lastNearbyStickyCache.isNotEmpty) {
              controller.add(
                UserNearbyLotsSnapshot(
                  lots: _lastNearbyStickyCache,
                  mode: UserNearbyLotsQueryMode.cache,
                ),
              );
            }
            return;
          }
          _lastNearbyStickyCache = snapshot.lots;
          logSnapshot(snapshot);
          controller.add(snapshot);
        },
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: false,
      );
    });
  }

  @override
  Future<UserNearbyLotsSnapshot> syncNearbyLots({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxNearbyLots,
  }) async {
    final effectiveRadius = radiusKm.clamp(
      UserGeoQueryConfig.minRadiusKm,
      UserGeoQueryConfig.maxRadiusKm,
    );
    final effectiveMax = maxResults.clamp(1, UserGeoQueryConfig.maxNearbyLots);
    final startedAt = DateTime.now();

    if (!_isOnline) {
      if (_local == null) {
        throw StateError('Offline and no local cache available.');
      }

      final cached = await _local.getNearbyLots(
        centerLat: center.latitude,
        centerLng: center.longitude,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
      );

      final snapshot = UserNearbyLotsSnapshot(
        lots: cached,
        mode: UserNearbyLotsQueryMode.cache,
      );
      _monitoring?.logEvent(
        'sync_nearby_lots',
        PerformanceMetrics.fromNearbyQuery(
          lotCount: snapshot.lots.length,
          mode: snapshot.mode.name,
          durationMs: DateTime.now().difference(startedAt).inMilliseconds,
        ),
      );
      return snapshot;
    }

    try {
      final lots = await _parkingDataSource.fetchClientSideNearbyLotsOnce(
        center: center,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
      );
      await _local?.upsertLots(lots);
      final snapshot = UserNearbyLotsSnapshot(
        lots: lots,
        mode: UserNearbyLotsQueryMode.clientSide,
      );
      _monitoring?.logEvent(
        'sync_nearby_lots',
        PerformanceMetrics.fromNearbyQuery(
          lotCount: snapshot.lots.length,
          mode: snapshot.mode.name,
          durationMs: DateTime.now().difference(startedAt).inMilliseconds,
        ),
      );
      return snapshot;
    } catch (_) {
      final lots = await _parkingDataSource.fetchAllLotsLimitedOnce(
        maxResults: effectiveMax,
      );
      await _local?.upsertLots(lots);
      final snapshot = UserNearbyLotsSnapshot(
        lots: lots,
        mode: UserNearbyLotsQueryMode.fallbackAll,
      );
      _monitoring?.logEvent(
        'sync_nearby_lots',
        PerformanceMetrics.fromNearbyQuery(
          lotCount: snapshot.lots.length,
          mode: snapshot.mode.name,
          durationMs: DateTime.now().difference(startedAt).inMilliseconds,
        ),
      );
      return snapshot;
    }
  }

  @override
  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId) {
    return _parkingRepository.watchVehicleTypes(lotId);
  }

  @override
  Stream<UserSurveyingLotsSnapshot> watchSurveyingLots({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxSurveyingLots,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    final effectiveRadius = radiusKm.clamp(
      UserGeoQueryConfig.minRadiusKm,
      UserGeoQueryConfig.maxRadiusKm,
    );
    final effectiveMax =
        maxResults.clamp(1, UserGeoQueryConfig.maxSurveyingLots);

    return Stream.multi((controller) async {
      StreamSubscription<UserSurveyingLotsSnapshot>? subscription;
      StreamSubscription<List<SurveyingLotEntity>>? cacheSub;
      var isCancelled = false;
      final local = _local;
      final startedAt = DateTime.now();
      var cacheEmitIndex = 0;

      await _monitoring?.startTrace('watch_surveying_lots');

      controller.onCancel = () async {
        isCancelled = true;
        await cacheSub?.cancel();
        await subscription?.cancel();
        await _monitoring?.stopTrace('watch_surveying_lots');
      };

      void emitCache(List<SurveyingLotEntity> cached) {
        if (isCancelled) return;
        final effective = cached.isEmpty && _lastSurveyingStickyCache.isNotEmpty
            ? _lastSurveyingStickyCache
            : cached;
        if (effective.isNotEmpty) {
          _lastSurveyingStickyCache = effective;
        }
        cacheEmitIndex++;
        final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
        if (cacheEmitIndex <= 2) {
          _debugLogger?.logThrottled(
            'load_speed_surveying',
            '[LoadSpeed] cacheFirstEmit=$cacheEmitIndex surveying=${effective.length} time=${elapsedMs}ms',
            throttleMs: 1200,
            minLevel: DebugLogLevel.verbose,
          );
        }
        _debugLogger?.logThrottled(
          'surveying_cache_emit',
          '[Surveying] cache stream emit=${effective.length} '
              'center=${center.latitude.toStringAsFixed(4)},${center.longitude.toStringAsFixed(4)}',
          minLevel: DebugLogLevel.verbose,
        );
        controller.add(
          UserSurveyingLotsSnapshot(
            lots: effective,
            mode: UserSurveyingLotsQueryMode.cache,
          ),
        );
      }

      if (enableCache && local != null) {
        if (_lastSurveyingStickyCache.isNotEmpty) {
          emitCache(_lastSurveyingStickyCache);
        }
        try {
          final quick = await _readSurveyingCache(
            local: local,
            center: center,
            radiusKm: effectiveRadius,
            maxResults: effectiveMax,
            widenIfEmpty: false,
          );
          emitCache(quick);
          if (quick.isEmpty) {
            unawaited(() async {
              final widened = await _readSurveyingCache(
                local: local,
                center: center,
                radiusKm: effectiveRadius,
                maxResults: effectiveMax,
                widenIfEmpty: true,
              );
              if (!isCancelled && widened.isNotEmpty) {
                emitCache(widened);
              }
            }());
          }
        } catch (_) {}

        cacheSub = local
            .watchNearbySurveyingLots(
          centerLat: center.latitude,
          centerLng: center.longitude,
          radiusKm: effectiveRadius,
          maxResults: effectiveMax,
        )
            .listen(
          (cached) {
            emitCache(cached);
            if (cached.isEmpty) {
              unawaited(() async {
                final widened = await _readSurveyingCache(
                  local: local,
                  center: center,
                  radiusKm: effectiveRadius,
                  maxResults: effectiveMax,
                  widenIfEmpty: true,
                );
                if (!isCancelled && widened.isNotEmpty) {
                  emitCache(widened);
                }
              }());
            }
          },
          onError: (_) {},
        );
      }

      if (!enableNetwork) {
        if (!enableCache || local == null) {
          await controller.close();
        }
        return;
      }

      if (!_isOnline) {
        if (!enableCache || local == null) {
          await controller.close();
        }
        return;
      }

      subscription = _watchSurveyingLotsFromNetwork(
        center: center,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
      ).listen(
        (snapshot) async {
          if (snapshot.lots.isEmpty) {
            _debugLogger?.logThrottled(
              'surveying_network_empty',
              '[Surveying] network empty — keep cache snapshot',
              throttleMs: 1500,
              minLevel: DebugLogLevel.verbose,
            );
            _debugLogger?.logThrottled(
              'surveying_network_empty_sticky',
              '[Surveying] stickyCache=${_lastSurveyingStickyCache.length} | '
                  'networkEmpty | finalDisplay=${_lastSurveyingStickyCache.length}',
              throttleMs: 1500,
              minLevel: DebugLogLevel.verbose,
            );
            if (_lastSurveyingStickyCache.isNotEmpty) {
              controller.add(
                UserSurveyingLotsSnapshot(
                  lots: _lastSurveyingStickyCache,
                  mode: UserSurveyingLotsQueryMode.cache,
                ),
              );
              return;
            }

            if (local != null) {
              final globalCached =
                  await local.getAllCachedSurveyingLotsIgnoringTtl(
                maxResults: effectiveMax,
              );
              if (!isCancelled && globalCached.isNotEmpty) {
                _lastSurveyingStickyCache = globalCached;
                controller.add(
                  UserSurveyingLotsSnapshot(
                    lots: globalCached,
                    mode: UserSurveyingLotsQueryMode.cache,
                  ),
                );
                return;
              }
            }

            if (!isCancelled) {
              controller.add(
                const UserSurveyingLotsSnapshot(
                  lots: [],
                  mode: UserSurveyingLotsQueryMode.cache,
                ),
              );
            }
            return;
          }
          _lastSurveyingStickyCache = snapshot.lots;
          controller.add(snapshot);
        },
        onError: (error, stackTrace) {
          _debugLogger?.logThrottled(
            'surveying_network_fetch_failed',
            '[Firestore] network fetch failed: $error | using cache only',
            throttleMs: 2000,
            minLevel: DebugLogLevel.normal,
          );
          if (_lastSurveyingStickyCache.isNotEmpty) {
            controller.add(
              UserSurveyingLotsSnapshot(
                lots: _lastSurveyingStickyCache,
                mode: UserSurveyingLotsQueryMode.cache,
              ),
            );
            return;
          }
          controller.addError(error, stackTrace);
        },
        onDone: controller.close,
        cancelOnError: false,
      );
    });
  }

  @override
  Future<UserSurveyingLotsSnapshot> syncSurveyingLots({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxSurveyingLots,
  }) async {
    final effectiveRadius = radiusKm.clamp(
      UserGeoQueryConfig.minRadiusKm,
      UserGeoQueryConfig.maxRadiusKm,
    );
    final effectiveMax =
        maxResults.clamp(1, UserGeoQueryConfig.maxSurveyingLots);

    if (!_isOnline) {
      if (_local == null) {
        throw StateError('Offline and no local cache available.');
      }

      final cached = await _local.getNearbySurveyingLots(
        centerLat: center.latitude,
        centerLng: center.longitude,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
      );

      return UserSurveyingLotsSnapshot(
        lots: cached,
        mode: UserSurveyingLotsQueryMode.cache,
      );
    }

    try {
      final lots = await _surveyingDataSource.fetchClientSideNearbyLotsOnce(
        center: center,
        radiusKm: effectiveRadius,
        maxResults: effectiveMax,
      );
      await _local?.upsertSurveyingLots(lots);
      return UserSurveyingLotsSnapshot(
        lots: lots,
        mode: UserSurveyingLotsQueryMode.clientSide,
      );
    } catch (_) {
      return const UserSurveyingLotsSnapshot(
        lots: [],
        mode: UserSurveyingLotsQueryMode.fallbackAll,
      );
    }
  }

  Stream<UserSurveyingLotsSnapshot> _watchSurveyingLotsFromNetwork({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    late StreamController<UserSurveyingLotsSnapshot> controller;
    StreamSubscription<List<SurveyingLotEntity>>? subscription;
    var isCancelled = false;

    Future<void> emitLots(
      List<SurveyingLotEntity> lots,
      UserSurveyingLotsQueryMode mode,
    ) async {
      if (isCancelled) return;
      await _local?.upsertSurveyingLots(lots);
      controller.add(UserSurveyingLotsSnapshot(lots: lots, mode: mode));
    }

    Future<void> listenWithFallback({
      required Stream<List<SurveyingLotEntity>> stream,
      required UserSurveyingLotsQueryMode mode,
      required Future<void> Function(Object error, StackTrace stackTrace)
          onError,
    }) async {
      subscription?.cancel();
      subscription = stream.listen(
        (lots) => emitLots(lots, mode),
        onError: onError,
      );
    }

    controller = StreamController<UserSurveyingLotsSnapshot>(
      onListen: () async {
        await listenWithFallback(
          stream: _surveyingDataSource.watchGeohashNearbyLots(
            center: center,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
          mode: UserSurveyingLotsQueryMode.geohash,
          onError: (_, __) async {
            await listenWithFallback(
              stream: _surveyingDataSource.watchClientSideNearbyLots(
                center: center,
                radiusKm: radiusKm,
                maxResults: maxResults,
              ),
              mode: UserSurveyingLotsQueryMode.clientSide,
              onError: (error, stackTrace) async {
                _debugLogger?.logThrottled(
                  'surveying_network_fetch_failed_fallback',
                  '[Firestore] network fetch failed: $error | using cache only',
                  throttleMs: 2000,
                  minLevel: DebugLogLevel.normal,
                );
                if (_lastSurveyingStickyCache.isNotEmpty) {
                  controller.add(
                    UserSurveyingLotsSnapshot(
                      lots: _lastSurveyingStickyCache,
                      mode: UserSurveyingLotsQueryMode.cache,
                    ),
                  );
                  return;
                }
                if (!isCancelled) {
                  controller.addError(error, stackTrace);
                }
              },
            );
          },
        );
      },
      onCancel: () async {
        isCancelled = true;
        await subscription?.cancel();
      },
    );

    return controller.stream;
  }

  Stream<UserNearbyLotsSnapshot> _watchNearbyLotsFromNetwork({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
    void Function(UserNearbyLotsSnapshot snapshot)? onSnapshot,
  }) {
    late StreamController<UserNearbyLotsSnapshot> controller;
    StreamSubscription<List<ParkingLotEntity>>? subscription;
    var isCancelled = false;

    Future<void> emitLots(
      List<ParkingLotEntity> lots,
      UserNearbyLotsQueryMode mode,
    ) async {
      if (isCancelled) return;
      await _local?.upsertLots(lots);
      final snapshot = UserNearbyLotsSnapshot(lots: lots, mode: mode);
      onSnapshot?.call(snapshot);
      controller.add(snapshot);
    }

    Future<void> listenWithFallback({
      required Stream<List<ParkingLotEntity>> stream,
      required UserNearbyLotsQueryMode mode,
      required Future<void> Function(Object error, StackTrace stackTrace)
          onError,
    }) async {
      subscription?.cancel();
      subscription = stream.listen(
        (lots) => emitLots(lots, mode),
        onError: onError,
      );
    }

    controller = StreamController<UserNearbyLotsSnapshot>(
      onListen: () async {
        await listenWithFallback(
          stream: _parkingDataSource.watchGeohashNearbyLots(
            center: center,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
          mode: UserNearbyLotsQueryMode.geohash,
          onError: (_, __) async {
            await listenWithFallback(
              stream: _parkingDataSource.watchClientSideNearbyLots(
                center: center,
                radiusKm: radiusKm,
                maxResults: maxResults,
              ),
              mode: UserNearbyLotsQueryMode.clientSide,
              onError: (_, __) async {
                await listenWithFallback(
                  stream: _parkingDataSource.watchAllLotsLimited(
                    maxResults: maxResults,
                  ),
                  mode: UserNearbyLotsQueryMode.fallbackAll,
                  onError: (error, stackTrace) async {
                    if (!isCancelled) {
                      controller.addError(error, stackTrace);
                    }
                  },
                );
              },
            );
          },
        );
      },
      onCancel: () async {
        isCancelled = true;
        await subscription?.cancel();
      },
    );

    return controller.stream;
  }
}

Future<List<ParkingLotEntity>> _readNearbyParkingCache({
  required ParkingLocalDataSource local,
  required GeoCoordinate center,
  required double radiusKm,
  required int maxResults,
  bool widenIfEmpty = true,
}) async {
  var cached = await local.getNearbyLots(
    centerLat: center.latitude,
    centerLng: center.longitude,
    radiusKm: radiusKm,
    maxResults: maxResults,
  );
  if (!widenIfEmpty || cached.isNotEmpty) return cached;

  final total = await local.countCachedParkingLots();
  if (total == 0) return cached;

  return local.getNearbyLots(
    centerLat: center.latitude,
    centerLng: center.longitude,
    radiusKm: UserGeoQueryConfig.maxRadiusKm,
    maxResults: maxResults,
  );
}

Future<List<SurveyingLotEntity>> _readSurveyingCache({
  required ParkingLocalDataSource local,
  required GeoCoordinate center,
  required double radiusKm,
  required int maxResults,
  bool widenIfEmpty = true,
}) async {
  var cached = await local.getNearbySurveyingLots(
    centerLat: center.latitude,
    centerLng: center.longitude,
    radiusKm: radiusKm,
    maxResults: maxResults,
  );
  if (!widenIfEmpty || cached.isNotEmpty) return cached;

  final widened = await local.getNearbySurveyingLots(
    centerLat: center.latitude,
    centerLng: center.longitude,
    radiusKm: UserGeoQueryConfig.maxRadiusKm,
    maxResults: maxResults,
  );
  if (widened.isNotEmpty) return widened;

  final total = await local.countCachedSurveyingLots();
  if (total == 0) return cached;

  return local.getAllCachedSurveyingLots(maxResults: maxResults);
}

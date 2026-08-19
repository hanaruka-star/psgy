import 'dart:async';

import 'package:isar/isar.dart';
import 'package:parking_link/core/cache/cache_metrics.dart';
import 'package:parking_link/core/cache/cache_policy.dart';
import 'package:parking_link/core/monitoring/performance_metrics.dart';
import 'package:parking_link/core/services/monitoring_service.dart';
import 'package:parking_link/core/utils/geohash_utils.dart';
import 'package:parking_link/features/parking/data/local/isar_mappers.dart';
import 'package:parking_link/features/parking/data/local/parking_lot_isar.dart';
import 'package:parking_link/features/parking/data/local/parking_session_isar.dart';
import 'package:parking_link/features/parking/data/local/surveying_lot_isar.dart';
import 'package:parking_link/features/parking/data/local/vehicle_type_isar.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/core/utils/geo_distance.dart';

class ParkingLocalDataSource {
  final Isar _isar;
  final MonitoringService? _monitoring;

  ParkingLocalDataSource(
    this._isar, {
    MonitoringService? monitoring,
  }) : _monitoring = monitoring;

  Future<List<ParkingLotEntity>> getAllLots() {
    return _traceRead(
      operation: 'get_all_lots',
      run: () async {
        final models = await _isar.parkingLotIsars.where().findAll();
        return models.map(IsarMappers.lotFromIsar).toList(growable: false);
      },
    );
  }

  Stream<List<ParkingLotEntity>> watchAllLots() {
    return _isar.parkingLotIsars
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getAllLots());
  }

  Future<List<ParkingLotEntity>> getNearbyLots({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
    Duration ttl = CachePolicy.nearbyLotsTtl,
  }) {
    return _traceRead(
      operation: 'get_nearby_lots',
      run: () async {
        final geohashLots = await _queryLotsInGeohashRange(
          centerLat: centerLat,
          centerLng: centerLng,
          radiusKm: radiusKm,
          maxResults: maxResults,
          ttl: ttl,
          collection: _LotQueryTarget.parking,
        );

        if (geohashLots.isNotEmpty) {
          return geohashLots.cast<ParkingLotEntity>();
        }

        final fallback = await _filterAllCachedLotsByDistance(
          centerLat: centerLat,
          centerLng: centerLng,
          radiusKm: radiusKm,
          maxResults: maxResults,
          ttl: ttl,
          target: _LotQueryTarget.parking,
        );
        return fallback.cast<ParkingLotEntity>();
      },
    );
  }

  Stream<List<ParkingLotEntity>> watchNearbyLots({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
  }) {
    return _isar.parkingLotIsars.watchLazy(fireImmediately: true).asyncMap(
          (_) => getNearbyLots(
            centerLat: centerLat,
            centerLng: centerLng,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
        );
  }

  Future<void> upsertLots(List<ParkingLotEntity> lots) {
    if (lots.isEmpty) return Future<void>.value();

    return _traceWrite(
      operation: 'upsert_lots',
      itemCount: lots.length,
      run: () async {
        await _isar.writeTxn(() async {
          for (final lot in lots) {
            await _isar.parkingLotIsars.put(IsarMappers.lotToIsar(lot));
          }
        });
      },
    );
  }

  Future<void> deleteLot(String lotId) {
    return _traceWrite(
      operation: 'delete_lot',
      itemCount: 1,
      run: () async {
        await _isar.writeTxn(() async {
          await _isar.parkingLotIsars.filter().lotIdEqualTo(lotId).deleteAll();
        });
      },
    );
  }

  Future<List<VehicleTypeEntity>> getVehicleTypes(String lotId) {
    return _traceRead(
      operation: 'get_vehicle_types',
      run: () async {
        final models = await _isar.vehicleTypeIsars
            .filter()
            .lotIdEqualTo(lotId)
            .findAll();
        return models
            .map(IsarMappers.vehicleTypeFromIsar)
            .toList(growable: false);
      },
    );
  }

  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId) {
    return _isar.vehicleTypeIsars
        .filter()
        .lotIdEqualTo(lotId)
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getVehicleTypes(lotId));
  }

  Future<void> upsertVehicleTypes({
    required String lotId,
    required List<VehicleTypeEntity> vehicleTypes,
  }) {
    return _traceWrite(
      operation: 'upsert_vehicle_types',
      itemCount: vehicleTypes.length,
      run: () async {
        await _isar.writeTxn(() async {
          await _isar.vehicleTypeIsars.filter().lotIdEqualTo(lotId).deleteAll();
          for (final vehicleType in vehicleTypes) {
            await _isar.vehicleTypeIsars.put(
              IsarMappers.vehicleTypeToIsar(
                lotId: lotId,
                entity: vehicleType,
              ),
            );
          }
        });
      },
    );
  }

  Future<List<ParkingSessionEntity>> getActiveSessions({
    required String lotId,
    required String vehicleType,
  }) {
    return _traceRead(
      operation: 'get_active_sessions',
      run: () async {
        final models = await _isar.parkingSessionIsars
            .filter()
            .lotIdEqualTo(lotId)
            .vehicleTypeEqualTo(vehicleType)
            .statusEqualTo('active')
            .sortByCheckedInAtDesc()
            .findAll();

        return models.map(IsarMappers.sessionFromIsar).toList(growable: false);
      },
    );
  }

  Stream<List<ParkingSessionEntity>> watchActiveSessions({
    required String lotId,
    required String vehicleType,
  }) {
    return _isar.parkingSessionIsars
        .filter()
        .lotIdEqualTo(lotId)
        .vehicleTypeEqualTo(vehicleType)
        .statusEqualTo('active')
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getActiveSessions(lotId: lotId, vehicleType: vehicleType));
  }

  Future<void> upsertSessions(List<ParkingSessionEntity> sessions) {
    if (sessions.isEmpty) return Future<void>.value();

    return _traceWrite(
      operation: 'upsert_sessions',
      itemCount: sessions.length,
      run: () async {
        await _isar.writeTxn(() async {
          for (final session in sessions) {
            await _isar.parkingSessionIsars.put(IsarMappers.sessionToIsar(session));
          }
        });
      },
    );
  }

  Future<void> clearAll() {
    return _traceWrite(
      operation: 'clear_all',
      itemCount: 0,
      run: () async {
        await _isar.writeTxn(() async {
          await _isar.clear();
        });
      },
    );
  }

  Future<DateTime?> getLatestLotsCachedAt() async {
    final latest = await _isar.parkingLotIsars
        .where()
        .sortByCachedAtDesc()
        .findFirst();
    return latest?.cachedAt;
  }

  Future<CacheMetrics> getMetrics() {
    return _traceRead(
      operation: 'get_metrics',
      run: () async {
        final lotsCount = await _isar.parkingLotIsars.count();
        final vehicleTypesCount = await _isar.vehicleTypeIsars.count();
        final sessionsCount = await _isar.parkingSessionIsars.count();
        final latestLot = await _isar.parkingLotIsars
            .where()
            .sortByCachedAtDesc()
            .findFirst();
        final latestVehicleType = await _isar.vehicleTypeIsars
            .where()
            .sortByCachedAtDesc()
            .findFirst();

        return CacheMetrics(
          lotsCount: lotsCount,
          vehicleTypesCount: vehicleTypesCount,
          sessionsCount: sessionsCount,
          latestLotsCachedAt: latestLot?.cachedAt,
          latestVehicleTypesCachedAt: latestVehicleType?.cachedAt,
        );
      },
    );
  }

  Future<void> purgeExpiredLots({required Duration ttl}) {
    return _traceWrite(
      operation: 'purge_expired_lots',
      itemCount: 0,
      run: () async {
        if (ttl <= Duration.zero) {
          await _isar.writeTxn(() async {
            await _isar.parkingLotIsars.clear();
          });
          return;
        }

        final minCachedAt = DateTime.now().subtract(ttl);
        await _isar.writeTxn(() async {
          await _isar.parkingLotIsars
              .filter()
              .cachedAtLessThan(minCachedAt)
              .deleteAll();
        });
      },
    );
  }

  Future<void> purgeExpiredVehicleTypes({required Duration ttl}) {
    return _traceWrite(
      operation: 'purge_expired_vehicle_types',
      itemCount: 0,
      run: () async {
        if (ttl <= Duration.zero) {
          await _isar.writeTxn(() async {
            await _isar.vehicleTypeIsars.clear();
          });
          return;
        }

        final minCachedAt = DateTime.now().subtract(ttl);
        await _isar.writeTxn(() async {
          await _isar.vehicleTypeIsars
              .filter()
              .cachedAtLessThan(minCachedAt)
              .deleteAll();
        });
      },
    );
  }

  Future<List<SurveyingLotEntity>> getNearbySurveyingLots({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
    Duration ttl = CachePolicy.nearbyLotsTtl,
  }) {
    return _traceRead(
      operation: 'get_nearby_surveying_lots',
      run: () async {
        final geohashLots = await _queryLotsInGeohashRange(
          centerLat: centerLat,
          centerLng: centerLng,
          radiusKm: radiusKm,
          maxResults: maxResults,
          ttl: ttl,
          collection: _LotQueryTarget.surveying,
        );

        if (geohashLots.isNotEmpty) {
          return geohashLots.cast<SurveyingLotEntity>();
        }

        final fallback = await _filterAllCachedLotsByDistance(
          centerLat: centerLat,
          centerLng: centerLng,
          radiusKm: radiusKm,
          maxResults: maxResults,
          ttl: ttl,
          target: _LotQueryTarget.surveying,
        );
        return fallback.cast<SurveyingLotEntity>();
      },
    );
  }

  Stream<List<SurveyingLotEntity>> watchNearbySurveyingLots({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
  }) {
    return _isar.surveyingLotIsars.watchLazy(fireImmediately: true).asyncMap(
          (_) => getNearbySurveyingLots(
            centerLat: centerLat,
            centerLng: centerLng,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
        );
  }

  Future<int> countCachedParkingLots() async {
    return _isar.parkingLotIsars.count();
  }

  Future<int> countCachedSurveyingLots() async {
    return _isar.surveyingLotIsars.count();
  }

  /// Last-resort read when geohash/radius queries return empty but cache has rows.
  Future<List<SurveyingLotEntity>> getAllCachedSurveyingLots({
    required int maxResults,
    Duration ttl = CachePolicy.nearbyLotsTtl,
  }) {
    return _traceRead(
      operation: 'get_all_cached_surveying_lots',
      run: () async {
        final minCachedAt = DateTime.now().subtract(ttl);
        final models = await _isar.surveyingLotIsars
            .filter()
            .cachedAtGreaterThan(minCachedAt)
            .limit(maxResults)
            .findAll();
        return models
            .map(IsarMappers.surveyingLotFromIsar)
            .toList(growable: false);
      },
    );
  }

  /// Emergency fallback: read all surveying cache regardless TTL.
  Future<List<SurveyingLotEntity>> getAllCachedSurveyingLotsIgnoringTtl({
    required int maxResults,
  }) {
    return _traceRead(
      operation: 'get_all_cached_surveying_lots_ignore_ttl',
      run: () async {
        final models =
            await _isar.surveyingLotIsars.where().limit(maxResults).findAll();
        return models
            .map(IsarMappers.surveyingLotFromIsar)
            .toList(growable: false);
      },
    );
  }

  Future<List<dynamic>> _queryLotsInGeohashRange({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
    required Duration ttl,
    required _LotQueryTarget collection,
  }) async {
    final range = GeohashUtils.queryRange(
      latitude: centerLat,
      longitude: centerLng,
      radiusKm: radiusKm,
    );
    final minCachedAt = DateTime.now().subtract(ttl);

    if (collection == _LotQueryTarget.parking) {
      final candidates = await _isar.parkingLotIsars
          .filter()
          .geohashBetween(range.start, range.end)
          .cachedAtGreaterThan(minCachedAt)
          .findAll();

      return _sortByDistance(
        items: candidates.map((model) {
          final entity = IsarMappers.lotFromIsar(model);
          return (
            entity: entity as dynamic,
            distanceKm: GeoDistance.kmBetweenCoordinates(
              centerLat,
              centerLng,
              entity.lat,
              entity.lng,
            ),
          );
        }),
        radiusKm: radiusKm,
        maxResults: maxResults,
      );
    }

    final candidates = await _isar.surveyingLotIsars
        .filter()
        .geohashBetween(range.start, range.end)
        .cachedAtGreaterThan(minCachedAt)
        .findAll();

    return _sortByDistance(
      items: candidates.map((model) {
        final entity = IsarMappers.surveyingLotFromIsar(model);
        return (
          entity: entity as dynamic,
          distanceKm: GeoDistance.kmBetweenCoordinates(
            centerLat,
            centerLng,
            entity.lat,
            entity.lng,
          ),
        );
      }),
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }

  Future<List<dynamic>> _filterAllCachedLotsByDistance({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int maxResults,
    required Duration ttl,
    required _LotQueryTarget target,
  }) async {
    final minCachedAt = DateTime.now().subtract(ttl);

    if (target == _LotQueryTarget.parking) {
      final models = await _isar.parkingLotIsars
          .filter()
          .cachedAtGreaterThan(minCachedAt)
          .findAll();

      return _sortByDistance(
        items: models.map((model) {
          final entity = IsarMappers.lotFromIsar(model);
          return (
            entity: entity as dynamic,
            distanceKm: GeoDistance.kmBetweenCoordinates(
              centerLat,
              centerLng,
              entity.lat,
              entity.lng,
            ),
          );
        }),
        radiusKm: radiusKm,
        maxResults: maxResults,
      );
    }

    final models = await _isar.surveyingLotIsars
        .filter()
        .cachedAtGreaterThan(minCachedAt)
        .findAll();

    return _sortByDistance(
      items: models.map((model) {
        final entity = IsarMappers.surveyingLotFromIsar(model);
        return (
          entity: entity as dynamic,
          distanceKm: GeoDistance.kmBetweenCoordinates(
            centerLat,
            centerLng,
            entity.lat,
            entity.lng,
          ),
        );
      }),
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }

  List<dynamic> _sortByDistance({
    required Iterable<({dynamic entity, double distanceKm})> items,
    required double radiusKm,
    required int maxResults,
  }) {
    final lotsWithDistance = items
        .where((item) => item.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return lotsWithDistance
        .take(maxResults)
        .map((item) => item.entity)
        .toList(growable: false);
  }

  Future<void> upsertSurveyingLots(List<SurveyingLotEntity> lots) {
    if (lots.isEmpty) return Future<void>.value();

    return _traceWrite(
      operation: 'upsert_surveying_lots',
      itemCount: lots.length,
      run: () async {
        await _isar.writeTxn(() async {
          for (final lot in lots) {
            await _isar.surveyingLotIsars.put(
              IsarMappers.surveyingLotToIsar(lot),
            );
          }
        });
      },
    );
  }

  Future<void> purgeExpiredSurveyingLots({required Duration ttl}) {
    return _traceWrite(
      operation: 'purge_expired_surveying_lots',
      itemCount: 0,
      run: () async {
        if (ttl <= Duration.zero) {
          await _isar.writeTxn(() async {
            await _isar.surveyingLotIsars.clear();
          });
          return;
        }

        final minCachedAt = DateTime.now().subtract(ttl);
        await _isar.writeTxn(() async {
          await _isar.surveyingLotIsars
              .filter()
              .cachedAtLessThan(minCachedAt)
              .deleteAll();
        });
      },
    );
  }

  Future<T> _traceRead<T>({
    required String operation,
    required Future<T> Function() run,
  }) async {
    final monitoring = _monitoring;
    final startedAt = DateTime.now();
    await monitoring?.startTrace('isar_read');

    try {
      final result = await run();
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      final itemCount = result is List ? result.length : 1;
      monitoring?.putTraceMetric('isar_read', 'item_count', itemCount);
      monitoring?.putTraceMetric('isar_read', 'duration_ms', durationMs);
      monitoring?.logEvent(
        'isar_read',
        PerformanceMetrics.fromIsar(
          operation: operation,
          itemCount: itemCount,
          durationMs: durationMs,
        ),
      );
      return result;
    } finally {
      await monitoring?.stopTrace('isar_read');
    }
  }

  Future<void> _traceWrite({
    required String operation,
    required int itemCount,
    required Future<void> Function() run,
  }) async {
    final monitoring = _monitoring;
    final startedAt = DateTime.now();
    await monitoring?.startTrace('isar_write');

    try {
      await run();
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      monitoring?.putTraceMetric('isar_write', 'item_count', itemCount);
      monitoring?.putTraceMetric('isar_write', 'duration_ms', durationMs);
      monitoring?.logEvent(
        'isar_write',
        PerformanceMetrics.fromIsar(
          operation: operation,
          itemCount: itemCount,
          durationMs: durationMs,
        ),
      );
    } finally {
      await monitoring?.stopTrace('isar_write');
    }
  }
}

enum _LotQueryTarget { parking, surveying }

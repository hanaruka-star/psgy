import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/debug/debug_logger.dart';
import 'package:psgy/core/di/debug_providers.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/geo_distance.dart';
import 'package:psgy/features/user/domain/entities/map_lot_item.dart';
import 'package:psgy/features/user/domain/entities/user_lot_filter.dart';
import 'package:psgy/features/user/domain/entities/surveying_lot_vehicle.dart';
import 'package:psgy/features/user/domain/entities/user_map_filter.dart';
import 'package:psgy/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:psgy/features/user/domain/entities/user_surveying_lots_snapshot.dart';
import 'package:psgy/features/user/presentation/providers/vehicle_filter_providers.dart';

export 'vehicle_filter_providers.dart';

const maxMapMarkers = 50;

void _commitStickyNearbySnapshot(
  Ref ref,
  UserNearbyLotsSnapshot snapshot,
) {
  final sticky = ref.read(_stickyNearbySnapshotProvider);
  if (snapshot.lots.isEmpty &&
      sticky != null &&
      sticky.lots.isNotEmpty &&
      snapshot.mode != UserNearbyLotsQueryMode.cache) {
    return;
  }
  if (snapshot.lots.isNotEmpty || sticky == null) {
    ref.read(_stickyNearbySnapshotProvider.notifier).state = snapshot;
  }
}

void _commitStickySurveyingSnapshot(
  Ref ref,
  UserSurveyingLotsSnapshot snapshot,
) {
  final sticky = ref.read(_stickySurveyingSnapshotProvider);
  if (snapshot.lots.isEmpty) {
    return;
  }
  if (sticky == null || snapshot.lots.isNotEmpty) {
    ref.read(_stickySurveyingSnapshotProvider.notifier).state = snapshot;
  }
}

void _scheduleCommitStickyNearby(
  Ref ref,
  UserNearbyLotsSnapshot snapshot,
) {
  Future.microtask(() => _commitStickyNearbySnapshot(ref, snapshot));
}

void _scheduleCommitStickySurveying(
  Ref ref,
  UserSurveyingLotsSnapshot snapshot,
) {
  Future.microtask(() => _commitStickySurveyingSnapshot(ref, snapshot));
}

final _stickyNearbySnapshotProvider =
    StateProvider<UserNearbyLotsSnapshot?>((ref) => null);

final _stickySurveyingSnapshotProvider =
    StateProvider<UserSurveyingLotsSnapshot?>((ref) => null);
final stickySurveyingProvider = Provider<UserSurveyingLotsSnapshot?>(
  (ref) => ref.watch(_stickySurveyingSnapshotProvider),
);

/// Retains last snapshot emissions so map/sheet never flash empty while streams reload.
final snapshotStickinessProvider = Provider<void>((ref) {
  ref.listen(userNearbyLotsSnapshotProvider, (_, next) {
    next.whenData(
      (snapshot) => _scheduleCommitStickyNearby(ref, snapshot),
    );
  });
  ref.listen(userSurveyingLotsSnapshotProvider, (_, next) {
    next.whenData(
      (snapshot) => _scheduleCommitStickySurveying(ref, snapshot),
    );
  });
});

UserNearbyLotsSnapshot _resolveNearbySnapshot(
  UserNearbyLotsSnapshot? current,
  UserNearbyLotsSnapshot? sticky,
) {
  if (current != null && current.lots.isNotEmpty) return current;
  if (sticky != null && sticky.lots.isNotEmpty) return sticky;
  return current ??
      sticky ??
      const UserNearbyLotsSnapshot(
        lots: [],
        mode: UserNearbyLotsQueryMode.cache,
      );
}

UserSurveyingLotsSnapshot _resolveSurveyingSnapshot(
  UserSurveyingLotsSnapshot? current,
  UserSurveyingLotsSnapshot? sticky,
) {
  if (current != null && current.lots.isNotEmpty) return current;
  if (sticky != null && sticky.lots.isNotEmpty) return sticky;
  return current ??
      sticky ??
      const UserSurveyingLotsSnapshot(
        lots: [],
        mode: UserSurveyingLotsQueryMode.cache,
      );
}

UserNearbyLotsSnapshot _stableNearbySnapshot(Ref ref) {
  ref.watch(snapshotStickinessProvider);
  final async = ref.watch(userNearbyLotsSnapshotProvider);
  final sticky = ref.watch(_stickyNearbySnapshotProvider);
  return _resolveNearbySnapshot(async.valueOrNull, sticky);
}

UserSurveyingLotsSnapshot _stableSurveyingSnapshot(Ref ref) {
  ref.watch(snapshotStickinessProvider);
  final async = ref.watch(userSurveyingLotsSnapshotProvider);
  final sticky = ref.watch(_stickySurveyingSnapshotProvider);
  return _resolveSurveyingSnapshot(async.valueOrNull, sticky);
}

final userMapFilterProvider =
    StateProvider<UserMapFilter>((ref) => UserMapFilter.all);

/// Unified selection key: `active:{id}` or `surveying:{id}`.
final selectedMapLotKeyProvider = StateProvider<String?>((ref) => null);

final selectedLotIdProvider = StateProvider<String?>((ref) {
  final key = ref.watch(selectedMapLotKeyProvider);
  if (key == null || !key.startsWith('active:')) return null;
  return key.substring('active:'.length);
});

final selectedSurveyingLotIdProvider = StateProvider<String?>((ref) {
  final key = ref.watch(selectedMapLotKeyProvider);
  if (key == null || !key.startsWith('surveying:')) return null;
  return key.substring('surveying:'.length);
});

final filteredActiveLotsProvider =
    Provider<AsyncValue<List<ParkingLotEntity>>>((ref) {
  ref.watch(snapshotStickinessProvider);
  final lotsAsync = ref.watch(userNearbyLotsSnapshotProvider);
  final nearbySnapshot = _stableNearbySnapshot(ref);
  final locationAsync = ref.watch(userLocationProvider);
  final filter = ref.watch(userMapFilterProvider);
  final filterParkingLotsUseCase = ref.watch(filterParkingLotsUseCaseProvider);
  final sortParkingLotsUseCase = ref.watch(sortParkingLotsUseCaseProvider);

  if (lotsAsync.hasError && lotsAsync.valueOrNull == null) {
    return AsyncError(lotsAsync.error!, lotsAsync.stackTrace!);
  }
  if (nearbySnapshot.lots.isEmpty && lotsAsync.isLoading) {
    return const AsyncLoading();
  }

  var lots = nearbySnapshot.lots;

  if (filter == UserMapFilter.activeOpen) {
    lots = lots.where((lot) => lot.isOpen).toList(growable: false);
  } else if (filter == UserMapFilter.surveying) {
    lots = const [];
  } else if (filter == UserMapFilter.availableOnly) {
    final vehicleTypesByLotId = <String, List<VehicleTypeEntity>>{};
    for (final lot in lots) {
      vehicleTypesByLotId[lot.id] =
          ref.watch(lotVehicleTypesProvider(lot.id)).valueOrNull ??
              const <VehicleTypeEntity>[];
    }
    lots = filterParkingLotsUseCase(
      lots: lots,
      vehicleTypesByLotId: vehicleTypesByLotId,
      filter: const UserLotFilter(availableOnly: true),
    );
  }

  final vehicleType = ref.watch(vehicleTypeFilterProvider);
  final vehicleTypesByLotId = <String, List<VehicleTypeEntity>>{};
  for (final lot in lots) {
    vehicleTypesByLotId[lot.id] =
        ref.watch(lotVehicleTypesProvider(lot.id)).valueOrNull ??
            const <VehicleTypeEntity>[];
  }
  lots = lots.where((lot) {
    final types = vehicleTypesByLotId[lot.id] ?? const [];
    return activeLotSupportsVehicleFilter(types, vehicleType);
  }).toList(growable: false);

  return AsyncData(
    sortParkingLotsUseCase(
      lots: lots,
      userLocation: locationAsync.valueOrNull,
    ),
  );
});

final filteredSurveyingLotsProvider =
    Provider<AsyncValue<List<SurveyingLotEntity>>>((ref) {
  final logger = ref.read(debugLoggerProvider);
  ref.watch(snapshotStickinessProvider);
  final lotsAsync = ref.watch(userSurveyingLotsSnapshotProvider);
  final stickyStreamAsync = ref.watch(stickyUserSurveyingLotsProvider);
  final surveyingSnapshot = _stableSurveyingSnapshot(ref);
  final locationAsync = ref.watch(userLocationProvider);
  final filter = ref.watch(userMapFilterProvider);

  if (lotsAsync.hasError && lotsAsync.valueOrNull == null) {
    return AsyncError(lotsAsync.error!, lotsAsync.stackTrace!);
  }
  if (surveyingSnapshot.lots.isEmpty && lotsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (filter == UserMapFilter.activeOpen ||
      filter == UserMapFilter.availableOnly) {
    return const AsyncData([]);
  }

  var lots = surveyingSnapshot.lots;
  final vehicleType = ref.watch(vehicleTypeFilterProvider);
  final rawSurveyingCount = lots.length;
  lots = lots
      .where((lot) => SurveyingLotVehicle.supportsFilter(lot, vehicleType))
      .toList(growable: false);

  final stickyLots = stickyStreamAsync.valueOrNull?.lots ?? const [];
  if (lots.isEmpty && stickyLots.isNotEmpty) {
    final stickyFiltered = stickyLots
        .where((lot) => SurveyingLotVehicle.supportsFilter(lot, vehicleType))
        .toList(growable: false);
    if (stickyFiltered.isNotEmpty) {
      lots = stickyFiltered;
    }
  }

  logger.logIfChanged(
    'surveying_provider_status',
    '[Surveying] stickyCache=${surveyingSnapshot.lots.length} | '
        'networkEmpty=${lotsAsync.valueOrNull?.lots.isEmpty ?? false} | '
        'finalDisplay=${lots.length} raw=$rawSurveyingCount mode=${surveyingSnapshot.mode.name}',
    minLevel: DebugLogLevel.normal,
  );

  final userLocation = locationAsync.valueOrNull;
  if (userLocation != null) {
    lots = [...lots]..sort((a, b) {
        final da = GeoDistance.kmBetweenCoordinates(
          userLocation.latitude,
          userLocation.longitude,
          a.lat,
          a.lng,
        );
        final db = GeoDistance.kmBetweenCoordinates(
          userLocation.latitude,
          userLocation.longitude,
          b.lat,
          b.lng,
        );
        return da.compareTo(db);
      });
  }

  return AsyncData(lots);
});

final sheetDisplayItemsProvider = Provider<AsyncValue<List<MapLotItem>>>((ref) {
  final logger = ref.read(debugLoggerProvider);
  final activeAsync = ref.watch(filteredActiveLotsProvider);
  final surveyingAsync = ref.watch(filteredSurveyingLotsProvider);
  final sortCenter = _sheetSortCenter(ref);

  final activeLots = activeAsync.valueOrNull;
  final surveyingLots = surveyingAsync.valueOrNull;
  final hasPartialData = activeLots != null || surveyingLots != null;

  if (!hasPartialData) {
    if (activeAsync.isLoading || surveyingAsync.isLoading) {
      return const AsyncLoading();
    }
    if (activeAsync.hasError) {
      return AsyncError(activeAsync.error!, activeAsync.stackTrace!);
    }
    if (surveyingAsync.hasError) {
      return AsyncError(surveyingAsync.error!, surveyingAsync.stackTrace!);
    }
  }

  if (activeAsync.hasError && activeLots == null && surveyingLots == null) {
    return AsyncError(activeAsync.error!, activeAsync.stackTrace!);
  }
  if (surveyingAsync.hasError && surveyingLots == null && activeLots == null) {
    return AsyncError(surveyingAsync.error!, surveyingAsync.stackTrace!);
  }

  final items = <MapLotItem>[
    ...(activeLots ?? const []).map(MapLotItem.active),
    ...(surveyingLots ?? const []).map(MapLotItem.surveying),
  ];

  _sortMapLotItemsByDistance(items, sortCenter);

  final fromCache =
      ref.watch(userNearbyCacheSnapshotProvider).valueOrNull != null ||
          ref.watch(userSurveyingCacheSnapshotProvider).valueOrNull != null;

  if (fromCache) {
    logger.logIfChanged(
      'sheet_display_total',
      '[Display] total=${items.length} (from cache)',
      minLevel: DebugLogLevel.normal,
    );
  }

  return AsyncData(items);
});

GeoCoordinate? _sheetSortCenter(Ref ref) {
  return ref.watch(userLocationProvider).valueOrNull ??
      ref.watch(mapSearchCenterProvider);
}

void _sortMapLotItemsByDistance(
  List<MapLotItem> items,
  GeoCoordinate? sortCenter,
) {
  if (sortCenter == null) {
    items.sort((a, b) => a.name.compareTo(b.name));
    return;
  }

  items.sort((a, b) {
    final da = GeoDistance.kmBetweenCoordinates(
      sortCenter.latitude,
      sortCenter.longitude,
      a.lat,
      a.lng,
    );
    final db = GeoDistance.kmBetweenCoordinates(
      sortCenter.latitude,
      sortCenter.longitude,
      b.lat,
      b.lng,
    );
    return da.compareTo(db);
  });
}

/// Map markers: merges active + surveying with sticky snapshots (no flash to 0).
final mapDisplayItemsProvider = Provider<List<MapLotItem>>((ref) {
  final logger = ref.read(debugLoggerProvider);
  ref.watch(snapshotStickinessProvider);
  final activeAsync = ref.watch(filteredActiveLotsProvider);
  final surveyingAsync = ref.watch(filteredSurveyingLotsProvider);
  final vehicleType = ref.watch(vehicleTypeFilterProvider);
  final filter = ref.watch(userMapFilterProvider);

  final activeLots = activeAsync.valueOrNull ?? const <ParkingLotEntity>[];
  final surveyingLots =
      surveyingAsync.valueOrNull ?? const <SurveyingLotEntity>[];

  // combineLatest-like merge: one empty/errored stream never clears the other.
  final rawActive = activeLots.length;
  final rawSurveying = surveyingLots.length;

  final items = <MapLotItem>[
    ...activeLots.map(MapLotItem.active),
    ...surveyingLots.map(MapLotItem.surveying),
  ];

  _sortMapLotItemsByDistance(items, _sheetSortCenter(ref));

  final result = items.length <= maxMapMarkers
      ? items
      : items.take(maxMapMarkers).toList(growable: false);

  final activeCount = result.where((item) => item.isActive).length;
  final surveyingCount = result.length - activeCount;
  final nearbySnapshot = _stableNearbySnapshot(ref);
  final surveyingSnapshot = _stableSurveyingSnapshot(ref);
  final isCacheOnly = nearbySnapshot.mode == UserNearbyLotsQueryMode.cache &&
      surveyingSnapshot.mode == UserSurveyingLotsQueryMode.cache;

  logger.logIfChanged(
    'map_merge',
    '[Merge] active=$activeCount + surveyingSticky=$surveyingCount → finalTotal=${result.length}',
    minLevel: DebugLogLevel.normal,
  );
  logger.logIfChanged(
    'map_filter',
    '[Filter] current=$vehicleType mapFilter=$filter',
    minLevel: DebugLogLevel.verbose,
  );
  logger.logIfChanged(
    'map_surveying_display',
    '[Surveying] display=$surveyingCount sticky=${surveyingSnapshot.lots.length} '
        'raw=$rawSurveying mode=${surveyingSnapshot.mode.name}',
    minLevel: DebugLogLevel.normal,
  );
  logger.logIfChanged(
    'map_display',
    '[Display] green=$activeCount yellow=$surveyingCount total=${result.length} '
        'isCacheOnly=$isCacheOnly rawActive=$rawActive rawSurveying=$rawSurveying'
        '${isCacheOnly ? ' (from cache)' : ''}',
    minLevel: DebugLogLevel.normal,
  );

  return result;
});

// Legacy aliases kept for gradual migration in tests/other screens.
final filteredLotsProvider = filteredActiveLotsProvider;

final mapDisplayLotsProvider = Provider<List<ParkingLotEntity>>((ref) {
  return ref
      .watch(mapDisplayItemsProvider)
      .where((item) => item.isActive)
      .map((item) => item.parkingLot!)
      .toList(growable: false);
});

final availableOnlyFilterProvider = StateProvider<bool>((ref) => false);
final openOnlyFilterProvider = StateProvider<bool>((ref) => false);

final userLotFilterProvider = Provider<UserLotFilter>((ref) {
  return UserLotFilter(
    vehicleType: ref.watch(vehicleTypeFilterProvider),
    availableOnly: ref.watch(availableOnlyFilterProvider),
    openOnly: ref.watch(openOnlyFilterProvider),
  );
});

class MapFilterCounts {
  final int all;
  final int activeOpen;
  final int surveying;
  final int availableOnly;
  final int openActiveNearby;
  final int surveyingNearby;

  const MapFilterCounts({
    required this.all,
    required this.activeOpen,
    required this.surveying,
    required this.availableOnly,
    required this.openActiveNearby,
    required this.surveyingNearby,
  });
}

final mapFilterCountsProvider = Provider<MapFilterCounts>((ref) {
  final activeAsync = ref.watch(userNearbyLotsSnapshotProvider);
  final surveyingAsync = ref.watch(userSurveyingLotsSnapshotProvider);
  final filterParkingLotsUseCase = ref.watch(filterParkingLotsUseCaseProvider);

  final activeLots = activeAsync.valueOrNull?.lots ?? const [];
  final surveyingLots = surveyingAsync.valueOrNull?.lots ?? const [];

  final openLots =
      activeLots.where((lot) => lot.isOpen).toList(growable: false);

  final vehicleTypesByLotId = <String, List<VehicleTypeEntity>>{};
  for (final lot in activeLots) {
    vehicleTypesByLotId[lot.id] =
        ref.watch(lotVehicleTypesProvider(lot.id)).valueOrNull ??
            const <VehicleTypeEntity>[];
  }

  final availableLots = filterParkingLotsUseCase(
    lots: activeLots,
    vehicleTypesByLotId: vehicleTypesByLotId,
    filter: const UserLotFilter(availableOnly: true),
  );

  return MapFilterCounts(
    all: activeLots.length + surveyingLots.length,
    activeOpen: openLots.length,
    surveying: surveyingLots.length,
    availableOnly: availableLots.length,
    openActiveNearby: openLots.length,
    surveyingNearby: surveyingLots.length,
  );
});

/// True when area has surveying lots but no open active lots.
final surveyingOnlyAreaProvider = Provider<bool>((ref) {
  final counts = ref.watch(mapFilterCountsProvider);
  return counts.openActiveNearby == 0 && counts.surveyingNearby > 0;
});

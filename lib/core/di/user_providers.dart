import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/contracts/i_qr_token_repository.dart';
import 'package:parking_link/core/debug/debug_logger.dart';
import 'package:parking_link/core/di/debug_providers.dart';
import 'package:parking_link/core/di/firebase_providers.dart';
import 'package:parking_link/core/di/isar_providers.dart';
import 'package:parking_link/core/di/parking_providers.dart';
import 'package:parking_link/core/network/connectivity_service.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/user/data/datasources/my_parking_local_datasource.dart';
import 'package:parking_link/features/user/data/datasources/my_parking_remote_datasource.dart';
import 'package:parking_link/features/user/data/datasources/user_profile_remote_datasource.dart';
import 'package:parking_link/features/user/data/datasources/vehicle_photo_datasource.dart';
import 'package:parking_link/features/user/data/repositories/my_parking_repository_impl.dart';
import 'package:parking_link/features/user/data/repositories/user_profile_repository_impl.dart';
import 'package:parking_link/features/user/data/repositories/user_location_repository_impl.dart';
import 'package:parking_link/features/user/data/repositories/user_repository_impl.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/entities/user_geo_query_config.dart';
import 'package:parking_link/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:parking_link/features/user/domain/entities/user_surveying_lots_snapshot.dart';
import 'package:parking_link/features/user/domain/repositories/i_my_parking_repository.dart';
import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';
import 'package:parking_link/features/user/domain/repositories/user_location_repository.dart';
import 'package:parking_link/features/user/domain/repositories/user_repository.dart';
import 'package:parking_link/features/user/domain/usecases/add_vehicle_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/cancel_checkout_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/cancel_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/create_checkout_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/create_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/clear_parking_record_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/get_current_parking_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/get_user_vehicles_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/watch_checkout_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/watch_qr_token_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/index.dart';
import 'package:parking_link/features/user/domain/usecases/save_self_managed_parking_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/send_otp_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/verify_otp_usecase.dart';
import 'package:parking_link/features/user/domain/usecases/watch_active_session_usecase.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.watch(parkingRepositoryProvider),
    localDataSource: ref.watch(parkingLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    monitoring: ref.watch(monitoringServiceProvider),
    debugLogger: ref.watch(debugLoggerProvider),
  );
});

final userLocationRepositoryProvider = Provider<UserLocationRepository>((ref) {
  return UserLocationRepositoryImpl();
});

final watchNearbyLotsUseCaseProvider = Provider<WatchNearbyLotsUseCase>((ref) {
  return WatchNearbyLotsUseCase(ref.watch(userRepositoryProvider));
});

final watchSurveyingLotsUseCaseProvider =
    Provider<WatchSurveyingLotsUseCase>((ref) {
  return WatchSurveyingLotsUseCase(ref.watch(userRepositoryProvider));
});

final watchUserLotsUseCaseProvider = Provider<WatchUserLotsUseCase>((ref) {
  return WatchUserLotsUseCase(ref.watch(userRepositoryProvider));
});

final watchUserVehicleTypesUseCaseProvider =
    Provider<WatchUserVehicleTypesUseCase>((ref) {
  return WatchUserVehicleTypesUseCase(ref.watch(userRepositoryProvider));
});

final getUserLocationUseCaseProvider = Provider<GetUserLocationUseCase>((ref) {
  return GetUserLocationUseCase(ref.watch(userLocationRepositoryProvider));
});

final filterParkingLotsUseCaseProvider =
    Provider<FilterParkingLotsUseCase>((ref) {
  return FilterParkingLotsUseCase();
});

final sortParkingLotsUseCaseProvider = Provider<SortParkingLotsUseCase>((ref) {
  return SortParkingLotsUseCase();
});

final calculateDistanceKmUseCaseProvider =
    Provider<CalculateDistanceKmUseCase>((ref) {
  return CalculateDistanceKmUseCase();
});

final userLocationProvider = FutureProvider<GeoCoordinate?>((ref) {
  final getUserLocationUseCase = ref.watch(getUserLocationUseCaseProvider);
  return getUserLocationUseCase();
});

/// TP.HCM fallback — used before GPS resolves and for initial cache reads.
const defaultMapCenter = GeoCoordinate(
  latitude: 10.7769,
  longitude: 106.7009,
);

/// Immediate map center (sync triggers, UI). Defaults to TP.HCM.
final mapSearchCenterProvider =
    StateProvider<GeoCoordinate>((ref) => defaultMapCenter);

/// Debounced center for network lot/surveying queries (full map idle debounce).
final mapQueryCenterProvider =
    StateProvider<GeoCoordinate>((ref) => defaultMapCenter);

/// Faster-updating center for Isar cache reads while panning.
final mapCacheCenterProvider =
    StateProvider<GeoCoordinate>((ref) => defaultMapCenter);

final showAllLotsProvider = StateProvider<bool>((ref) => false);

UserNearbyLotsSnapshot _mergeNearbySnapshots(
  AsyncValue<UserNearbyLotsSnapshot> cacheAsync,
  AsyncValue<UserNearbyLotsSnapshot> networkAsync,
) {
  final network = networkAsync.valueOrNull;
  if (network != null && network.lots.isNotEmpty) {
    return network;
  }

  final cache = cacheAsync.valueOrNull;
  if (cache != null) {
    return cache;
  }

  if (cacheAsync.hasError && cacheAsync.valueOrNull == null) {
    throw cacheAsync.error!;
  }
  if (networkAsync.hasError && networkAsync.valueOrNull == null) {
    throw networkAsync.error!;
  }

  return const UserNearbyLotsSnapshot(
    lots: [],
    mode: UserNearbyLotsQueryMode.cache,
  );
}

AsyncValue<UserNearbyLotsSnapshot> _mergedNearbyLotsAsyncValue(
  AsyncValue<UserNearbyLotsSnapshot> cacheAsync,
  AsyncValue<UserNearbyLotsSnapshot> networkAsync,
) {
  try {
    final merged = _mergeNearbySnapshots(cacheAsync, networkAsync);
    final isLoading =
        (cacheAsync.isLoading || networkAsync.isLoading) && merged.lots.isEmpty;
    if (isLoading) {
      return const AsyncLoading();
    }
    return AsyncData(merged);
  } catch (error, stackTrace) {
    return AsyncError(error, stackTrace);
  }
}

final userNearbyCacheSnapshotProvider =
    StreamProvider<UserNearbyLotsSnapshot>((ref) {
  final center = ref.watch(mapCacheCenterProvider);
  final watchNearbyLotsUseCase = ref.watch(watchNearbyLotsUseCaseProvider);
  final logger = ref.read(debugLoggerProvider);
  logger.logThrottled(
    'nearby_cache_watch_center',
    '[Nearby] cache watch center=${center.latitude},${center.longitude}',
    minLevel: DebugLogLevel.verbose,
  );

  return watchNearbyLotsUseCase(
    center: center,
    enableNetwork: false,
  );
});

final userNearbyNetworkSnapshotProvider =
    StreamProvider<UserNearbyLotsSnapshot>((ref) {
  final showAllLots = ref.watch(showAllLotsProvider);
  if (showAllLots) {
    return const Stream.empty();
  }

  final center = ref.watch(mapQueryCenterProvider);
  final watchNearbyLotsUseCase = ref.watch(watchNearbyLotsUseCaseProvider);
  final logger = ref.read(debugLoggerProvider);
  logger.logThrottled(
    'nearby_network_watch_center',
    '[Nearby] network watch center=${center.latitude},${center.longitude}',
    minLevel: DebugLogLevel.verbose,
  );

  return watchNearbyLotsUseCase(
    center: center,
    enableCache: false,
  );
});

final userSurveyingCacheSnapshotProvider =
    StreamProvider<UserSurveyingLotsSnapshot>((ref) {
  final center = ref.watch(mapCacheCenterProvider);
  final watchSurveyingLotsUseCase =
      ref.watch(watchSurveyingLotsUseCaseProvider);
  final logger = ref.read(debugLoggerProvider);
  logger.logThrottled(
    'surveying_cache_watch_center',
    '[Surveying] cache watch center=${center.latitude},${center.longitude}',
    minLevel: DebugLogLevel.verbose,
  );

  return watchSurveyingLotsUseCase(
    center: center,
    enableNetwork: false,
  );
});

final userSurveyingNetworkSnapshotProvider =
    StreamProvider<UserSurveyingLotsSnapshot>((ref) {
  final center = ref.watch(mapQueryCenterProvider);
  final watchSurveyingLotsUseCase =
      ref.watch(watchSurveyingLotsUseCaseProvider);
  final logger = ref.read(debugLoggerProvider);
  logger.logThrottled(
    'surveying_network_watch_center',
    '[Surveying] network watch center=${center.latitude},${center.longitude}',
    minLevel: DebugLogLevel.verbose,
  );

  return watchSurveyingLotsUseCase(
    center: center,
    enableCache: false,
  );
});

/// Global sticky cache for surveying lots across center/provider recreations.
final globalSurveyingStickySnapshotProvider =
    StateProvider<UserSurveyingLotsSnapshot?>((ref) => null);

Future<UserSurveyingLotsSnapshot> _fallbackSurveyingFromIsar(Ref ref) async {
  final logger = ref.read(debugLoggerProvider);
  try {
    final local = ref.read(parkingLocalDataSourceProvider);
    final center = ref.read(mapSearchCenterProvider);
    var lots = await local.getNearbySurveyingLots(
      centerLat: center.latitude,
      centerLng: center.longitude,
      radiusKm: 30,
      maxResults: UserGeoQueryConfig.maxSurveyingLots,
    );
    logger.logThrottled(
      'surveying_cache_current_center',
      '[SurveyingCache] currentCenter30km=${lots.length} '
          'center=${center.latitude},${center.longitude}',
      minLevel: DebugLogLevel.verbose,
    );
    if (lots.isEmpty) {
      lots = await local.getNearbySurveyingLots(
        centerLat: defaultMapCenter.latitude,
        centerLng: defaultMapCenter.longitude,
        radiusKm: 30,
        maxResults: UserGeoQueryConfig.maxSurveyingLots,
      );
      logger.logThrottled(
        'surveying_cache_hcmc_center',
        '[SurveyingCache] hcmcCenter30km=${lots.length}',
        minLevel: DebugLogLevel.verbose,
      );
    }
    if (lots.isEmpty) {
      lots = await local.getAllCachedSurveyingLotsIgnoringTtl(
        maxResults: UserGeoQueryConfig.maxSurveyingLots,
      );
      logger.logThrottled(
        'surveying_cache_global_ignore_ttl',
        '[SurveyingCache] globalCacheIgnoreTtl=${lots.length}',
        minLevel: DebugLogLevel.verbose,
      );
    }
    return UserSurveyingLotsSnapshot(
      lots: lots,
      mode: UserSurveyingLotsQueryMode.cache,
    );
  } catch (_) {
    return const UserSurveyingLotsSnapshot(
      lots: [],
      mode: UserSurveyingLotsQueryMode.cache,
    );
  }
}

/// Strong sticky surveying stream: never drop to 0 while cache has known data.
final stickyUserSurveyingLotsProvider =
    StreamProvider<UserSurveyingLotsSnapshot>((ref) {
  final controller = StreamController<UserSurveyingLotsSnapshot>();
  final logger = ref.read(debugLoggerProvider);
  UserSurveyingLotsSnapshot? lastKnown =
      ref.read(globalSurveyingStickySnapshotProvider);

  Future<void> emitSticky({
    required UserSurveyingLotsSnapshot current,
    required bool fromNetwork,
  }) async {
    if (controller.isClosed) return;

    if (current.lots.isNotEmpty) {
      lastKnown = current;
      ref.read(globalSurveyingStickySnapshotProvider.notifier).state = current;
      controller.add(current);
      if (fromNetwork) {
        logger.logThrottled(
          'surveying_network_status_ok',
          '[Surveying] network status: OK',
          minLevel: DebugLogLevel.verbose,
        );
      }
      logger.logThrottled(
        'surveying_cache_last_known_emit',
        '[SurveyingCache] lastKnown=${lastKnown?.lots.length ?? 0} | '
            'currentEmit=${current.lots.length} | isSticky=true',
        minLevel: DebugLogLevel.verbose,
      );
      return;
    }

    if (lastKnown != null && lastKnown!.lots.isNotEmpty) {
      controller.add(lastKnown!);
      if (fromNetwork) {
        logger.logThrottled(
          'surveying_network_status_empty',
          '[Surveying] network status: EMPTY',
          throttleMs: 1500,
          minLevel: DebugLogLevel.verbose,
        );
      }
      logger.logThrottled(
        'surveying_cache_last_known_keep',
        '[SurveyingCache] lastKnown=${lastKnown!.lots.length} | '
            'currentEmit=0 | isSticky=true',
        throttleMs: 1500,
        minLevel: DebugLogLevel.verbose,
      );
      return;
    }

    final fallback = await _fallbackSurveyingFromIsar(ref);
    if (fallback.lots.isNotEmpty) {
      lastKnown = fallback;
      ref.read(globalSurveyingStickySnapshotProvider.notifier).state = fallback;
      controller.add(fallback);
      logger.logThrottled(
        'surveying_cache_last_known_fallback',
        '[SurveyingCache] lastKnown=${fallback.lots.length} | '
            'currentEmit=${current.lots.length} | isSticky=true',
        minLevel: DebugLogLevel.verbose,
      );
      return;
    }

    if (!fromNetwork) {
      logger.logThrottled(
        'surveying_network_status_empty_cache_only',
        '[Surveying] network status: EMPTY',
        throttleMs: 1500,
        minLevel: DebugLogLevel.verbose,
      );
      logger.logThrottled(
        'surveying_cache_last_known_zero',
        '[SurveyingCache] lastKnown=0 | currentEmit=0 | isSticky=true',
        throttleMs: 1500,
        minLevel: DebugLogLevel.verbose,
      );
      controller.add(current);
    }
  }

  final cacheSub = ref.listen<AsyncValue<UserSurveyingLotsSnapshot>>(
    userSurveyingCacheSnapshotProvider,
    (_, next) {
      next.whenData(
        (snapshot) => unawaited(
          emitSticky(current: snapshot, fromNetwork: false),
        ),
      );
    },
    fireImmediately: true,
  );

  final networkSub = ref.listen<AsyncValue<UserSurveyingLotsSnapshot>>(
    userSurveyingNetworkSnapshotProvider,
    (_, next) {
      next.whenData(
        (snapshot) => unawaited(
          emitSticky(current: snapshot, fromNetwork: true),
        ),
      );
    },
    fireImmediately: true,
  );

  ref.onDispose(() {
    cacheSub.close();
    networkSub.close();
    unawaited(controller.close());
  });

  return controller.stream;
});

/// Merged nearby lots: cache (fast) + network (debounced).
final userNearbyLotsSnapshotProvider =
    Provider<AsyncValue<UserNearbyLotsSnapshot>>((ref) {
  final showAllLots = ref.watch(showAllLotsProvider);
  if (showAllLots) {
    final allAsync = ref.watch(_userAllLotsSnapshotProvider);
    return allAsync;
  }

  final cacheAsync = ref.watch(userNearbyCacheSnapshotProvider);
  final networkAsync = ref.watch(userNearbyNetworkSnapshotProvider);
  return _mergedNearbyLotsAsyncValue(cacheAsync, networkAsync);
});

final _userAllLotsSnapshotProvider =
    StreamProvider<UserNearbyLotsSnapshot>((ref) {
  final watchUserLotsUseCase = ref.watch(watchUserLotsUseCaseProvider);
  return watchUserLotsUseCase();
});

/// Merged surveying lots: cache (fast) + network (debounced).
final userSurveyingLotsSnapshotProvider =
    Provider<AsyncValue<UserSurveyingLotsSnapshot>>((ref) {
  return ref.watch(stickyUserSurveyingLotsProvider);
});

final userLotsQueryModeProvider = Provider<UserNearbyLotsQueryMode?>((ref) {
  return ref.watch(userNearbyLotsSnapshotProvider).valueOrNull?.mode;
});

final lotVehicleTypesProvider =
    StreamProvider.family<List<VehicleTypeEntity>, String>((ref, lotId) {
  final watchUserVehicleTypesUseCase =
      ref.watch(watchUserVehicleTypesUseCaseProvider);
  return watchUserVehicleTypesUseCase(lotId);
});

// ── My Parking ──────────────────────────────────────────

final myParkingLocalDatasourceProvider =
    Provider<IMyParkingLocalDatasource>((ref) {
  final isar = ref.watch(isarProvider);
  return MyParkingLocalDatasourceImpl(isar);
});

final myParkingRemoteDatasourceProvider =
    Provider<IMyParkingRemoteDatasource>((ref) {
  return MyParkingRemoteDatasourceImpl(FirebaseFirestore.instance);
});

final myParkingRepositoryProvider = Provider<IMyParkingRepository>((ref) {
  return MyParkingRepositoryImpl(
    localDatasource: ref.watch(myParkingLocalDatasourceProvider),
    remoteDatasource: ref.watch(myParkingRemoteDatasourceProvider),
  );
});

final saveSelfManagedParkingUseCaseProvider =
    Provider<SaveSelfManagedParkingUseCase>((ref) =>
        SaveSelfManagedParkingUseCase(ref.watch(myParkingRepositoryProvider)));

final getCurrentParkingUseCaseProvider =
    Provider<GetCurrentParkingUseCase>((ref) =>
        GetCurrentParkingUseCase(ref.watch(myParkingRepositoryProvider)));

final clearParkingRecordUseCaseProvider =
    Provider<ClearParkingRecordUseCase>((ref) =>
        ClearParkingRecordUseCase(ref.watch(myParkingRepositoryProvider)));

final watchActiveSessionUseCaseProvider =
    Provider<WatchActiveSessionUseCase>((ref) =>
        WatchActiveSessionUseCase(ref.watch(myParkingRepositoryProvider)));

// ── User Profile (Phone Auth + Vehicles) ─────────────────

final userProfileRemoteDatasourceProvider =
    Provider<IUserProfileRemoteDatasource>((ref) =>
        UserProfileRemoteDatasourceImpl());

final vehiclePhotoDatasourceProvider =
    Provider<IVehiclePhotoDatasource>((ref) => VehiclePhotoDatasourceImpl());

final userProfileRepositoryProvider =
    Provider<IUserProfileRepository>((ref) => UserProfileRepositoryImpl(
          remoteDatasource: ref.watch(userProfileRemoteDatasourceProvider),
          photoDatasource: ref.watch(vehiclePhotoDatasourceProvider),
        ));

final qrTokenRepositoryProvider = Provider<IQrTokenRepository>(
  (ref) => ref.watch(userProfileRepositoryProvider) as IQrTokenRepository,
);

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) =>
    SendOtpUseCase(ref.watch(userProfileRepositoryProvider)));

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) =>
    VerifyOtpUseCase(ref.watch(userProfileRepositoryProvider)));

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) =>
    GetUserProfileUseCase(ref.watch(userProfileRepositoryProvider)));

final addVehicleUseCaseProvider = Provider<AddVehicleUseCase>((ref) =>
    AddVehicleUseCase(ref.watch(userProfileRepositoryProvider)));

final getUserVehiclesUseCaseProvider = Provider<GetUserVehiclesUseCase>((ref) =>
    GetUserVehiclesUseCase(ref.watch(userProfileRepositoryProvider)));

final createQrTokenUseCaseProvider = Provider<CreateQrTokenUseCase>((ref) =>
    CreateQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

final watchQrTokenUseCaseProvider = Provider<WatchQrTokenUseCase>((ref) =>
    WatchQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

final cancelQrTokenUseCaseProvider = Provider<CancelQrTokenUseCase>((ref) =>
    CancelQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

// ── Check-out QR tokens (MOD-12b-4) ──────────────────────

final createCheckoutQrTokenUseCaseProvider =
    Provider<CreateCheckoutQrTokenUseCase>((ref) =>
        CreateCheckoutQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

final watchCheckoutQrTokenUseCaseProvider =
    Provider<WatchCheckoutQrTokenUseCase>((ref) =>
        WatchCheckoutQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

final cancelCheckoutQrTokenUseCaseProvider =
    Provider<CancelCheckoutQrTokenUseCase>((ref) =>
        CancelCheckoutQrTokenUseCase(ref.watch(userProfileRepositoryProvider)));

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/auth_providers.dart';
import 'package:parking_link/core/di/parking_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/parking/domain/entities/history_item_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_slot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:parking_link/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:parking_link/features/staff/domain/entities/staff_today_stats_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';
import 'package:parking_link/core/di/event_providers.dart';
import 'package:parking_link/features/staff/domain/usecases/check_in_out/scan_qr_and_check_out_usecase.dart';
import 'package:parking_link/features/staff/domain/usecases/index.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepositoryImpl(ref.watch(parkingRepositoryProvider));
});

final staffCheckInUseCaseProvider = Provider<StaffCheckInUseCase>((ref) {
  return StaffCheckInUseCase(
    ref.watch(staffRepositoryProvider),
    eventBus: ref.watch(domainEventBusProvider),
  );
});

final scanQrAndCheckInUseCaseProvider = Provider<ScanQrAndCheckInUseCase>((ref) {
  return ScanQrAndCheckInUseCase(
    qrTokenRepo: ref.watch(qrTokenRepositoryProvider),
    staffRepo: ref.watch(staffRepositoryProvider),
  );
});

final staffCheckOutUseCaseProvider = Provider<StaffCheckOutUseCase>((ref) {
  return StaffCheckOutUseCase(ref.watch(staffRepositoryProvider));
});

final scanQrAndCheckOutUseCaseProvider =
    Provider<ScanQrAndCheckOutUseCase>((ref) {
  return ScanQrAndCheckOutUseCase(
    qrTokenRepo: ref.watch(qrTokenRepositoryProvider),
    staffRepo: ref.watch(staffRepositoryProvider),
  );
});

final staffManualAdjustUseCaseProvider = Provider<StaffManualAdjustUseCase>(
  (ref) {
    return StaffManualAdjustUseCase(ref.watch(staffRepositoryProvider));
  },
);

final getStaffHistoryUseCaseProvider = Provider<GetStaffHistoryUseCase>((ref) {
  return GetStaffHistoryUseCase(ref.watch(staffRepositoryProvider));
});

final watchRecentSessionsUseCaseProvider = Provider<WatchRecentSessionsUseCase>(
  (ref) => WatchRecentSessionsUseCase(ref.watch(staffRepositoryProvider)),
);

final watchRecentAdjustmentsUseCaseProvider =
    Provider<WatchRecentAdjustmentsUseCase>(
  (ref) => WatchRecentAdjustmentsUseCase(ref.watch(staffRepositoryProvider)),
);

final getMoreRecentSessionsUseCaseProvider =
    Provider<GetMoreRecentSessionsUseCase>(
  (ref) => GetMoreRecentSessionsUseCase(ref.watch(staffRepositoryProvider)),
);

final getMoreRecentAdjustmentsUseCaseProvider =
    Provider<GetMoreRecentAdjustmentsUseCase>(
  (ref) => GetMoreRecentAdjustmentsUseCase(ref.watch(staffRepositoryProvider)),
);

final watchStaffLotUseCaseProvider = Provider<WatchStaffLotUseCase>((ref) {
  return WatchStaffLotUseCase(ref.watch(staffRepositoryProvider));
});

final watchStaffVehicleTypesUseCaseProvider =
    Provider<WatchStaffVehicleTypesUseCase>((ref) {
  return WatchStaffVehicleTypesUseCase(ref.watch(staffRepositoryProvider));
});

final watchStaffActiveSessionsUseCaseProvider =
    Provider<WatchStaffActiveSessionsUseCase>((ref) {
  return WatchStaffActiveSessionsUseCase(ref.watch(staffRepositoryProvider));
});

final watchTodayStatsUseCaseProvider = Provider<WatchTodayStatsUseCase>((ref) {
  return WatchTodayStatsUseCase(ref.watch(staffRepositoryProvider));
});

final staffProfileProvider = StreamProvider<StaffProfileEntity>((ref) {
  final watchAuthStateUseCase = ref.watch(watchAuthStateUseCaseProvider);
  return watchAuthStateUseCase()
      .where((profile) => profile != null)
      .map((profile) {
    final safeProfile = profile!;
    final normalizedRole = safeProfile.normalizedRole;
    if (normalizedRole != 'staff' && normalizedRole != 'owner') {
      throw Exception('Unauthorized: invalid role for staff app');
    }
    if (safeProfile.role == normalizedRole) {
      return safeProfile;
    }
    return StaffProfileEntity(
      uid: safeProfile.uid,
      name: safeProfile.name,
      email: safeProfile.email,
      role: normalizedRole,
      lotId: safeProfile.lotId,
      isActive: safeProfile.isActive,
      createdAt: safeProfile.createdAt,
      updatedAt: safeProfile.updatedAt,
    );
  });
});

final staffLotProvider =
    StreamProvider.family<ParkingLotEntity, String>((ref, lotId) {
  final watchStaffLotUseCase = ref.watch(watchStaffLotUseCaseProvider);
  return watchStaffLotUseCase(lotId);
});

final staffSlotsProvider =
    StreamProvider.family<List<ParkingSlotEntity>, String>((ref, lotId) {
  final watchSlotsUseCase = ref.watch(watchSlotsUseCaseProvider);
  return watchSlotsUseCase(lotId);
});

final staffVehicleTypesProvider =
    StreamProvider.family<List<VehicleTypeEntity>, String>((ref, lotId) {
  final watchStaffVehicleTypesUseCase =
      ref.watch(watchStaffVehicleTypesUseCaseProvider);
  return watchStaffVehicleTypesUseCase(lotId);
});

final staffVehicleTypeProvider =
    Provider.family<AsyncValue<VehicleTypeEntity>, String>(
        (ref, vehicleTypeId) {
  final profileAsync = ref.watch(staffProfileProvider);
  return profileAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    data: (profile) {
      if (profile.lotId.isEmpty) {
        return AsyncValue.error(
          Exception('Staff lot is not assigned'),
          StackTrace.current,
        );
      }
      final vehicleTypesAsync =
          ref.watch(staffVehicleTypesProvider(profile.lotId));
      return vehicleTypesAsync.whenData(
        (vehicleTypes) => vehicleTypes.firstWhere(
          (vehicleType) => vehicleType.id == vehicleTypeId,
          orElse: () =>
              throw Exception('Vehicle type "$vehicleTypeId" was not found'),
        ),
      );
    },
  );
});

final activeSessionsProvider =
    StreamProvider.family<List<ParkingSessionEntity>, String>(
        (ref, vehicleType) {
  final profileAsync = ref.watch(staffProfileProvider);
  final watchStaffActiveSessionsUseCase =
      ref.watch(watchStaffActiveSessionsUseCaseProvider);

  return profileAsync.when(
    loading: () => const Stream.empty(),
    error: (error, stackTrace) => Stream.error(error, stackTrace),
    data: (profile) {
      if (profile.lotId.isEmpty) {
        return const Stream.empty();
      }
      return watchStaffActiveSessionsUseCase(
        lotId: profile.lotId,
        vehicleType: vehicleType,
      );
    },
  );
});

final historyProvider =
    StreamProvider.family<List<HistoryItemEntity>, String>((ref, lotId) {
  final getStaffHistoryUseCase = ref.watch(getStaffHistoryUseCaseProvider);
  return getStaffHistoryUseCase(lotId);
});

final staffTodayStatsProvider =
    StreamProvider.family<StaffTodayStatsEntity, String>((ref, lotId) {
  final watchTodayStatsUseCase = ref.watch(watchTodayStatsUseCaseProvider);
  return watchTodayStatsUseCase(lotId);
});

final recentSessionsProvider = StreamProvider.family<
    List<ParkingSessionEntity>,
    (
      String lotId,
      int limit,
    )>(
  (ref, params) {
    final watchRecentSessions = ref.watch(watchRecentSessionsUseCaseProvider);
    return watchRecentSessions(
      lotId: params.$1,
      limit: params.$2,
    );
  },
);

final recentAdjustmentsProvider = StreamProvider.family<
    List<ManualAdjustmentEntity>, (String lotId, int limit)>(
  (ref, params) {
    final watchRecentAdjustments =
        ref.watch(watchRecentAdjustmentsUseCaseProvider);
    return watchRecentAdjustments(
      lotId: params.$1,
      limit: params.$2,
    );
  },
);

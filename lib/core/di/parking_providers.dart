import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/event_providers.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/core/di/isar_providers.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/features/parking/data/repositories/parking_repository_impl.dart';
import 'package:psgy/features/parking/domain/repositories/parking_repository.dart';
import 'package:psgy/features/parking/domain/usecases/index.dart';

final parkingRepositoryProvider = Provider<ParkingRepository>((ref) {
  return ParkingRepositoryImpl(
    FirebaseFirestore.instance,
    localDataSource: ref.watch(parkingLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    monitoring: ref.watch(monitoringServiceProvider),
  );
});

final watchAllLotsUseCaseProvider = Provider<WatchAllLotsUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchAllLotsUseCase(repository);
});

final watchVehicleTypesUseCaseProvider =
    Provider<WatchVehicleTypesUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchVehicleTypesUseCase(repository);
});

final watchSlotsUseCaseProvider = Provider<WatchSlotsUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchSlotsUseCase(repository);
});

final checkInUseCaseProvider = Provider<CheckInUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return CheckInUseCase(
    repository,
    eventBus: ref.watch(domainEventBusProvider),
  );
});

final checkOutUseCaseProvider = Provider<CheckOutUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return CheckOutUseCase(repository);
});

final manualAdjustUseCaseProvider = Provider<ManualAdjustUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return ManualAdjustUseCase(repository);
});

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return GetHistoryUseCase(repository);
});

final watchLotUseCaseProvider = Provider<WatchLotUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchLotUseCase(repository);
});

final watchActiveSessionsUseCaseProvider =
    Provider<WatchActiveSessionsUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchActiveSessionsUseCase(repository);
});

final watchParkingSessionUseCaseProvider =
    Provider<WatchParkingSessionUseCase>((ref) {
  final repository = ref.watch(parkingRepositoryProvider);
  return WatchParkingSessionUseCase(repository);
});

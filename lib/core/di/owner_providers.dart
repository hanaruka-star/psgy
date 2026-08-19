import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:parking_link/features/owner/domain/repositories/owner_repository.dart';
import 'package:parking_link/core/di/event_providers.dart';
import 'package:parking_link/features/owner/domain/usecases/index.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  return OwnerRepositoryImpl(FirebaseFirestore.instance);
});

final getLotUseCaseProvider = Provider<GetLotUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return GetLotUseCase(repository);
});

final watchOwnerLotUseCaseProvider = Provider<WatchOwnerLotUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return WatchOwnerLotUseCase(repository);
});

final saveLotEditsUseCaseProvider = Provider<SaveLotEditsUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return SaveLotEditsUseCase(repository);
});

final createLotUseCaseProvider = Provider<CreateLotUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return CreateLotUseCase(repository);
});

final updateLotStatusUseCaseProvider = Provider<UpdateLotStatusUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return UpdateLotStatusUseCase(
    repository,
    eventBus: ref.watch(domainEventBusProvider),
  );
});

final updateVehicleTypeUseCaseProvider =
    Provider<UpdateVehicleTypeUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return UpdateVehicleTypeUseCase(repository);
});

final watchStaffListUseCaseProvider = Provider<WatchStaffListUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return WatchStaffListUseCase(repository);
});

final toggleStaffActiveUseCaseProvider =
    Provider<ToggleStaffActiveUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return ToggleStaffActiveUseCase(repository);
});

final addStaffUseCaseProvider = Provider<AddStaffUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return AddStaffUseCase(repository);
});

final watchOwnerVehicleTypesUseCaseProvider =
    Provider<WatchOwnerVehicleTypesUseCase>((ref) {
  final repository = ref.watch(ownerRepositoryProvider);
  return WatchOwnerVehicleTypesUseCase(repository);
});

final ownerVehicleTypesProvider =
    StreamProvider.family<List<VehicleTypeEntity>, String>((ref, lotId) {
  final watchOwnerVehicleTypesUseCase =
      ref.watch(watchOwnerVehicleTypesUseCaseProvider);
  return watchOwnerVehicleTypesUseCase(lotId);
});

final ownerStaffListProvider =
    StreamProvider.family<List<StaffProfileEntity>, String>((ref, lotId) {
  final watchStaffListUseCase = ref.watch(watchStaffListUseCaseProvider);
  return watchStaffListUseCase(lotId);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/owner_providers.dart';
import 'package:psgy/features/owner/domain/entities/owner_vehicle_type_edit.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';

final ownerLotStreamProvider =
    StreamProvider.family<ParkingLotEntity, String>((ref, lotId) {
  final watchOwnerLotUseCase = ref.watch(watchOwnerLotUseCaseProvider);
  return watchOwnerLotUseCase(lotId);
});

final ownerSaveLotEditsProvider = Provider<
    Future<void> Function({
      required String lotId,
      required String status,
      required List<OwnerVehicleTypeEdit> edits,
      required String changedBy,
    })>((ref) {
  final saveLotEditsUseCase = ref.watch(saveLotEditsUseCaseProvider);
  return ({
    required String lotId,
    required String status,
    required List<OwnerVehicleTypeEdit> edits,
    required String changedBy,
  }) {
    return saveLotEditsUseCase(
      lotId: lotId,
      status: status,
      edits: edits,
      changedBy: changedBy,
    );
  };
});

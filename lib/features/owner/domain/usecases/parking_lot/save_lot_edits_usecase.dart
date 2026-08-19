import 'package:parking_link/features/owner/domain/entities/lot_status.dart';
import 'package:parking_link/features/owner/domain/entities/owner_vehicle_type_edit.dart';
import 'package:parking_link/features/owner/domain/entities/pricing_model.dart';
import 'package:parking_link/features/owner/domain/repositories/owner_repository.dart';

class SaveLotEditsUseCase {
  final OwnerRepository repository;

  SaveLotEditsUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String status,
    required List<OwnerVehicleTypeEdit> edits,
    required String changedBy,
  }) async {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }
    if (!LotStatus.isValid(status)) {
      throw ArgumentError('status must be open or closed');
    }
    if (changedBy.trim().isEmpty) {
      throw ArgumentError('changedBy must not be empty');
    }

    for (final edit in edits) {
      if (edit.vehicleTypeId.trim().isEmpty) {
        throw ArgumentError('vehicleTypeId must not be empty');
      }
      if (edit.totalSlots < 0) {
        throw ArgumentError('totalSlots must be zero or greater');
      }
      if (!PricingModel.isValid(edit.pricingModel)) {
        throw ArgumentError('pricingModel must be per_trip or per_day');
      }
      if (edit.priceAmount < 0) {
        throw ArgumentError('priceAmount must be zero or greater');
      }
    }

    await repository.saveLotEdits(
      lotId: lotId,
      status: status,
      edits: edits,
      changedBy: changedBy,
    );
  }
}

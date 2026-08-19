import 'package:psgy/features/owner/domain/entities/pricing_model.dart';
import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';

class UpdateVehicleTypeUseCase {
  final OwnerRepository repository;

  UpdateVehicleTypeUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String vehicleTypeId,
    required int totalSlots,
    required String pricingModel,
    required int priceAmount,
    required String changedBy,
  }) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }
    if (vehicleTypeId.trim().isEmpty) {
      throw ArgumentError('vehicleTypeId must not be empty');
    }
    if (totalSlots < 0) {
      throw ArgumentError('totalSlots must be zero or greater');
    }
    if (!PricingModel.isValid(pricingModel)) {
      throw ArgumentError('pricingModel must be per_trip or per_day');
    }
    if (priceAmount < 0) {
      throw ArgumentError('priceAmount must be zero or greater');
    }
    if (changedBy.trim().isEmpty) {
      throw ArgumentError('changedBy must not be empty');
    }

    return repository.updateVehicleType(
      lotId: lotId,
      vehicleTypeId: vehicleTypeId,
      totalSlots: totalSlots,
      pricingModel: pricingModel,
      priceAmount: priceAmount,
      changedBy: changedBy,
    );
  }
}

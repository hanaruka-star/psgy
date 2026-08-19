import 'package:psgy/features/owner/domain/entities/create_lot_input.dart';
import 'package:psgy/features/owner/domain/entities/pricing_model.dart';
import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';

class CreateLotUseCase {
  final OwnerRepository repository;

  CreateLotUseCase(this.repository);

  Future<String> call({
    required CreateLotInput input,
    required String ownerUid,
  }) async {
    if (input.name.trim().isEmpty) {
      throw ArgumentError('name must not be empty');
    }
    if (input.address.trim().isEmpty) {
      throw ArgumentError('address must not be empty');
    }
    if (input.lat < -90 || input.lat > 90) {
      throw ArgumentError('lat must be between -90 and 90');
    }
    if (input.lng < -180 || input.lng > 180) {
      throw ArgumentError('lng must be between -180 and 180');
    }
    if (input.vehicleTypes.isEmpty) {
      throw ArgumentError('at least one vehicle type is required');
    }
    if (ownerUid.trim().isEmpty) {
      throw ArgumentError('ownerUid must not be empty');
    }

    for (final vehicleType in input.vehicleTypes) {
      if (vehicleType.type != 'car' && vehicleType.type != 'moto') {
        throw ArgumentError('vehicle type must be car or moto');
      }
      if (vehicleType.totalSlots <= 0) {
        throw ArgumentError('totalSlots must be greater than 0');
      }
      if (vehicleType.priceAmount < 0) {
        throw ArgumentError('priceAmount must be zero or greater');
      }
      if (!PricingModel.isValid(vehicleType.pricingModel)) {
        throw ArgumentError('pricingModel must be per_trip or per_day');
      }
    }

    return repository.createLot(
      input: input,
      ownerUid: ownerUid,
    );
  }
}

import '../../entities/vehicle_type_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchVehicleTypesUseCase {
  final ParkingRepository repository;

  WatchVehicleTypesUseCase(this.repository);

  Stream<List<VehicleTypeEntity>> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.watchVehicleTypes(lotId);
  }
}

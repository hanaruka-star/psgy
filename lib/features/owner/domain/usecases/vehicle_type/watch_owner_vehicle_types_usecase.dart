import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';

class WatchOwnerVehicleTypesUseCase {
  final OwnerRepository repository;

  WatchOwnerVehicleTypesUseCase(this.repository);

  Stream<List<VehicleTypeEntity>> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.watchVehicleTypes(lotId);
  }
}

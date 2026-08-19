import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';

class WatchUserVehicleTypesUseCase {
  final UserRepository repository;

  WatchUserVehicleTypesUseCase(this.repository);

  Stream<List<VehicleTypeEntity>> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.watchVehicleTypes(lotId);
  }
}

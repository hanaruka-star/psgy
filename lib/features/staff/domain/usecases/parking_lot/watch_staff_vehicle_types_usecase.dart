import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class WatchStaffVehicleTypesUseCase {
  final StaffRepository repository;

  WatchStaffVehicleTypesUseCase(this.repository);

  Stream<List<VehicleTypeEntity>> call(String lotId) {
    return repository.watchVehicleTypes(lotId);
  }
}

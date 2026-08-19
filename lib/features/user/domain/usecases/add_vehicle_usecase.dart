import 'package:psgy/features/user/domain/entities/user_vehicle.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class AddVehicleUseCase {
  const AddVehicleUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<void> call(UserVehicle vehicle) => _repo.addVehicle(vehicle);
}

import 'package:parking_link/features/user/domain/entities/user_vehicle.dart';
import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class GetUserVehiclesUseCase {
  const GetUserVehiclesUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<List<UserVehicle>> call(String userId) => _repo.getVehicles(userId);
}

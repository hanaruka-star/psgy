import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<UserProfile?> call(String userId) => _repo.getProfile(userId);
}

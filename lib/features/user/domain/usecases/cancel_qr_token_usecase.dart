import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class CancelQrTokenUseCase {
  const CancelQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<void> call(String tokenId) => _repo.cancelQrToken(tokenId);
}

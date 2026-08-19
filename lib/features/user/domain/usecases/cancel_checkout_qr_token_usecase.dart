import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class CancelCheckoutQrTokenUseCase {
  const CancelCheckoutQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<void> call(String tokenId) {
    return _repo.cancelCheckoutQrToken(tokenId);
  }
}

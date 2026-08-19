import 'package:parking_link/features/user/domain/entities/checkout_qr_token.dart';
import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class WatchCheckoutQrTokenUseCase {
  const WatchCheckoutQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Stream<CheckoutQrToken?> call(String tokenId) {
    return _repo.watchCheckoutQrToken(tokenId);
  }
}

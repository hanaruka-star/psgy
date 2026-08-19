import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class CreateCheckoutQrTokenUseCase {
  const CreateCheckoutQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<CheckoutQrToken> call({
    required String sessionId,
    required String userId,
    required int estimatedFee,
  }) {
    return _repo.createCheckoutQrToken(
      sessionId: sessionId,
      userId: userId,
      estimatedFee: estimatedFee,
    );
  }
}

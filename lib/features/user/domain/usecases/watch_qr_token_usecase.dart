import 'package:parking_link/features/user/domain/entities/qr_token.dart';
import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class WatchQrTokenUseCase {
  const WatchQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Stream<QrToken?> call(String tokenId) => _repo.watchQrToken(tokenId);
}

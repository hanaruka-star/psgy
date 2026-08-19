import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<String> call(String smsCode) => _repo.verifyOtp(smsCode);
}

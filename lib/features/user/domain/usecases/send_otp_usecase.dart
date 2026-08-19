import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<void> call(String phoneNumber) => _repo.sendOtp(phoneNumber);
}

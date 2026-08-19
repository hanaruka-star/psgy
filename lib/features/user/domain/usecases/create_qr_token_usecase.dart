import 'package:parking_link/features/user/domain/entities/qr_token.dart';
import 'package:parking_link/features/user/domain/entities/user_vehicle.dart';
import 'package:parking_link/features/user/domain/repositories/i_user_profile_repository.dart';

class CreateQrTokenUseCase {
  const CreateQrTokenUseCase(this._repo);

  final IUserProfileRepository _repo;

  Future<QrToken> call({
    required String userId,
    required UserVehicle vehicle,
    required String maskedPhone,
  }) =>
      _repo.createQrToken(
        userId: userId,
        vehicle: vehicle,
        maskedPhone: maskedPhone,
      );
}

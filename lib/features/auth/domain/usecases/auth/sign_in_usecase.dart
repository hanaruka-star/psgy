import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<StaffProfileEntity> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}

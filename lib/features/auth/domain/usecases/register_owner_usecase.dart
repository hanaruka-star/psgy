import 'package:parking_link/features/auth/domain/repositories/auth_repository.dart';

/// Registers a new owner account (Firebase Auth + staff_profiles).
class RegisterOwnerUseCase {
  final AuthRepository _repository;

  RegisterOwnerUseCase(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.registerOwner(
      name: name,
      email: email,
      password: password,
    );
  }
}

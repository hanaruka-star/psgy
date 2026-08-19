import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';

class AddStaffUseCase {
  final OwnerRepository repository;

  AddStaffUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim();

    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('name must not be empty');
    }
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw ArgumentError('email must be valid');
    }
    if (password.length < 6) {
      throw ArgumentError('password must be at least 6 characters');
    }

    return repository.addStaff(
      lotId: lotId.trim(),
      name: normalizedName,
      email: normalizedEmail,
      password: password,
    );
  }
}

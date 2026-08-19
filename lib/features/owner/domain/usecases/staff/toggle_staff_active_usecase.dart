import 'package:parking_link/features/owner/domain/repositories/owner_repository.dart';

class ToggleStaffActiveUseCase {
  final OwnerRepository repository;

  ToggleStaffActiveUseCase(this.repository);

  Future<void> call({
    required String uid,
    required bool isActive,
  }) {
    if (uid.trim().isEmpty) {
      throw ArgumentError('uid must not be empty');
    }

    return repository.toggleStaffActive(
      uid: uid,
      isActive: isActive,
    );
  }
}

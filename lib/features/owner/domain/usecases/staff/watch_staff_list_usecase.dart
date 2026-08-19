import 'package:psgy/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';

class WatchStaffListUseCase {
  final OwnerRepository repository;

  WatchStaffListUseCase(this.repository);

  Stream<List<StaffProfileEntity>> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.watchStaffList(lotId);
  }
}

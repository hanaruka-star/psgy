import 'package:psgy/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<StaffProfileEntity?> call() {
    return _repository.watchAuthState();
  }
}

import 'package:psgy/features/auth/domain/entities/auth_user.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<AuthUser?> call() {
    return _repository.watchAuthState();
  }
}

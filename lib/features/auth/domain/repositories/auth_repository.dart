import 'package:psgy/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Stream<AuthUser?> watchAuthState();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/error_mapper.dart';
import 'package:psgy/features/auth/domain/entities/auth_user.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const bool _forceLogoutOnStartup =
      bool.fromEnvironment('FORCE_LOGOUT');

  final FirebaseAuth _firebaseAuth;
  bool _didRunStartupLogout = false;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
            'Authentication succeeded but user is missing.');
      }
      return AuthUser(uid: user.uid, email: user.email);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<AuthUser?> watchAuthState() {
    return _watchAuthStateStream();
  }

  Stream<AuthUser?> _watchAuthStateStream() async* {
    try {
      if (!_didRunStartupLogout && _shouldForceLogoutForDevelopment) {
        _didRunStartupLogout = true;
        await _firebaseAuth.signOut();
      }

      yield* _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return AuthUser(uid: user.uid, email: user.email);
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  bool get _shouldForceLogoutForDevelopment =>
      _forceLogoutOnStartup && !kReleaseMode;
}

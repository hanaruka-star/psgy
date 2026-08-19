import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/error_mapper.dart';
import 'package:psgy/features/auth/data/models/staff_profile_model.dart';
import 'package:psgy/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const bool _forceLogoutOnStartup =
      bool.fromEnvironment('FORCE_LOGOUT');

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  bool _didRunStartupLogout = false;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<StaffProfileEntity> signIn({
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

      final profile = await getProfile(user.uid);
      if (!profile.isActive) {
        await _firebaseAuth.signOut();
        throw const AuthException(
          'This account is inactive. Please contact an owner.',
        );
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> registerOwner({
    required String name,
    required String email,
    required String password,
  }) async {
    User? createdUser;
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      createdUser = credential.user;
      if (createdUser == null) {
        throw const AuthException(
          'Registration succeeded but user is missing.',
        );
      }

      try {
        await _firestore.collection('staff_profiles').doc(createdUser.uid).set({
          'uid': createdUser.uid,
          'name': name.trim(),
          'email': email.trim(),
          'role': 'owner',
          'lotId': null,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        try {
          await createdUser.delete();
        } catch (deleteError) {
          debugPrint(
            'Failed to delete orphan auth user after profile create error: '
            '$deleteError',
          );
        }
        throw mapFirebaseException(e);
      }
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
  Stream<StaffProfileEntity?> watchAuthState() {
    return _watchAuthStateStream();
  }

  Stream<StaffProfileEntity?> _watchAuthStateStream() async* {
    try {
      if (!_didRunStartupLogout && _shouldForceLogoutForDevelopment) {
        _didRunStartupLogout = true;
        await _firebaseAuth.signOut();
      }

      yield* _firebaseAuth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;

        try {
          final profile = await getProfile(user.uid);
          if (!profile.isActive) {
            await _firebaseAuth.signOut();
            return null;
          }
          return profile;
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  bool get _shouldForceLogoutForDevelopment =>
      _forceLogoutOnStartup && !kReleaseMode;

  @override
  Future<StaffProfileEntity> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('staff_profiles').doc(uid).get();
      if (!doc.exists) {
        throw AuthException('Staff profile not found for uid "$uid".');
      }

      return StaffProfileModel.fromFirestore(doc).toEntity();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }
}

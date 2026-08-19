import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';

abstract class AuthRepository {
  Future<StaffProfileEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> registerOwner({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Stream<StaffProfileEntity?> watchAuthState();

  Future<StaffProfileEntity> getProfile(String uid);
}

import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';

abstract class IUserProfileRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String smsCode);

  Future<bool> isProfileExists(String userId);
  Future<void> createProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String userId);

  Future<void> addVehicle(UserVehicle vehicle);
  Future<List<UserVehicle>> getVehicles(String userId);
  Future<void> updateVehicle(UserVehicle vehicle);

  Future<String> uploadVehiclePhoto({
    required String userId,
    required String localPath,
  });
}

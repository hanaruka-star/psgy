import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';

class UserProfileState {
  const UserProfileState({
    this.profile,
    this.vehicles = const [],
    this.isLoading = false,
    this.error,
    this.verificationId,
    this.otpSent = false,
  });

  final UserProfile? profile;
  final List<UserVehicle> vehicles;
  final bool isLoading;
  final String? error;
  final String? verificationId;
  final bool otpSent;

  bool get isAuthenticated => profile != null;

  UserProfileState copyWith({
    UserProfile? profile,
    List<UserVehicle>? vehicles,
    bool? isLoading,
    String? error,
    String? verificationId,
    bool? otpSent,
    bool clearError = false,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      vehicles: vehicles ?? this.vehicles,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
      otpSent: otpSent ?? this.otpSent,
    );
  }
}

class UserProfileNotifier extends AsyncNotifier<UserProfileState> {
  @override
  Future<UserProfileState> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const UserProfileState();

    final profile =
        await ref.read(getUserProfileUseCaseProvider).call(user.uid);
    if (profile == null) return const UserProfileState();

    final vehicles =
        await ref.read(getUserVehiclesUseCaseProvider).call(user.uid);

    return UserProfileState(profile: profile, vehicles: vehicles);
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = AsyncData(state.value!.copyWith(
      isLoading: true,
      clearError: true,
    ));
    try {
      await ref.read(sendOtpUseCaseProvider).call(phoneNumber);
      state = AsyncData(state.value!.copyWith(
        isLoading: false,
        otpSent: true,
      ));
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<bool> verifyOtp(String code) async {
    state = AsyncData(state.value!.copyWith(
      isLoading: true,
      clearError: true,
    ));
    try {
      final userId = await ref.read(verifyOtpUseCaseProvider).call(code);
      final existing =
          await ref.read(getUserProfileUseCaseProvider).call(userId);
      if (existing == null) {
        final phone = FirebaseAuth.instance.currentUser?.phoneNumber;
        if (phone != null) {
          await ref.read(userProfileRepositoryProvider).createProfile(
                UserProfile(
                  userId: userId,
                  phoneNumber: phone,
                  createdAt: DateTime.now(),
                ),
              );
        }
      }
      ref.invalidateSelf();
      return true;
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  Future<void> addVehicle({
    required String plate,
    required String localPhotoPath,
    required bool isPersonal,
  }) async {
    state = AsyncData(state.value!.copyWith(
      isLoading: true,
      clearError: true,
    ));
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final isFirst = state.value!.vehicles.isEmpty;
      final now = DateTime.now();
      await ref.read(addVehicleUseCaseProvider).call(
            UserVehicle(
              vehicleId: '',
              userId: userId,
              plate: plate,
              plateNormalized: '',
              photoUrl: localPhotoPath,
              isPersonal: isPersonal,
              isDefault: isFirst,
              createdAt: now,
              updatedAt: now,
            ),
          );
      state = AsyncData(state.value!.copyWith(isLoading: false));
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileState>(
  UserProfileNotifier.new,
);

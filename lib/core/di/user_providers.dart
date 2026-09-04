import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/features/user/data/datasources/user_profile_remote_datasource.dart';
import 'package:psgy/features/user/data/datasources/vehicle_photo_datasource.dart';
import 'package:psgy/features/user/data/repositories/user_location_repository_impl.dart';
import 'package:psgy/features/user/data/repositories/user_profile_repository_impl.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';
import 'package:psgy/features/user/domain/repositories/user_location_repository.dart';
import 'package:psgy/features/user/domain/usecases/add_vehicle_usecase.dart';
import 'package:psgy/features/user/domain/usecases/get_user_location_usecase.dart';
import 'package:psgy/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:psgy/features/user/domain/usecases/get_user_vehicles_usecase.dart';
import 'package:psgy/features/user/domain/usecases/send_otp_usecase.dart';
import 'package:psgy/features/user/domain/usecases/verify_otp_usecase.dart';

final userLocationRepositoryProvider = Provider<UserLocationRepository>((ref) {
  return UserLocationRepositoryImpl();
});

final getUserLocationUseCaseProvider = Provider<GetUserLocationUseCase>((ref) {
  return GetUserLocationUseCase(ref.watch(userLocationRepositoryProvider));
});

final userLocationProvider = FutureProvider<GeoCoordinate?>((ref) {
  final getUserLocationUseCase = ref.watch(getUserLocationUseCaseProvider);
  return getUserLocationUseCase();
});

/// TP.HCM fallback — used before GPS resolves.
const defaultMapCenter = GeoCoordinate(
  latitude: 10.7769,
  longitude: 106.7009,
);

final mapSearchCenterProvider =
    StateProvider<GeoCoordinate>((ref) => defaultMapCenter);

// ── User Profile (Phone Auth) ────────────────────────────

final userProfileRemoteDatasourceProvider =
    Provider<IUserProfileRemoteDatasource>(
        (ref) => UserProfileRemoteDatasourceImpl());

final vehiclePhotoDatasourceProvider =
    Provider<IVehiclePhotoDatasource>((ref) => VehiclePhotoDatasourceImpl());

final userProfileRepositoryProvider =
    Provider<IUserProfileRepository>((ref) => UserProfileRepositoryImpl(
          remoteDatasource: ref.watch(userProfileRemoteDatasourceProvider),
          photoDatasource: ref.watch(vehiclePhotoDatasourceProvider),
        ));

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>(
    (ref) => SendOtpUseCase(ref.watch(userProfileRepositoryProvider)));

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>(
    (ref) => VerifyOtpUseCase(ref.watch(userProfileRepositoryProvider)));

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>(
    (ref) => GetUserProfileUseCase(ref.watch(userProfileRepositoryProvider)));

final addVehicleUseCaseProvider = Provider<AddVehicleUseCase>(
    (ref) => AddVehicleUseCase(ref.watch(userProfileRepositoryProvider)));

final getUserVehiclesUseCaseProvider = Provider<GetUserVehiclesUseCase>(
    (ref) => GetUserVehiclesUseCase(ref.watch(userProfileRepositoryProvider)));

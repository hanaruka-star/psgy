// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/app_mode.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/core/di/fcm_providers.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/core/di/watchlist_providers.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/services/monitoring_service.dart';
import 'package:psgy/core/theme/app_theme.dart';
import 'package:psgy/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';
import 'package:psgy/core/di/auth_providers.dart';
import 'package:psgy/features/auth/presentation/screens/login_screen.dart';
import 'package:psgy/features/common/presentation/screens/app_root_screen.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:psgy/features/user/domain/entities/user_surveying_lots_snapshot.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:psgy/core/services/fcm_notification_service.dart';
import 'package:psgy/features/user/data/services/watchlist_local_notification_service.dart';
import 'package:psgy/features/user/presentation/screens/user_map_screen.dart';

void main() {
  setUpAll(() {
    GoogleMapsFlutterPlatform.instance = _FakeGoogleMapsFlutterPlatform();
  });

  testWidgets('user flavor renders UserMapScreen', (tester) async {
    AppConfig.initialize();
    FlavorConfig.initialize(AppFlavor.user);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monitoringServiceProvider.overrideWithValue(NoOpMonitoringService()),
          userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
          appModeProvider.overrideWith((ref) => AppModeController()),
          userNearbyLotsSnapshotProvider.overrideWith(
            (ref) => const AsyncData(
              UserNearbyLotsSnapshot(
                lots: [],
                mode: UserNearbyLotsQueryMode.fallbackAll,
              ),
            ),
          ),
          userSurveyingLotsSnapshotProvider.overrideWith(
            (ref) => const AsyncData(
              UserSurveyingLotsSnapshot(
                lots: [],
                mode: UserSurveyingLotsQueryMode.clientSide,
              ),
            ),
          ),
          watchedLotIdsProvider.overrideWith((ref) => Stream.value({})),
          watchlistBadgeCountProvider.overrideWith((ref) => Stream.value(0)),
          userWatchlistProvider.overrideWith((ref) => Stream.value([])),
          fcmNotificationServiceProvider
              .overrideWithValue(_FakeFcmNotificationService()),
          watchlistLocalNotificationServiceProvider.overrideWithValue(
            WatchlistLocalNotificationService(),
          ),
          watchlistEventHandlersRegisteredProvider.overrideWith((ref) {}),
          userLocationProvider.overrideWith((ref) async => null),
          connectivityStatusProvider.overrideWith((ref) => Stream.value(true)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ModeSwitcherScreen(),
        ),
      ),
    );

    expect(find.byType(UserMapScreen), findsOneWidget);
    expect(find.text('Chuyen sang Staff'), findsOneWidget);
  });

  testWidgets('staff flavor renders LoginScreen', (tester) async {
    AppConfig.initialize();
    FlavorConfig.initialize(AppFlavor.staff);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monitoringServiceProvider.overrideWithValue(NoOpMonitoringService()),
          appModeProvider.overrideWith((ref) {
            final controller = AppModeController()..switchToStaff();
            return controller;
          }),
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ModeSwitcherScreen(),
        ),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Staff Login'), findsOneWidget);
  });
}

class _FakeUserRepository implements UserRepository {
  @override
  Stream<List<ParkingLotEntity>> watchAllLots() {
    return Stream.value(const []);
  }

  @override
  Stream<UserNearbyLotsSnapshot> watchNearbyLots({
    required GeoCoordinate center,
    double radiusKm = 15,
    int maxResults = 100,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    return Stream.value(
      const UserNearbyLotsSnapshot(
        lots: [],
        mode: UserNearbyLotsQueryMode.fallbackAll,
      ),
    );
  }

  @override
  Future<UserNearbyLotsSnapshot> syncNearbyLots({
    required GeoCoordinate center,
    double radiusKm = 15,
    int maxResults = 100,
  }) async {
    return const UserNearbyLotsSnapshot(
      lots: [],
      mode: UserNearbyLotsQueryMode.fallbackAll,
    );
  }

  @override
  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId) {
    return Stream.value(const []);
  }

  @override
  Stream<UserSurveyingLotsSnapshot> watchSurveyingLots({
    required GeoCoordinate center,
    double radiusKm = 15,
    int maxResults = 80,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    return Stream.value(
      const UserSurveyingLotsSnapshot(
        lots: [],
        mode: UserSurveyingLotsQueryMode.clientSide,
      ),
    );
  }

  @override
  Future<UserSurveyingLotsSnapshot> syncSurveyingLots({
    required GeoCoordinate center,
    double radiusKm = 15,
    int maxResults = 80,
  }) async {
    return const UserSurveyingLotsSnapshot(
      lots: [],
      mode: UserSurveyingLotsQueryMode.clientSide,
    );
  }
}

class _FakeFcmNotificationService extends FcmNotificationService {
  _FakeFcmNotificationService()
      : super(messagingFactory: () => throw StateError('FCM unavailable in tests'));

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> configureWatchlistHandlers({
    required void Function(RemoteMessage message) onForegroundMessage,
    required WatchlistNotificationTapHandler onNotificationOpened,
  }) async {}

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}

class _FakeGoogleMapsFlutterPlatform extends GoogleMapsFlutterPlatform {
  @override
  Widget buildViewWithConfiguration(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required MapWidgetConfiguration widgetConfiguration,
    MapConfiguration mapConfiguration = const MapConfiguration(),
    MapObjects mapObjects = const MapObjects(),
  }) {
    return const SizedBox(key: ValueKey('fake-google-map'));
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<StaffProfileEntity> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError('signIn is not used in this smoke test.');
  }

  @override
  Future<void> registerOwner({
    required String name,
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Stream<StaffProfileEntity?> watchAuthState() {
    return Stream.value(null);
  }

  @override
  Future<StaffProfileEntity> getProfile(String uid) {
    throw UnimplementedError('getProfile is not used in this smoke test.');
  }
}

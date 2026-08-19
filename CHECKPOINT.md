# Checkpoint

## Hoan thanh den hien tai

- Da cap nhat `pubspec.yaml` voi SDK/Flutter constraints va dependencies moi.
- Da tao enum `VehicleType` tai `lib/core/domain/entities/vehicle_type.dart`.
- Da tao entity `ParkingLot` tai `lib/core/domain/entities/parking_lot.dart`.
- Da tao entity `ParkingSession` tai `lib/core/domain/entities/parking_session.dart`.
- Da tao repository interface `IParkingRepository` tai `lib/core/domain/repositories/i_parking_repository.dart`.
- Da tao use case `GetNearbyLotsUseCase` tai `lib/core/domain/usecases/get_nearby_lots_usecase.dart`.
- Da tao use case `GetLiveLotStreamUseCase` tai `lib/core/domain/usecases/get_live_lot_stream_usecase.dart`.
- Da tao cau hinh flavor tai `lib/config/flavor.dart`.
- Da cap nhat `lib/main.dart` de chay theo `--dart-define=FLAVOR` (user/staff).
- Da cap nhat Android flavor trong `android/app/build.gradle.kts` (`user`, `staff`).
- Da cap nhat iOS `ios/Runner/Info.plist` voi `CFBundleName = $(APP_NAME)` va key `APP_NAME`.
- Da cau hinh iOS schemes `User` va `Staff` trong `ios/Runner.xcodeproj/project.pbxproj` va `ios/Runner.xcodeproj/xcshareddata/xcschemes/`.
- Da cap nhat `ios/Podfile` (platform iOS 13, `use_modular_headers!`, fix `SWIFT_VERSION`, fix deployment target).
- Da tam comment `mobile_scanner` trong `pubspec.yaml` de fix `pod install`.
- Da tao `lib/features/user/presentation/screens/user_map_screen.dart`.
- Da tao `lib/features/staff/presentation/screens/staff_dashboard.dart`.
- Da tao `lib/app_mode.dart` de switch mode User/Staff.
- Da thay `lib/main.dart` sang `ModeSwitcherScreen` de chuyen doi User/Staff runtime.

## Ghi chu

- Day la moc checkpoint de tiep tuc cac buoc data layer, implementation repository va UI flow.
- Da hoan thanh muc: Tao 2 UseCase quan trong nhat (Zone 2 - Business Rules).
- Da hoan thanh muc: Flavor Configuration + main.dart (Muc tieu: 2 app trong 1 project, de chuyen tren Simulator va build ra 2 app rieng biet).
- Da bo sung mode switch runtime bang `AppModeController` de test nhanh 2 vai tro trong 1 app.
- Buoc ke tiep: Ket noi Firebase theo flavor, sau do hoan tat data layer + repository implementation.

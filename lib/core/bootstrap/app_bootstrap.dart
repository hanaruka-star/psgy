import 'package:isar/isar.dart';
import 'package:parking_link/core/config/app_config.dart';
import 'package:parking_link/core/config/supported_platforms.dart';
import 'package:parking_link/core/config/firebase_config.dart';
import 'package:parking_link/core/config/flavor.dart';
import 'package:parking_link/core/di/firebase_providers.dart';
import 'package:parking_link/core/di/isar_providers.dart';
import 'package:parking_link/core/error/app_error_handler.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';
import 'package:parking_link/core/error/global_error_handler.dart';
import 'package:parking_link/core/services/monitoring_service.dart';

enum AppBootstrapStatus { success, failure }

class AppBootstrapResult {
  final AppBootstrapStatus status;
  final Isar? isar;
  final MonitoringService? monitoringService;
  final AppException? error;

  const AppBootstrapResult._({
    required this.status,
    this.isar,
    this.monitoringService,
    this.error,
  });

  factory AppBootstrapResult.success({
    required Isar isar,
    required MonitoringService monitoringService,
  }) {
    return AppBootstrapResult._(
      status: AppBootstrapStatus.success,
      isar: isar,
      monitoringService: monitoringService,
    );
  }

  factory AppBootstrapResult.failure(AppException error) {
    return AppBootstrapResult._(
      status: AppBootstrapStatus.failure,
      error: error,
    );
  }
}

class AppBootstrap {
  static Future<AppBootstrapResult> initialize() async {
    try {
      SupportedPlatforms.ensureMobile();
      AppConfig.initialize();

      const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'user');
      const appFlavor =
          flavorString == 'staff' ? AppFlavor.staff : AppFlavor.user;
      FlavorConfig.initialize(appFlavor);

      installGlobalErrorHandlers();

      await FirebaseConfig.initialize();
      final monitoringService = await initializeMonitoringService();
      appErrorHandler.attachMonitoring(monitoringService);
      final isar = await openParkingIsar();

      return AppBootstrapResult.success(
        isar: isar,
        monitoringService: monitoringService,
      );
    } catch (error, stack) {
      return AppBootstrapResult.failure(mapFirebaseException(error, stack));
    }
  }
}

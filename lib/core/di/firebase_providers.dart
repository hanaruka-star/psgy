import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/error/exception_reporter.dart';
import 'package:psgy/core/services/monitoring_service.dart';

final monitoringServiceProvider = Provider<MonitoringService>((ref) {
  throw StateError(
    'MonitoringService must be initialized in main() before runApp().',
  );
});

Future<MonitoringService> initializeMonitoringService() async {
  final service = FirebaseMonitoringService();
  await service.initialize();
  installExceptionReporter(service);
  return service;
}

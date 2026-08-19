import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/services/monitoring_service.dart';

MonitoringService? _monitoringService;

void installExceptionReporter(MonitoringService service) {
  _monitoringService = service;
}

void reportAppException(AppException exception, [StackTrace? stackTrace]) {
  _monitoringService?.recordAppException(exception, stackTrace);
}

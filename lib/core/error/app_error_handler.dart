import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_link/core/error/app_error_ui.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';
import 'package:parking_link/core/error/exception_reporter.dart';
import 'package:parking_link/core/error/retry_policy.dart';
import 'package:parking_link/core/services/monitoring_service.dart';
import 'package:parking_link/shared/widgets/app_error_view.dart';

/// Central error handling: monitoring, user messaging, retry orchestration.
class AppErrorHandler {
  AppErrorHandler({MonitoringService? monitoring})
      : _monitoring = monitoring;

  MonitoringService? _monitoring;

  void attachMonitoring(MonitoringService monitoring) {
    _monitoring = monitoring;
  }

  AppException resolve(Object error, [StackTrace? stackTrace]) {
    return error is AppException
        ? error
        : mapFirebaseException(error, stackTrace);
  }

  void report(Object error, StackTrace? stackTrace, {String? context}) {
    final exception = resolve(error, stackTrace);
    reportAppException(exception, stackTrace);
    _monitoring?.logBreadcrumb(
      'app_error',
      params: {
        'category': AppErrorUi.from(exception).category.name,
        if (exception.code != null) 'code': exception.code!,
        if (context != null) 'context': context,
      },
    );
  }

  void hapticError() {
    HapticFeedback.heavyImpact();
  }

  void showSnackBar(
    BuildContext context,
    Object error, {
    String? contextLabel,
    VoidCallback? onRetry,
    bool keepExistingData = false,
  }) {
    report(error, StackTrace.current, context: contextLabel);
    hapticError();

    final presentation = AppErrorUi.from(error);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(presentation.message),
        action: onRetry == null
            ? null
            : SnackBarAction(
                label: presentation.primaryActionLabel,
                onPressed: onRetry,
              ),
        duration: Duration(seconds: keepExistingData ? 3 : 4),
      ),
    );
  }

  Future<void> showRecoverySheet(
    BuildContext context,
    AppErrorPresentation presentation, {
    required VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    VoidCallback? onSupport,
  }) {
    hapticError();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: AppErrorView(
            presentation: presentation,
            compact: false,
            onPrimaryAction: onPrimary == null
                ? null
                : () {
                    Navigator.of(context).pop();
                    onPrimary();
                  },
            onSecondaryAction: onSecondary == null
                ? null
                : () {
                    Navigator.of(context).pop();
                    onSecondary();
                  },
            onSupportAction: onSupport == null
                ? null
                : () {
                    Navigator.of(context).pop();
                    onSupport();
                  },
          ),
        );
      },
    );
  }

  Future<T> runWithRetry<T>({
    required Future<T> Function() action,
    RetryPolicy policy = const RetryPolicy(),
    void Function(int attempt, Duration nextDelay)? onRetryProgress,
    String? contextLabel,
  }) {
    return policy.run(
      action: action,
      onRetry: (attempt, delay) {
        _monitoring?.logBreadcrumb(
          'retry_scheduled',
          params: {
            'attempt': attempt,
            'delay_ms': delay.inMilliseconds,
            if (contextLabel != null) 'context': contextLabel,
          },
        );
        onRetryProgress?.call(attempt, delay);
      },
    );
  }
}

/// Global singleton used after bootstrap attaches monitoring.
final appErrorHandler = AppErrorHandler();

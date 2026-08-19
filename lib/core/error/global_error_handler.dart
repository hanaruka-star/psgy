import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:psgy/core/error/app_error_handler.dart';
import 'package:psgy/core/error/app_error_ui.dart';
import 'package:psgy/shared/widgets/app_error_view.dart';

typedef GlobalErrorHandler = void Function(Object error, StackTrace stackTrace);

/// Installs global Flutter + async error hooks and user-facing error widget.
void installGlobalErrorHandlers({
  GlobalErrorHandler? onError,
}) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    appErrorHandler.report(
      details.exception,
      details.stack,
      context: 'FlutterError',
    );
    onError?.call(details.exception, details.stack ?? StackTrace.current);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    appErrorHandler.report(error, stack, context: 'PlatformDispatcher');
    onError?.call(error, stack);
    return true;
  };

  ErrorWidget.builder = (details) {
    final presentation = AppErrorUi.from(details.exception);
    return Material(
      color: const Color(0xFFF8FAFC),
      child: AppErrorView(
        presentation: presentation,
        compact: false,
      ),
    );
  };
}

/// Maps any error to a non-technical Vietnamese message for end users.
String userFriendlyMessage(Object error) => AppErrorUi.friendlyMessage(error);

Future<T> runWithGracefulDegradation<T>({
  required Future<T> Function() action,
  required T fallback,
  void Function(Object error)? onError,
}) async {
  try {
    return await action();
  } catch (error, stack) {
    appErrorHandler.report(error, stack, context: 'graceful_degradation');
    onError?.call(error);
    return fallback;
  }
}

/// Simple client-side throttle helper for repeated user actions.
class ActionRateLimiter {
  final Duration cooldown;
  DateTime? _lastActionAt;

  ActionRateLimiter({required this.cooldown});

  bool get canAct {
    final last = _lastActionAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >= cooldown;
  }

  bool tryAct() {
    if (!canAct) return false;
    _lastActionAt = DateTime.now();
    return true;
  }
}

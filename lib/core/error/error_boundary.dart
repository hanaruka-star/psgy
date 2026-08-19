import 'package:flutter/material.dart';
import 'package:parking_link/core/error/app_error_handler.dart';
import 'package:parking_link/shared/widgets/app_error_view.dart';

/// Displays a calm recovery UI when [error] is set; otherwise renders [child].
///
/// Use with Riverpod `AsyncValue` or manual error state at screen level.
/// Build-time crashes are handled globally via [installGlobalErrorHandlers].
class ErrorBoundary extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final Widget child;
  final bool compact;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.error,
    this.onRetry,
    this.onGoHome,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (error == null) return child;

    appErrorHandler.report(error!, StackTrace.current, context: 'ErrorBoundary');

    return AppErrorView.fromError(
      error!,
      compact: compact,
      onPrimaryAction: onRetry,
      onSecondaryAction: onGoHome,
    );
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';

typedef RetryProgressCallback = void Function(int attempt, Duration nextDelay);

class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 800),
    this.maxDelay = const Duration(seconds: 8),
    this.backoffMultiplier = 2,
  });

  Duration delayForAttempt(int attempt) {
    final exponent = math.max(0, attempt - 1);
    final ms = initialDelay.inMilliseconds * math.pow(backoffMultiplier, exponent);
    return Duration(milliseconds: math.min(ms.round(), maxDelay.inMilliseconds));
  }

  bool shouldRetry(Object error, int attempt) {
    if (attempt >= maxAttempts) return false;
    final mapped = error is AppException ? error : mapFirebaseException(error);
    return mapped is NetworkException ||
        mapped is UnknownException && mapped.code == 'unavailable';
  }

  Future<T> run<T>({
    required Future<T> Function() action,
    RetryProgressCallback? onRetry,
  }) async {
    Object? lastError;
    StackTrace? lastStack;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await action();
      } catch (error, stack) {
        lastError = error;
        lastStack = stack;
        if (!shouldRetry(error, attempt)) {
          Error.throwWithStackTrace(
            error is AppException ? error : mapFirebaseException(error, stack),
            stack,
          );
        }
        final delay = delayForAttempt(attempt);
        onRetry?.call(attempt, delay);
        await Future<void>.delayed(delay);
      }
    }

    throw lastError is AppException
        ? lastError
        : mapFirebaseException(lastError!, lastStack);
  }
}

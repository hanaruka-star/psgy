import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:psgy/core/error/app_exception.dart';

abstract class MonitoringService {
  Future<void> initialize();

  Future<void> startTrace(String name);

  Future<void> stopTrace([String? name]);

  void putTraceMetric(String traceName, String metricName, int value);

  void logEvent(String name, Map<String, Object> params);

  void logBreadcrumb(String message, {Map<String, Object>? params});

  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, Object>? context,
  });

  Future<void> recordAppException(
    AppException exception, [
    StackTrace? stackTrace,
  ]);
}

class NoOpMonitoringService implements MonitoringService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> startTrace(String name) async {}

  @override
  Future<void> stopTrace([String? name]) async {}

  @override
  void putTraceMetric(String traceName, String metricName, int value) {}

  @override
  void logEvent(String name, Map<String, Object> params) {}

  @override
  void logBreadcrumb(String message, {Map<String, Object>? params}) {}

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, Object>? context,
  }) async {}

  @override
  Future<void> recordAppException(
    AppException exception, [
    StackTrace? stackTrace,
  ]) async {}
}

class FirebaseMonitoringService implements MonitoringService {
  FirebaseMonitoringService({
    FirebasePerformance? performance,
    FirebaseCrashlytics? crashlytics,
  })  : _performance = performance ?? FirebasePerformance.instance,
        _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebasePerformance _performance;
  final FirebaseCrashlytics _crashlytics;
  final Map<String, Trace> _traces = {};

  @override
  Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    await _performance.setPerformanceCollectionEnabled(!kDebugMode);

    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(
        recordError(error, stack, fatal: true),
      );
      return true;
    };
  }

  @override
  Future<void> startTrace(String name) async {
    if (_traces.containsKey(name)) {
      await stopTrace(name);
    }

    final trace = _performance.newTrace(name);
    await trace.start();
    _traces[name] = trace;
  }

  @override
  Future<void> stopTrace([String? name]) async {
    final traceName = name ?? _traces.keys.lastOrNull;
    if (traceName == null) return;

    final trace = _traces.remove(traceName);
    await trace?.stop();
  }

  @override
  void putTraceMetric(String traceName, String metricName, int value) {
    _traces[traceName]?.setMetric(metricName, value);
  }

  @override
  void logEvent(String name, Map<String, Object> params) {
    final payload = params.entries.map((e) => '${e.key}=${e.value}').join(', ');
    _crashlytics.log('event:$name {$payload}');
  }

  @override
  void logBreadcrumb(String message, {Map<String, Object>? params}) {
    if (params == null || params.isEmpty) {
      _crashlytics.log('breadcrumb:$message');
      return;
    }

    final payload = params.entries.map((e) => '${e.key}=${e.value}').join(', ');
    _crashlytics.log('breadcrumb:$message {$payload}');
  }

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, Object>? context,
  }) async {
    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    }

    await _crashlytics.recordError(
      error,
      stackTrace,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordAppException(
    AppException exception, [
    StackTrace? stackTrace,
  ]) async {
    await _crashlytics.setCustomKey('exception_type', exception.runtimeType.toString());
    if (exception.code != null) {
      await _crashlytics.setCustomKey('exception_code', exception.code!);
    }

    await recordError(
      exception,
      stackTrace,
      context: {
        'message': exception.message,
      },
    );
  }
}

extension _IterableLastOrNull<E> on Iterable<E> {
  E? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
}

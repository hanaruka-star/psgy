import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/debug/debug_providers.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.listen(debugSimulateOfflineProvider, (previous, next) {
    service.setDebugForceOffline(next);
  });
  ref.onDispose(service.dispose);
  return service;
});

final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isConnected;
});

class ConnectivityEvent {
  final bool isConnected;
  final bool wasOffline;
  final DateTime at;

  const ConnectivityEvent({
    required this.isConnected,
    required this.wasOffline,
    required this.at,
  });
}

class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();
  final StreamController<ConnectivityEvent> _eventsController =
      StreamController<ConnectivityEvent>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _currentStatus = true;
  bool _realStatus = true;
  bool _debugForceOffline = false;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    unawaited(_initialize());
  }

  Stream<bool> get isConnected => _statusController.stream;

  Stream<ConnectivityEvent> get events => _eventsController.stream;

  bool get currentStatus => _currentStatus;

  /// QA-only: simulate offline without disabling Wi‑Fi/cellular.
  void setDebugForceOffline(bool enabled) {
    _debugForceOffline = enabled;
    _applyEffectiveStatus();
  }

  void _applyEffectiveStatus() {
    _setStatus(_realStatus && !_debugForceOffline);
  }

  Future<void> _initialize() async {
    final initialResult = await _connectivity.checkConnectivity();
    _realStatus = _hasConnection(initialResult);
    _applyEffectiveStatus();

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _realStatus = _hasConnection(result);
      _applyEffectiveStatus();
    });
  }

  void _setStatus(bool isConnected, {bool emitEvent = true}) {
    final wasOffline = !_currentStatus && isConnected;
    _currentStatus = isConnected;

    if (!_statusController.isClosed) {
      _statusController.add(isConnected);
    }

    if (emitEvent && !_eventsController.isClosed) {
      _eventsController.add(
        ConnectivityEvent(
          isConnected: isConnected,
          wasOffline: wasOffline,
          at: DateTime.now(),
        ),
      );
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _statusController.close();
    await _eventsController.close();
  }
}

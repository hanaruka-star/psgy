import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/sync_providers.dart';

class SyncBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const SyncBootstrap({super.key, required this.child});

  @override
  ConsumerState<SyncBootstrap> createState() => _SyncBootstrapState();
}

class _SyncBootstrapState extends ConsumerState<SyncBootstrap>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TEMP: tắt cho demo pilot 2026-08-22, bật lại sau —
      // ref.read(backgroundSyncServiceProvider).start();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final syncService = ref.read(backgroundSyncServiceProvider);
    switch (state) {
      case AppLifecycleState.resumed:
        syncService.onAppForeground();
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        syncService.onAppBackground();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

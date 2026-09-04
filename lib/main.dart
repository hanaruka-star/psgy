import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/bootstrap/app_bootstrap.dart';
import 'package:psgy/core/config/app_mode.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/core/di/isar_providers.dart';
import 'package:psgy/core/messaging/fcm_background_handler.dart';
import 'package:psgy/core/routes/app_navigator.dart';
import 'package:psgy/core/theme/app_theme.dart';
import 'package:psgy/features/common/presentation/screens/app_root_screen.dart';
import 'package:psgy/features/common/presentation/screens/fatal_error_screen.dart';
import 'package:psgy/features/common/presentation/widgets/debug_menu_host.dart';
import 'package:psgy/shared/widgets/sync_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundMessageHandler);

  final bootstrap = await AppBootstrap.initialize();
  runParkingLinkApp(bootstrap);
}

/// Boots [ParkingLinkApp] inside a root [ProviderScope] with bootstrap overrides.
void runParkingLinkApp(AppBootstrapResult bootstrap) {
  if (bootstrap.status == AppBootstrapStatus.success) {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  }

  runApp(
    ProviderScope(
      overrides: _bootstrapOverrides(bootstrap),
      child: ParkingLinkApp(bootstrap: bootstrap),
    ),
  );
}

List<Override> _bootstrapOverrides(AppBootstrapResult bootstrap) {
  if (bootstrap.status != AppBootstrapStatus.success) {
    return const [];
  }

  return [
    isarProvider.overrideWithValue(bootstrap.isar!),
    monitoringServiceProvider.overrideWithValue(bootstrap.monitoringService!),
    appModeProvider.overrideWith((_) {
      final controller = AppModeController();
      if (FlavorConfig.isCoach) controller.switchToCoach();
      return controller;
    }),
  ];
}

class ParkingLinkApp extends StatelessWidget {
  final AppBootstrapResult bootstrap;

  const ParkingLinkApp({super.key, required this.bootstrap});

  @override
  Widget build(BuildContext context) {
    if (bootstrap.status != AppBootstrapStatus.success) {
      return MaterialApp(
        title: 'Parking Link',
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: FatalErrorScreen(
          error: bootstrap.error!,
          onRetry: () {
            unawaited(_retryBootstrap());
          },
        ),
      );
    }

    return MaterialApp(
      title: FlavorConfig.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return SyncBootstrap(
          child: DebugMenuHost(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const AppRootScreen(),
    );
  }

  static Future<void> _retryBootstrap() async {
    final result = await AppBootstrap.initialize();
    runParkingLinkApp(result);
  }
}

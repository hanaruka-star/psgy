import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/config/app_mode.dart';
import 'package:psgy/core/di/app_settings_providers.dart';
import 'package:psgy/features/auth/presentation/screens/login_screen.dart';
import 'package:psgy/features/common/presentation/screens/privacy_consent_screen.dart';
import 'package:psgy/features/common/presentation/screens/splash_screen.dart';
import 'package:psgy/features/user/presentation/screens/user_map_screen.dart';
import 'package:psgy/features/user/presentation/widgets/watchlist_notification_bootstrap.dart';

enum _AppStage { splash, consent, home }

class AppRootScreen extends ConsumerStatefulWidget {
  const AppRootScreen({super.key});

  @override
  ConsumerState<AppRootScreen> createState() => _AppRootScreenState();
}

class _AppRootScreenState extends ConsumerState<AppRootScreen> {
  _AppStage _stage = _AppStage.splash;

  void _finishSplash() {
    final consentAsync = ref.read(privacyConsentAcceptedProvider);
    final accepted = consentAsync.valueOrNull ?? false;

    setState(() {
      if (AppConfig.isProduction && !accepted) {
        _stage = _AppStage.consent;
      } else {
        _stage = _AppStage.home;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_stage) {
      _AppStage.splash => SplashScreen(
          appName: FlavorConfig.appName,
          onFinished: _finishSplash,
        ),
      _AppStage.consent => PrivacyConsentScreen(
          onAccepted: () => setState(() => _stage = _AppStage.home),
        ),
      _AppStage.home => const AppHomeScreen(),
    };
  }
}

class AppHomeScreen extends ConsumerWidget {
  const AppHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (AppConfig.showDevModeSwitcher) {
      return const ModeSwitcherScreen();
    }

    return FlavorConfig.isUser
        ? const WatchlistNotificationBootstrap(
            child: UserMapScreen(),
          )
        : const LoginScreen();
  }
}

/// Dev-only runtime toggle between User and Staff flows.
class ModeSwitcherScreen extends ConsumerWidget {
  const ModeSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeController = ref.watch(appModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.appName),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (modeController.isUser) {
                modeController.switchToStaff();
              } else {
                modeController.switchToUser();
              }
            },
            icon: Icon(modeController.isUser ? Icons.person : Icons.engineering),
            label: Text(
              modeController.isUser ? 'Chuyen sang Staff' : 'Chuyen sang User',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: modeController.isUser
          ? const WatchlistNotificationBootstrap(child: UserMapScreen())
          : const LoginScreen(),
    );
  }
}

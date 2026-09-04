enum AppEnvironment {
  development,
  staging,
  production,
}

/// Central app metadata and environment flags.
///
/// `--dart-define=ENV=development|staging|production` (default: development)
/// `--dart-define=FLAVOR=user|coach` handled by [FlavorConfig].
class AppConfig {
  static const appVersion = '1.0.0';
  static const buildNumber = '1';
  static const tagline = 'Tìm gym + đặt lịch Coach';
  static const privacyPolicyUrl = '';
  static const termsOfServiceUrl = '';
  static const supportEmail = 'support@psgy.app';

  static late AppEnvironment environment;

  static void initialize() {
    const envString =
        String.fromEnvironment('ENV', defaultValue: 'development');
    environment = switch (envString.toLowerCase()) {
      'staging' => AppEnvironment.staging,
      'production' || 'prod' => AppEnvironment.production,
      _ => AppEnvironment.development,
    };
  }

  static bool get isDevelopment => environment == AppEnvironment.development;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isProduction => environment == AppEnvironment.production;

  /// Dev-only runtime User/Coach toggle in AppBar.
  static bool get showDevModeSwitcher => isDevelopment;

  static String get environmentLabel => switch (environment) {
        AppEnvironment.development => 'Development',
        AppEnvironment.staging => 'Staging',
        AppEnvironment.production => 'Production',
      };

  static String get fullVersion => '$appVersion+$buildNumber';

  static String displayAppName(String flavorAppName) {
    if (isProduction) {
      return flavorAppName
          .replaceAll(' - User', '')
          .replaceAll(' - Coach', '')
          .replaceAll(' - Staff', '');
    }
    if (isStaging) return '$flavorAppName (Staging)';
    return '$flavorAppName (Dev)';
  }
}

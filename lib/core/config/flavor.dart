import 'app_config.dart';

enum AppFlavor {
  user,
  coach,
}

class FlavorConfig {
  static late AppFlavor flavor;
  static late String appName;
  static late String bundleId;

  static void initialize(AppFlavor f) {
    flavor = f;

    switch (f) {
      case AppFlavor.user:
        appName = AppConfig.displayAppName('PSgy');
        bundleId = 'com.psgy.user';
        break;
      case AppFlavor.coach:
        appName = AppConfig.displayAppName('PSgy Coach');
        bundleId = 'com.psgy.coach';
        break;
    }
  }

  static bool get isUser => flavor == AppFlavor.user;
  static bool get isCoach => flavor == AppFlavor.coach;
}

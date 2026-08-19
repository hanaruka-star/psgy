import 'app_config.dart';

enum AppFlavor {
  user,
  staff,
}

class FlavorConfig {
  static late AppFlavor flavor;
  static late String appName;
  static late String bundleId;

  static void initialize(AppFlavor f) {
    flavor = f;

    switch (f) {
      case AppFlavor.user:
        appName = AppConfig.displayAppName('Parking Link - User');
        bundleId = 'com.parkinglink.user';
        break;
      case AppFlavor.staff:
        appName = AppConfig.displayAppName('Parking Link - Staff');
        bundleId = 'com.parkinglink.staff';
        break;
    }
  }

  static bool get isUser => flavor == AppFlavor.user;
  static bool get isStaff => flavor == AppFlavor.staff;
}

import 'package:isar/isar.dart';

part 'app_settings_isar.g.dart';

@collection
class AppSettingsIsar {
  Id id = 1;

  bool privacyConsentAccepted = false;
  DateTime? privacyConsentAt;

  /// User opt-in for watchlist / potential-lot push notifications.
  bool watchlistNotificationsEnabled = true;

  /// Last selected map vehicle chip: `car`, `moto`, or `other`.
  String preferredVehicleFilter = 'moto';

  /// Local cache schema marker for one-time surveying cache migrations.
  int surveyingCacheSchemaVersion = 1;
}

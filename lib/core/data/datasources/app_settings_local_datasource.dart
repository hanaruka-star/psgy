import 'package:isar/isar.dart';
import 'package:psgy/core/data/local/app_settings_isar.dart';

class AppSettingsLocalDataSource {
  final Isar _isar;

  AppSettingsLocalDataSource(this._isar);

  Future<AppSettingsIsar> getSettings() async {
    final existing = await _isar.appSettingsIsars.get(1);
    if (existing != null) return existing;

    final defaults = AppSettingsIsar();
    await _isar.writeTxn(() async {
      await _isar.appSettingsIsars.put(defaults);
    });
    return defaults;
  }

  Stream<AppSettingsIsar> watchSettings() {
    return _isar.appSettingsIsars.watchObject(1, fireImmediately: true).map(
          (settings) => settings ?? AppSettingsIsar(),
        );
  }

  Future<void> setPrivacyConsentAccepted(bool accepted) async {
    await _isar.writeTxn(() async {
      final settings = await getSettings();
      settings.privacyConsentAccepted = accepted;
      settings.privacyConsentAt = accepted ? DateTime.now() : null;
      await _isar.appSettingsIsars.put(settings);
    });
  }

  Future<void> setWatchlistNotificationsEnabled(bool enabled) async {
    await _isar.writeTxn(() async {
      final settings = await getSettings();
      settings.watchlistNotificationsEnabled = enabled;
      await _isar.appSettingsIsars.put(settings);
    });
  }

  Future<void> setPreferredVehicleFilter(String filter) async {
    await _isar.writeTxn(() async {
      final settings = await getSettings();
      settings.preferredVehicleFilter = filter;
      await _isar.appSettingsIsars.put(settings);
    });
  }
}

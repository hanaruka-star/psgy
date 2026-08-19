import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/data/datasources/app_settings_local_datasource.dart';
import 'package:parking_link/core/di/isar_providers.dart';

final appSettingsLocalDataSourceProvider =
    Provider<AppSettingsLocalDataSource>((ref) {
  return AppSettingsLocalDataSource(ref.watch(isarProvider));
});

final privacyConsentAcceptedProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(appSettingsLocalDataSourceProvider)
      .watchSettings()
      .map((settings) => settings.privacyConsentAccepted);
});

final watchlistNotificationsEnabledProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(appSettingsLocalDataSourceProvider)
      .watchSettings()
      .map((settings) => settings.watchlistNotificationsEnabled);
});

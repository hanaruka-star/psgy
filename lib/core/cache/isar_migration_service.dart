import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:psgy/core/data/local/app_settings_isar.dart';

/// Centralized schema-aware migration runner for local Isar cache.
///
/// Versioning strategy:
/// - Persist current schema marker in [AppSettingsIsar.surveyingCacheSchemaVersion]
///   (field name kept to avoid regenerating Isar codecs; value is generic cache schema)
/// - Apply migrations incrementally from currentVersion+1..targetVersion
/// - Only clear affected collections when a breaking schema change occurs
class IsarMigrationService {
  static const targetSchemaVersion = 5;

  Future<void> migrate(Isar isar) async {
    final settings = await isar.appSettingsIsars.get(1);
    final currentVersion = settings?.surveyingCacheSchemaVersion ?? 1;

    if (currentVersion >= targetSchemaVersion) {
      debugPrint('[IsarMigration] up-to-date at v$currentVersion');
      return;
    }

    debugPrint(
      '[IsarMigration] start migration v$currentVersion -> v$targetSchemaVersion',
    );

    for (var version = currentVersion + 1;
        version <= targetSchemaVersion;
        version++) {
      await _applyMigration(isar, version);
    }

    await isar.writeTxn(() async {
      final upsert = settings ?? AppSettingsIsar();
      upsert.surveyingCacheSchemaVersion = targetSchemaVersion;
      await isar.appSettingsIsars.put(upsert);
    });

    debugPrint('[IsarMigration] completed at v$targetSchemaVersion');
  }

  Future<void> _applyMigration(Isar isar, int toVersion) async {
    switch (toVersion) {
      case 2:
      case 3:
      case 4:
        debugPrint('[IsarMigration] v$toVersion: no-op (legacy parking cache)');
        return;
      case 5:
        debugPrint(
          '[IsarMigration] v5: parking/surveying collections removed; AppSettings only',
        );
        return;
    }
  }
}

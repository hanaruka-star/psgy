import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:parking_link/core/data/local/app_settings_isar.dart';
import 'package:parking_link/features/parking/data/local/surveying_lot_isar.dart';

/// Centralized schema-aware migration runner for local Isar cache.
///
/// Versioning strategy:
/// - Persist current schema marker in [AppSettingsIsar.surveyingCacheSchemaVersion]
/// - Apply migrations incrementally from currentVersion+1..targetVersion
/// - Only clear affected collections when a breaking schema change occurs
class IsarMigrationService {
  static const targetSchemaVersion = 4;

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
        debugPrint('[IsarMigration] v2: no-op');
        return;
      case 3:
        // Existing behavior kept for compatibility:
        // survey cache schema changed and requires cache reset.
        await isar.writeTxn(() async {
          await isar.surveyingLotIsars.clear();
        });
        debugPrint(
          '[IsarMigration] v3: cleared affected collection surveyingLotIsars',
        );
        return;
      case 4:
        // Introduce schema-aware migration framework.
        debugPrint('[IsarMigration] v4: schema-aware migration service enabled');
        return;
    }
  }
}

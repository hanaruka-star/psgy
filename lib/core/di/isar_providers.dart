import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:psgy/core/cache/isar_migration_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psgy/core/data/local/app_settings_isar.dart';

final isarProvider = Provider<Isar>((ref) {
  throw StateError('Isar must be initialized in main() before runApp().');
});

/// Opens the local Isar cache. Instance name is `psgy` (renamed from the
/// clone's `parking_link` so leftover ParkingLink DBs are not reused).
Future<Isar> openPsgyIsar() async {
  if (Isar.instanceNames.contains('psgy')) {
    return Isar.getInstance('psgy')!;
  }

  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      AppSettingsIsarSchema,
    ],
    directory: directory.path,
    name: 'psgy',
  );

  await IsarMigrationService().migrate(isar);
  return isar;
}

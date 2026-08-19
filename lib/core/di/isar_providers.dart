import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:psgy/core/cache/isar_migration_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/features/parking/data/datasources/parking_local_datasource.dart';
import 'package:psgy/core/data/local/app_settings_isar.dart';
import 'package:psgy/features/parking/data/local/parking_lot_isar.dart';
import 'package:psgy/features/parking/data/local/parking_session_isar.dart';
import 'package:psgy/features/parking/data/local/surveying_lot_isar.dart';
import 'package:psgy/features/parking/data/local/vehicle_type_isar.dart';
import 'package:psgy/features/user/data/local/my_parking_record_isar.dart';
import 'package:psgy/features/user/data/local/watched_lot_isar.dart';

final isarProvider = Provider<Isar>((ref) {
  throw StateError('Isar must be initialized in main() before runApp().');
});

final parkingLocalDataSourceProvider = Provider<ParkingLocalDataSource>((ref) {
  return ParkingLocalDataSource(
    ref.watch(isarProvider),
    monitoring: ref.watch(monitoringServiceProvider),
  );
});

Future<Isar> openParkingIsar() async {
  if (Isar.instanceNames.contains('parking_link')) {
    return Isar.getInstance('parking_link')!;
  }

  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      ParkingLotIsarSchema,
      AppSettingsIsarSchema,
      ParkingSessionIsarSchema,
      VehicleTypeIsarSchema,
      SurveyingLotIsarSchema,
      WatchedLotIsarSchema,
      MyParkingRecordIsarSchema,
    ],
    directory: directory.path,
    name: 'parking_link',
  );

  await IsarMigrationService().migrate(isar);
  return isar;
}

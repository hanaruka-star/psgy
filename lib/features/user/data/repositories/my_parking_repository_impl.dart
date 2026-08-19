import 'package:parking_link/features/user/data/datasources/my_parking_local_datasource.dart';
import 'package:parking_link/features/user/data/datasources/my_parking_remote_datasource.dart';
import 'package:parking_link/features/user/data/local/my_parking_record_isar.dart';
import 'package:parking_link/features/user/domain/entities/active_session_info.dart';
import 'package:parking_link/features/user/domain/entities/my_parking_record.dart';
import 'package:parking_link/features/user/domain/repositories/i_my_parking_repository.dart';

class MyParkingRepositoryImpl implements IMyParkingRepository {
  const MyParkingRepositoryImpl({
    required IMyParkingLocalDatasource localDatasource,
    required IMyParkingRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  final IMyParkingLocalDatasource _localDatasource;
  final IMyParkingRemoteDatasource _remoteDatasource;

  @override
  Future<void> saveRecord(MyParkingRecord record) async {
    final localModel = MyParkingRecordIsar.fromEntity(record);
    await _localDatasource.saveRecord(localModel);
  }

  @override
  Future<MyParkingRecord?> getCurrentRecord() async {
    final localModel = await _localDatasource.getCurrentRecord();
    if (localModel == null) return null;
    return localModel.toEntity();
  }

  @override
  Future<void> clearRecord() => _localDatasource.clearRecord();

  @override
  Stream<ActiveSessionInfo?> watchActiveSession(String userId) {
    return _remoteDatasource.watchActiveSession(userId);
  }
}

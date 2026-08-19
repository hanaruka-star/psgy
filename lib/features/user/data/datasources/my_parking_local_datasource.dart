import 'package:isar/isar.dart';
import 'package:psgy/features/user/data/local/my_parking_record_isar.dart';

abstract class IMyParkingLocalDatasource {
  Future<void> saveRecord(MyParkingRecordIsar record);
  Future<MyParkingRecordIsar?> getCurrentRecord();
  Future<void> clearRecord();
}

class MyParkingLocalDatasourceImpl implements IMyParkingLocalDatasource {
  const MyParkingLocalDatasourceImpl(this._isar);

  final Isar _isar;

  @override
  Future<void> saveRecord(MyParkingRecordIsar record) async {
    await _isar.writeTxn(() async {
      await _isar.myParkingRecordIsars.put(record);
    });
  }

  @override
  Future<MyParkingRecordIsar?> getCurrentRecord() {
    return _isar.myParkingRecordIsars.where().sortByParkedAtDesc().findFirst();
  }

  @override
  Future<void> clearRecord() async {
    await _isar.writeTxn(() async {
      await _isar.myParkingRecordIsars.clear();
    });
  }
}

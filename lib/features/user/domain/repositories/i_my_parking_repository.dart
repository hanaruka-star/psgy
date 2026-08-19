import 'package:parking_link/features/user/domain/entities/active_session_info.dart';
import 'package:parking_link/features/user/domain/entities/my_parking_record.dart';

abstract class IMyParkingRepository {
  Future<void> saveRecord(MyParkingRecord record);
  Future<MyParkingRecord?> getCurrentRecord();
  Future<void> clearRecord();
  Stream<ActiveSessionInfo?> watchActiveSession(String userId);
}

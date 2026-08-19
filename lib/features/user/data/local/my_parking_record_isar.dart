import 'package:isar/isar.dart';
import 'package:psgy/features/user/domain/entities/my_parking_record.dart';
import 'package:psgy/features/user/domain/entities/parking_enums.dart';

part 'my_parking_record_isar.g.dart';

@collection
class MyParkingRecordIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String recordId;

  @Index()
  late DateTime parkedAt;

  late double latitude;
  late double longitude;
  String? photoPath;
  late String type;
  String? sessionId;
  String? lotId;
  String? lotName;
  double? lotLatitude;
  double? lotLongitude;

  MyParkingRecord toEntity() {
    return MyParkingRecord(
      id: recordId,
      parkedAt: parkedAt,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
      type: _parseType(type),
      sessionId: sessionId,
      lotId: lotId,
      lotName: lotName,
      lotLatitude: lotLatitude,
      lotLongitude: lotLongitude,
    );
  }

  static MyParkingRecordIsar fromEntity(MyParkingRecord entity) {
    return MyParkingRecordIsar()
      ..recordId = entity.id
      ..parkedAt = entity.parkedAt
      ..latitude = entity.latitude
      ..longitude = entity.longitude
      ..photoPath = entity.photoPath
      ..type = entity.type.name
      ..sessionId = entity.sessionId
      ..lotId = entity.lotId
      ..lotName = entity.lotName
      ..lotLatitude = entity.lotLatitude
      ..lotLongitude = entity.lotLongitude;
  }

  static ParkingRecordType _parseType(String value) {
    if (value == ParkingRecordType.checkedIn.name) {
      return ParkingRecordType.checkedIn;
    }
    return ParkingRecordType.selfManaged;
  }
}

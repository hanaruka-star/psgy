import 'package:isar/isar.dart';

part 'parking_session_isar.g.dart';

@collection
class ParkingSessionIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sessionId;

  @Index()
  late String lotId;

  @Index()
  late String vehicleType;

  @Index()
  late String status;

  late String vehiclePlate;
  late DateTime checkedInAt;
  DateTime? checkedOutAt;
  String? staffId;
  String? checkOutStaffId;
  String? metadataJson;
  String? userId;
  String? vehicleId;
  String? vehiclePhotoUrl;
  String? checkInMethod;
  String? checkOutMethod;
  String? checkOutTokenId;
  late DateTime cachedAt;
}

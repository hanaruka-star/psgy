import 'package:isar/isar.dart';

part 'parking_lot_isar.g.dart';

@collection
class ParkingLotIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String lotId;

  late String name;
  late String address;

  @Index()
  late double lat;

  @Index()
  late double lng;

  @Index()
  late String geohash;

  late String status;
  late String ownerId;
  late DateTime cachedAt;
}

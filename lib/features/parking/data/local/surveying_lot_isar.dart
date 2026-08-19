import 'package:isar/isar.dart';

part 'surveying_lot_isar.g.dart';

@collection
class SurveyingLotIsar {
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
  DateTime? surveyedAt;
  DateTime? estimatedOpeningAt;
  int? estimatedSlots;
  int? estimatedCarSlots;
  int? estimatedMotoSlots;
  String? imageUrl;
  int carPrice = 0;
  int motoPrice = 0;
  int totalSlots = 0;
  String vehicleTypes = '';
  String category = '';
  String? photoUrl;
  String? notes;
  String source = '';
  String surveyor = '';
  late DateTime cachedAt;
}

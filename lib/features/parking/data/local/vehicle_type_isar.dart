import 'package:isar/isar.dart';

part 'vehicle_type_isar.g.dart';

@collection
class VehicleTypeIsar {
  Id id = Isar.autoIncrement;

  @Index()
  late String lotId;

  late String typeId;

  late String type;
  late int totalSlots;
  late int availableSlots;
  late String pricingModel;
  late int priceAmount;
  int? monthlyAmount;
  late DateTime updatedAt;
  late DateTime cachedAt;
}

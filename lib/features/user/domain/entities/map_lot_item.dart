import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';

enum MapLotKind { active, surveying }

/// Unified map display model for active + surveying lots.
class MapLotItem {
  final MapLotKind kind;
  final ParkingLotEntity? parkingLot;
  final SurveyingLotEntity? surveyingLot;

  const MapLotItem.active(ParkingLotEntity lot)
      : kind = MapLotKind.active,
        parkingLot = lot,
        surveyingLot = null;

  const MapLotItem.surveying(SurveyingLotEntity lot)
      : kind = MapLotKind.surveying,
        parkingLot = null,
        surveyingLot = lot;

  String get id => kind == MapLotKind.active ? parkingLot!.id : surveyingLot!.id;

  String get mapKey => '${kind.name}:$id';

  double get lat =>
      kind == MapLotKind.active ? parkingLot!.lat : surveyingLot!.lat;

  double get lng =>
      kind == MapLotKind.active ? parkingLot!.lng : surveyingLot!.lng;

  String get name =>
      kind == MapLotKind.active ? parkingLot!.name : surveyingLot!.name;

  String get address =>
      kind == MapLotKind.active ? parkingLot!.address : surveyingLot!.address;

  bool get isActive => kind == MapLotKind.active;

  bool get isSurveying => kind == MapLotKind.surveying;

  /// Active lots render above surveying lots on the map.
  int get mapZIndex => kind == MapLotKind.active ? 3 : 1;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MapLotItem &&
            kind == other.kind &&
            parkingLot == other.parkingLot &&
            surveyingLot == other.surveyingLot;
  }

  @override
  int get hashCode => Object.hash(kind, parkingLot, surveyingLot);
}

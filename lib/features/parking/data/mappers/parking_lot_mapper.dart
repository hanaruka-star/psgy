import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:psgy/features/parking/data/models/parking_lot_model.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';

class ParkingLotMapper {
  const ParkingLotMapper._();

  static ParkingLotEntity toEntity(ParkingLotModel model) {
    return ParkingLotEntity(
      id: model.id,
      name: model.name,
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      status: model.status,
      ownerId: model.ownerId,
    );
  }

  static ParkingLotModel fromEntity(
    ParkingLotEntity entity, {
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    final now = Timestamp.now();
    return ParkingLotModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      lat: entity.lat,
      lng: entity.lng,
      status: entity.status,
      ownerId: entity.ownerId,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:parking_link/features/parking/data/models/parking_session_model.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';

class ParkingSessionMapper {
  const ParkingSessionMapper._();

  static ParkingSessionEntity toEntity(ParkingSessionModel model) {
    return ParkingSessionEntity(
      id: model.id,
      lotId: model.lotId,
      vehicleType: model.vehicleType,
      vehiclePlate: model.vehiclePlate,
      checkedInAt: model.checkedInAt.toDate(),
      checkedOutAt: model.checkedOutAt?.toDate(),
      status: model.status,
      staffId: model.staffId,
      checkOutStaffId: model.checkOutStaffId,
      metadata: model.metadata,
      userId: model.userId,
      vehicleId: model.vehicleId,
      vehiclePhotoUrl: model.vehiclePhotoUrl,
      checkInMethod: model.checkInMethod,
      checkOutMethod: model.checkOutMethod,
      checkOutTokenId: model.checkOutTokenId,
    );
  }

  static ParkingSessionModel fromEntity(
    ParkingSessionEntity entity, {
    Timestamp? checkedInAt,
    Timestamp? checkedOutAt,
  }) {
    return ParkingSessionModel(
      id: entity.id,
      lotId: entity.lotId,
      vehicleType: entity.vehicleType,
      vehiclePlate: entity.vehiclePlate,
      checkedInAt: checkedInAt ?? Timestamp.fromDate(entity.checkedInAt),
      checkedOutAt: checkedOutAt ??
          (entity.checkedOutAt != null
              ? Timestamp.fromDate(entity.checkedOutAt!)
              : null),
      status: entity.status,
      staffId: entity.staffId,
      checkOutStaffId: entity.checkOutStaffId,
      metadata: entity.metadata,
      userId: entity.userId,
      vehicleId: entity.vehicleId,
      vehiclePhotoUrl: entity.vehiclePhotoUrl,
      checkInMethod: entity.checkInMethod,
      checkOutMethod: entity.checkOutMethod,
      checkOutTokenId: entity.checkOutTokenId,
    );
  }
}

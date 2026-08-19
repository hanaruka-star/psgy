import 'dart:convert';

import 'package:parking_link/features/parking/data/local/parking_lot_isar.dart';
import 'package:parking_link/features/parking/data/local/parking_session_isar.dart';
import 'package:parking_link/features/parking/data/local/surveying_lot_isar.dart';
import 'package:parking_link/features/parking/data/local/vehicle_type_isar.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/core/utils/geohash_utils.dart';

class IsarMappers {
  const IsarMappers._();

  static ParkingLotIsar lotToIsar(ParkingLotEntity entity) {
    return ParkingLotIsar()
      ..lotId = entity.id
      ..name = entity.name
      ..address = entity.address
      ..lat = entity.lat
      ..lng = entity.lng
      ..geohash = GeohashUtils.encode(
        latitude: entity.lat,
        longitude: entity.lng,
      )
      ..status = entity.status
      ..ownerId = entity.ownerId
      ..cachedAt = DateTime.now();
  }

  static ParkingLotEntity lotFromIsar(ParkingLotIsar model) {
    return ParkingLotEntity(
      id: model.lotId,
      name: model.name,
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      status: model.status,
      ownerId: model.ownerId,
    );
  }

  static ParkingSessionIsar sessionToIsar(ParkingSessionEntity entity) {
    return ParkingSessionIsar()
      ..sessionId = entity.id
      ..lotId = entity.lotId
      ..vehicleType = entity.vehicleType
      ..vehiclePlate = entity.vehiclePlate
      ..checkedInAt = entity.checkedInAt
      ..checkedOutAt = entity.checkedOutAt
      ..status = entity.status
      ..staffId = entity.staffId
      ..checkOutStaffId = entity.checkOutStaffId
      ..metadataJson =
          entity.metadata == null ? null : jsonEncode(entity.metadata)
      ..userId = entity.userId
      ..vehicleId = entity.vehicleId
      ..vehiclePhotoUrl = entity.vehiclePhotoUrl
      ..checkInMethod = entity.checkInMethod
      ..checkOutMethod = entity.checkOutMethod
      ..checkOutTokenId = entity.checkOutTokenId
      ..cachedAt = DateTime.now();
  }

  static ParkingSessionEntity sessionFromIsar(ParkingSessionIsar model) {
    Map<String, dynamic>? metadata;
    if (model.metadataJson != null && model.metadataJson!.isNotEmpty) {
      metadata = jsonDecode(model.metadataJson!) as Map<String, dynamic>;
    }

    return ParkingSessionEntity(
      id: model.sessionId,
      lotId: model.lotId,
      vehicleType: model.vehicleType,
      vehiclePlate: model.vehiclePlate,
      checkedInAt: model.checkedInAt,
      checkedOutAt: model.checkedOutAt,
      status: model.status,
      staffId: model.staffId,
      checkOutStaffId: model.checkOutStaffId,
      metadata: metadata,
      userId: model.userId,
      vehicleId: model.vehicleId,
      vehiclePhotoUrl: model.vehiclePhotoUrl,
      checkInMethod: model.checkInMethod,
      checkOutMethod: model.checkOutMethod,
      checkOutTokenId: model.checkOutTokenId,
    );
  }

  static VehicleTypeIsar vehicleTypeToIsar({
    required String lotId,
    required VehicleTypeEntity entity,
  }) {
    return VehicleTypeIsar()
      ..lotId = lotId
      ..typeId = entity.id
      ..type = entity.type
      ..totalSlots = entity.totalSlots
      ..availableSlots = entity.availableSlots
      ..pricingModel = entity.pricingModel
      ..priceAmount = entity.priceAmount
      ..monthlyAmount = entity.monthlyAmount
      ..updatedAt = entity.updatedAt
      ..cachedAt = DateTime.now();
  }

  static VehicleTypeEntity vehicleTypeFromIsar(VehicleTypeIsar model) {
    return VehicleTypeEntity(
      id: model.typeId,
      type: model.type,
      totalSlots: model.totalSlots,
      availableSlots: model.availableSlots,
      pricingModel: model.pricingModel,
      priceAmount: model.priceAmount,
      monthlyAmount: model.monthlyAmount,
      updatedAt: model.updatedAt,
    );
  }

  static SurveyingLotIsar surveyingLotToIsar(SurveyingLotEntity entity) {
    return SurveyingLotIsar()
      ..lotId = entity.id
      ..name = entity.name
      ..address = entity.address
      ..lat = entity.lat
      ..lng = entity.lng
      ..geohash = GeohashUtils.encode(
        latitude: entity.lat,
        longitude: entity.lng,
      )
      ..status = entity.status
      ..surveyedAt = entity.surveyedAt
      ..estimatedOpeningAt = entity.estimatedOpeningAt
      ..estimatedSlots = entity.estimatedSlots
      ..estimatedCarSlots = entity.estimatedCarSlots
      ..estimatedMotoSlots = entity.estimatedMotoSlots
      ..imageUrl = entity.photoUrl
      ..carPrice = entity.carPrice
      ..motoPrice = entity.motoPrice
      ..totalSlots = entity.totalSlots
      ..vehicleTypes = entity.vehicleTypes
      ..category = entity.category
      ..photoUrl = entity.photoUrl
      ..notes = entity.notes
      ..source = entity.source
      ..surveyor = entity.surveyor
      ..cachedAt = DateTime.now();
  }

  static SurveyingLotEntity surveyingLotFromIsar(SurveyingLotIsar model) {
    return SurveyingLotEntity(
      id: model.lotId,
      name: model.name,
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      status: model.status,
      surveyedAt: model.surveyedAt,
      estimatedOpeningAt: model.estimatedOpeningAt,
      estimatedSlots: model.estimatedSlots,
      estimatedCarSlots: model.estimatedCarSlots,
      estimatedMotoSlots: model.estimatedMotoSlots,
      carPrice: model.carPrice,
      motoPrice: model.motoPrice,
      totalSlots: model.totalSlots,
      vehicleTypes: model.vehicleTypes,
      category: model.category,
      photoUrl: model.photoUrl ?? model.imageUrl,
      notes: model.notes ?? '',
      source: model.source,
      surveyor: model.surveyor,
    );
  }
}

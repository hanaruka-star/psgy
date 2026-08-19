import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:parking_link/features/parking/data/models/vehicle_type_model.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class VehicleTypeMapper {
  const VehicleTypeMapper._();

  static VehicleTypeEntity toEntity(VehicleTypeModel model) {
    return VehicleTypeEntity(
      id: model.id,
      type: model.type,
      totalSlots: model.totalSlots,
      availableSlots: model.availableSlots,
      pricingModel: model.pricingModel,
      priceAmount: model.priceAmount,
      monthlyAmount: model.monthlyAmount,
      updatedAt: model.updatedAt,
    );
  }

  static VehicleTypeModel fromEntity(VehicleTypeEntity entity) {
    return VehicleTypeModel(
      id: entity.id,
      type: entity.type,
      totalSlots: entity.totalSlots,
      availableSlots: entity.availableSlots,
      pricingModel: entity.pricingModel,
      priceAmount: entity.priceAmount,
      monthlyAmount: entity.monthlyAmount,
      updatedAt: entity.updatedAt,
    );
  }

  static Map<String, dynamic> toFirestore(VehicleTypeEntity entity) {
    return VehicleTypeMapper.fromEntity(entity).toFirestore();
  }

  static VehicleTypeEntity fromFirestoreMap(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return toEntity(
      VehicleTypeModel(
        id: (data['id'] as String?) ?? id,
        type: (data['type'] as String?) ?? '',
        totalSlots: (data['totalSlots'] as num?)?.toInt() ?? 0,
        availableSlots: (data['availableSlots'] as num?)?.toInt() ?? 0,
        pricingModel: (data['pricingModel'] as String?) ?? 'per_trip',
        priceAmount: (data['priceAmount'] as num?)?.toInt() ?? 0,
        monthlyAmount: (data['monthlyAmount'] as num?)?.toInt(),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ),
    );
  }
}

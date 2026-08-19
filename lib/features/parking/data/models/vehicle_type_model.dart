import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_link/features/parking/data/mappers/vehicle_type_mapper.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class VehicleTypeModel extends Equatable {
  final String id;
  final String type;
  final int totalSlots;
  final int availableSlots;
  final String pricingModel;
  final int priceAmount;
  final int? monthlyAmount;
  final DateTime updatedAt;

  const VehicleTypeModel({
    required this.id,
    required this.type,
    required this.totalSlots,
    required this.availableSlots,
    required this.pricingModel,
    required this.priceAmount,
    required this.monthlyAmount,
    required this.updatedAt,
  });

  factory VehicleTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return VehicleTypeModel(
      id: (data['id'] as String?) ?? doc.id,
      type: (data['type'] as String?) ?? '',
      totalSlots: (data['totalSlots'] as num?)?.toInt() ?? 0,
      availableSlots: (data['availableSlots'] as num?)?.toInt() ?? 0,
      pricingModel: (data['pricingModel'] as String?) ?? 'per_trip',
      priceAmount: (data['priceAmount'] as num?)?.toInt() ?? 0,
      monthlyAmount: (data['monthlyAmount'] as num?)?.toInt(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'type': type,
      'totalSlots': totalSlots,
      'availableSlots': availableSlots,
      'pricingModel': pricingModel,
      'priceAmount': priceAmount,
      'monthlyAmount': monthlyAmount,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  VehicleTypeEntity toEntity() => VehicleTypeMapper.toEntity(this);

  VehicleTypeModel copyWith({
    String? id,
    String? type,
    int? totalSlots,
    int? availableSlots,
    String? pricingModel,
    int? priceAmount,
    int? monthlyAmount,
    DateTime? updatedAt,
    bool clearMonthlyAmount = false,
  }) {
    return VehicleTypeModel(
      id: id ?? this.id,
      type: type ?? this.type,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      pricingModel: pricingModel ?? this.pricingModel,
      priceAmount: priceAmount ?? this.priceAmount,
      monthlyAmount:
          clearMonthlyAmount ? null : (monthlyAmount ?? this.monthlyAmount),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        totalSlots,
        availableSlots,
        pricingModel,
        priceAmount,
        monthlyAmount,
        updatedAt,
      ];
}

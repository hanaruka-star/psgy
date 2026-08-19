import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:psgy/features/parking/domain/entities/parking_slot_entity.dart';

class ParkingSlotModel extends Equatable {
  final String id;
  final String code;
  final String vehicleType;
  final String status;
  final String? vehiclePlate;
  final Timestamp? checkedInAt;
  final String? staffId;

  const ParkingSlotModel({
    required this.id,
    required this.code,
    required this.vehicleType,
    required this.status,
    this.vehiclePlate,
    this.checkedInAt,
    this.staffId,
  });

  factory ParkingSlotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ParkingSlotModel(
      id: (data['id'] as String?) ?? doc.id,
      code: (data['code'] as String?) ?? '',
      vehicleType: (data['vehicleType'] as String?) ?? 'moto',
      status: (data['status'] as String?) ?? 'empty',
      vehiclePlate: data['vehiclePlate'] as String?,
      checkedInAt: data['checkedInAt'] as Timestamp?,
      staffId: data['staffId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'code': code,
      'vehicleType': vehicleType,
      'status': status,
      'vehiclePlate': vehiclePlate,
      'checkedInAt': checkedInAt,
      'staffId': staffId,
    };
  }

  ParkingSlotEntity toEntity() {
    return ParkingSlotEntity(
      id: id,
      code: code,
      vehicleType: vehicleType,
      status: status,
      vehiclePlate: vehiclePlate,
      checkedInAt: checkedInAt?.toDate(),
      staffId: staffId,
    );
  }

  ParkingSlotModel copyWith({
    String? id,
    String? code,
    String? vehicleType,
    String? status,
    String? vehiclePlate,
    Timestamp? checkedInAt,
    String? staffId,
    bool clearVehiclePlate = false,
    bool clearCheckedInAt = false,
    bool clearStaffId = false,
  }) {
    return ParkingSlotModel(
      id: id ?? this.id,
      code: code ?? this.code,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      vehiclePlate:
          clearVehiclePlate ? null : (vehiclePlate ?? this.vehiclePlate),
      checkedInAt: clearCheckedInAt ? null : (checkedInAt ?? this.checkedInAt),
      staffId: clearStaffId ? null : (staffId ?? this.staffId),
    );
  }

  @override
  List<Object?> get props =>
      [id, code, vehicleType, status, vehiclePlate, checkedInAt, staffId];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:psgy/features/parking/data/mappers/parking_session_mapper.dart';
import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';

class ParkingSessionModel extends Equatable {
  final String id;
  final String lotId;
  final String vehicleType;
  final String vehiclePlate;
  final Timestamp checkedInAt;
  final Timestamp? checkedOutAt;
  final String status;
  final String? staffId;
  final String? checkOutStaffId;
  final Map<String, dynamic>? metadata;
  final String? userId;
  final String? vehicleId;
  final String? vehiclePhotoUrl;
  final String? checkInMethod;
  final String? checkOutMethod;
  final String? checkOutTokenId;

  const ParkingSessionModel({
    required this.id,
    required this.lotId,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.checkedInAt,
    required this.checkedOutAt,
    required this.status,
    required this.staffId,
    required this.checkOutStaffId,
    required this.metadata,
    this.userId,
    this.vehicleId,
    this.vehiclePhotoUrl,
    this.checkInMethod,
    this.checkOutMethod,
    this.checkOutTokenId,
  });

  factory ParkingSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ParkingSessionModel(
      id: (data['id'] as String?) ?? doc.id,
      lotId: (data['lotId'] as String?) ?? '',
      vehicleType: (data['vehicleType'] as String?) ?? '',
      vehiclePlate: (data['vehiclePlate'] as String?) ?? '',
      checkedInAt: (data['checkedInAt'] as Timestamp?) ?? Timestamp.now(),
      checkedOutAt: data['checkedOutAt'] as Timestamp?,
      status: (data['status'] as String?) ?? 'active',
      staffId: data['staffId'] as String?,
      checkOutStaffId: data['checkOutStaffId'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
      userId: data['userId'] as String?,
      vehicleId: data['vehicleId'] as String?,
      vehiclePhotoUrl: data['vehiclePhotoUrl'] as String?,
      checkInMethod: data['checkInMethod'] as String?,
      checkOutMethod: data['checkOutMethod'] as String?,
      checkOutTokenId: data['checkOutTokenId'] as String?,
    );
  }

  factory ParkingSessionModel.fromJson(Map<String, dynamic> json) {
    return ParkingSessionModel(
      id: json['id'] as String? ?? '',
      lotId: json['lotId'] as String? ?? '',
      vehicleType: json['vehicleType'] as String? ?? '',
      vehiclePlate: json['vehiclePlate'] as String? ?? '',
      checkedInAt: json['checkedInAt'] is Timestamp
          ? json['checkedInAt'] as Timestamp
          : Timestamp.now(),
      checkedOutAt: json['checkedOutAt'] as Timestamp?,
      status: json['status'] as String? ?? 'active',
      staffId: json['staffId'] as String?,
      checkOutStaffId: json['checkOutStaffId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      vehiclePhotoUrl: json['vehiclePhotoUrl'] as String?,
      checkInMethod: json['checkInMethod'] as String?,
      checkOutMethod: json['checkOutMethod'] as String?,
      checkOutTokenId: json['checkOutTokenId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'lotId': lotId,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'checkedInAt': checkedInAt,
      if (checkedOutAt != null) 'checkedOutAt': checkedOutAt,
      'status': status,
      if (staffId != null) 'staffId': staffId,
      if (checkOutStaffId != null) 'checkOutStaffId': checkOutStaffId,
      if (metadata != null) 'metadata': metadata,
      if (userId != null) 'userId': userId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (vehiclePhotoUrl != null) 'vehiclePhotoUrl': vehiclePhotoUrl,
      if (checkInMethod != null) 'checkInMethod': checkInMethod,
      if (checkOutMethod != null) 'checkOutMethod': checkOutMethod,
      if (checkOutTokenId != null) 'checkOutTokenId': checkOutTokenId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lotId': lotId,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'checkedInAt': checkedInAt,
      'checkedOutAt': checkedOutAt,
      'status': status,
      'staffId': staffId,
      'checkOutStaffId': checkOutStaffId,
      'metadata': metadata,
      'userId': userId,
      'vehicleId': vehicleId,
      'vehiclePhotoUrl': vehiclePhotoUrl,
      'checkInMethod': checkInMethod,
      'checkOutMethod': checkOutMethod,
      'checkOutTokenId': checkOutTokenId,
    };
  }

  ParkingSessionEntity toEntity() => ParkingSessionMapper.toEntity(this);

  @override
  List<Object?> get props => [
        id,
        lotId,
        vehicleType,
        vehiclePlate,
        checkedInAt,
        checkedOutAt,
        status,
        staffId,
        checkOutStaffId,
        metadata,
        userId,
        vehicleId,
        vehiclePhotoUrl,
        checkInMethod,
        checkOutMethod,
        checkOutTokenId,
      ];
}

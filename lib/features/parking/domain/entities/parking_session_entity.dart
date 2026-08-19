class ParkingSessionEntity {
  final String id;
  final String lotId;
  final String vehicleType;
  final String vehiclePlate;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;
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

  const ParkingSessionEntity({
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

  bool get isActive => status == 'active';

  Duration get parkingDuration => DateTime.now().difference(checkedInAt);

  ParkingSessionEntity copyWith({
    String? id,
    String? lotId,
    String? vehicleType,
    String? vehiclePlate,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    String? status,
    String? staffId,
    String? checkOutStaffId,
    Map<String, dynamic>? metadata,
    String? userId,
    String? vehicleId,
    String? vehiclePhotoUrl,
    String? checkInMethod,
    String? checkOutMethod,
    String? checkOutTokenId,
  }) {
    return ParkingSessionEntity(
      id: id ?? this.id,
      lotId: lotId ?? this.lotId,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      status: status ?? this.status,
      staffId: staffId ?? this.staffId,
      checkOutStaffId: checkOutStaffId ?? this.checkOutStaffId,
      metadata: metadata ?? this.metadata,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehiclePhotoUrl: vehiclePhotoUrl ?? this.vehiclePhotoUrl,
      checkInMethod: checkInMethod ?? this.checkInMethod,
      checkOutMethod: checkOutMethod ?? this.checkOutMethod,
      checkOutTokenId: checkOutTokenId ?? this.checkOutTokenId,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ParkingSessionEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            lotId == other.lotId &&
            vehicleType == other.vehicleType &&
            vehiclePlate == other.vehiclePlate &&
            checkedInAt == other.checkedInAt &&
            checkedOutAt == other.checkedOutAt &&
            status == other.status &&
            staffId == other.staffId &&
            checkOutStaffId == other.checkOutStaffId &&
            metadata == other.metadata &&
            userId == other.userId &&
            vehicleId == other.vehicleId &&
            vehiclePhotoUrl == other.vehiclePhotoUrl &&
            checkInMethod == other.checkInMethod &&
            checkOutMethod == other.checkOutMethod &&
            checkOutTokenId == other.checkOutTokenId;
  }

  @override
  int get hashCode => Object.hash(
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
      );
}

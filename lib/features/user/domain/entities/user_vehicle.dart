class UserVehicle {
  final String vehicleId;
  final String userId;
  final String plate;
  final String plateNormalized;
  final String photoUrl;
  final bool isPersonal;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserVehicle({
    required this.vehicleId,
    required this.userId,
    required this.plate,
    required this.plateNormalized,
    required this.photoUrl,
    required this.isPersonal,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  UserVehicle copyWith({
    String? vehicleId,
    String? userId,
    String? plate,
    String? plateNormalized,
    String? photoUrl,
    bool? isPersonal,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserVehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      plate: plate ?? this.plate,
      plateNormalized: plateNormalized ?? this.plateNormalized,
      photoUrl: photoUrl ?? this.photoUrl,
      isPersonal: isPersonal ?? this.isPersonal,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserVehicle &&
            runtimeType == other.runtimeType &&
            vehicleId == other.vehicleId &&
            userId == other.userId &&
            plate == other.plate &&
            plateNormalized == other.plateNormalized &&
            photoUrl == other.photoUrl &&
            isPersonal == other.isPersonal &&
            isDefault == other.isDefault &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        vehicleId,
        userId,
        plate,
        plateNormalized,
        photoUrl,
        isPersonal,
        isDefault,
        createdAt,
        updatedAt,
      );
}

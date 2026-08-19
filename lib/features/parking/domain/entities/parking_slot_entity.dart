class ParkingSlotEntity {
  final String id;
  final String code;
  final String vehicleType;
  final String status;
  final String? vehiclePlate;
  final DateTime? checkedInAt;
  final String? staffId;

  const ParkingSlotEntity({
    required this.id,
    required this.code,
    required this.vehicleType,
    required this.status,
    this.vehiclePlate,
    this.checkedInAt,
    this.staffId,
  });

  bool get isEmpty => status == 'empty';

  bool get isOccupied => status == 'occupied';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ParkingSlotEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            code == other.code &&
            vehicleType == other.vehicleType &&
            status == other.status &&
            vehiclePlate == other.vehiclePlate &&
            checkedInAt == other.checkedInAt &&
            staffId == other.staffId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        code,
        vehicleType,
        status,
        vehiclePlate,
        checkedInAt,
        staffId,
      );
}

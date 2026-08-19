enum HistoryActionEntity { checkIn, checkOut, manual }

class HistoryItemEntity {
  final String id;
  final HistoryActionEntity action;
  final String? vehiclePlate;
  final String vehicleType;
  final DateTime timestamp;
  final int? delta;
  final String? reason;

  const HistoryItemEntity({
    required this.id,
    required this.action,
    required this.vehiclePlate,
    required this.vehicleType,
    required this.timestamp,
    required this.delta,
    required this.reason,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HistoryItemEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            action == other.action &&
            vehiclePlate == other.vehiclePlate &&
            vehicleType == other.vehicleType &&
            timestamp == other.timestamp &&
            delta == other.delta &&
            reason == other.reason;
  }

  @override
  int get hashCode => Object.hash(
        id,
        action,
        vehiclePlate,
        vehicleType,
        timestamp,
        delta,
        reason,
      );
}

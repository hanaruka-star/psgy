class ManualAdjustmentEntity {
  final String id;
  final String lotId;
  final String vehicleType;
  final int delta;
  final String? reason;
  final String staffId;
  final DateTime createdAt;

  const ManualAdjustmentEntity({
    required this.id,
    required this.lotId,
    required this.vehicleType,
    required this.delta,
    required this.reason,
    required this.staffId,
    required this.createdAt,
  });
}

enum HistoryAction { checkIn, checkOut, manual }

class HistoryItemUiModel {
  final String id;
  final HistoryAction action;
  final String? vehiclePlate;
  final String vehicleType;
  final DateTime timestamp;
  final int? delta;
  final String? reason;

  const HistoryItemUiModel({
    required this.id,
    required this.action,
    required this.vehiclePlate,
    required this.vehicleType,
    required this.timestamp,
    required this.delta,
    required this.reason,
  });
}

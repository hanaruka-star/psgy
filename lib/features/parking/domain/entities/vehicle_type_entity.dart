class VehicleTypeEntity {
  final String id;
  final String type;
  final int totalSlots;
  final int availableSlots;
  final String pricingModel;
  final int priceAmount;
  final int? monthlyAmount;
  final DateTime updatedAt;

  const VehicleTypeEntity({
    required this.id,
    required this.type,
    required this.totalSlots,
    required this.availableSlots,
    required this.pricingModel,
    required this.priceAmount,
    required this.monthlyAmount,
    required this.updatedAt,
  });

  bool get isFull => availableSlots == 0;

  bool get isPerTrip => pricingModel == 'per_trip';

  bool get isPerDay => pricingModel == 'per_day';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VehicleTypeEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            type == other.type &&
            totalSlots == other.totalSlots &&
            availableSlots == other.availableSlots &&
            pricingModel == other.pricingModel &&
            priceAmount == other.priceAmount &&
            monthlyAmount == other.monthlyAmount &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        totalSlots,
        availableSlots,
        pricingModel,
        priceAmount,
        monthlyAmount,
        updatedAt,
      );
}

class PricingModel {
  const PricingModel._();

  static const perTrip = 'per_trip';
  static const perDay = 'per_day';

  static const values = [perTrip, perDay];

  static bool isValid(String model) => values.contains(model);
}

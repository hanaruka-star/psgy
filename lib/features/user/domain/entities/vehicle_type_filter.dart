/// Header vehicle filter values for map + bottom sheet.
abstract final class VehicleTypeFilter {
  static const car = 'car';
  static const moto = 'moto';
  static const all = 'all';
  // Legacy value kept for backward compatibility with old persisted settings.
  static const other = 'other';

  static const defaultFilter = moto;

  static const values = [car, moto, all, other];

  static bool isValid(String? value) {
    return value != null && values.contains(value);
  }
}

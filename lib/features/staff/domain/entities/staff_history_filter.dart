enum StaffHistoryFilter { all, car, moto }

extension StaffHistoryFilterX on StaffHistoryFilter {
  String? get vehicleType {
    switch (this) {
      case StaffHistoryFilter.all:
        return null;
      case StaffHistoryFilter.car:
        return 'car';
      case StaffHistoryFilter.moto:
        return 'moto';
    }
  }
}

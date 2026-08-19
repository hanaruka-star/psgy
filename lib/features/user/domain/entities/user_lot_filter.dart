class UserLotFilter {
  final String? vehicleType;
  final bool availableOnly;
  final bool openOnly;

  const UserLotFilter({
    this.vehicleType,
    this.availableOnly = false,
    this.openOnly = false,
  });
}

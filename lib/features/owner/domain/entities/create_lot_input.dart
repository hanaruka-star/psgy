class CreateLotInput {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final List<VehicleTypeInput> vehicleTypes;

  const CreateLotInput({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.vehicleTypes,
  });
}

class VehicleTypeInput {
  final String type;
  final int totalSlots;
  final String pricingModel;
  final int priceAmount;

  const VehicleTypeInput({
    required this.type,
    required this.totalSlots,
    required this.pricingModel,
    required this.priceAmount,
  });
}

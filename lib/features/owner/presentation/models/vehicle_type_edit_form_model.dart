import 'package:flutter/material.dart';
import 'package:parking_link/features/owner/domain/entities/pricing_model.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class VehicleTypeEditFormModel {
  final VehicleTypeEntity vehicleType;
  final TextEditingController totalSlotsController;
  final TextEditingController priceAmountController;
  String pricingModel;

  VehicleTypeEditFormModel(this.vehicleType)
      : totalSlotsController = TextEditingController(
          text: vehicleType.totalSlots.toString(),
        ),
        priceAmountController = TextEditingController(
          text: vehicleType.priceAmount.toString(),
        ),
        pricingModel = vehicleType.pricingModel;

  bool get hasChanges {
    final nextTotalSlots = int.tryParse(totalSlotsController.text.trim());
    final nextPriceAmount = int.tryParse(priceAmountController.text.trim());
    return nextTotalSlots != vehicleType.totalSlots ||
        nextPriceAmount != vehicleType.priceAmount ||
        pricingModel != vehicleType.pricingModel;
  }

  void dispose() {
    totalSlotsController.dispose();
    priceAmountController.dispose();
  }
}

List<DropdownMenuItem<String>> pricingModelDropdownItems() {
  return PricingModel.values
      .map(
        (value) => DropdownMenuItem(
          value: value,
          child: Text(value),
        ),
      )
      .toList(growable: false);
}

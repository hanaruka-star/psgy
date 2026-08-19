import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_link/features/parking/data/models/parking_lot_model.dart';
import 'package:parking_link/features/parking/data/models/parking_slot_model.dart';
import 'package:parking_link/features/parking/data/models/vehicle_type_model.dart';

const seedLotANguyenHueQ1Id = 'lot_a_nguyen_hue_q1';
const seedLotBLeVanSyQ3Id = 'lot_b_le_van_sy_q3';
const seedLotCVincomDongKhoiQ1Id = 'lot_c_vincom_dong_khoi_q1';

Future<void> seedToFirestore() async {
  final firestore = FirebaseFirestore.instance;
  final now = Timestamp.now();
  final lotsCollection = firestore.collection('parking_lots');

  final existing = await lotsCollection.limit(1).get();
  if (existing.docs.isNotEmpty) {
    return;
  }

  final batch = firestore.batch();

  final lots = <ParkingLotModel>[
    ParkingLotModel(
      id: seedLotANguyenHueQ1Id,
      name: 'Bai A - Nguyen Hue',
      address: 'Duong Nguyen Hue, Quan 1, TP.HCM',
      lat: 10.7740,
      lng: 106.7037,
      status: 'open',
      ownerId: 'owner_demo',
      createdAt: now,
      updatedAt: now,
    ),
    ParkingLotModel(
      id: seedLotBLeVanSyQ3Id,
      name: 'Bai B - Le Van Sy',
      address: 'Duong Le Van Sy, Quan 3, TP.HCM',
      lat: 10.7879,
      lng: 106.6826,
      status: 'open',
      ownerId: 'owner_demo',
      createdAt: now,
      updatedAt: now,
    ),
    ParkingLotModel(
      id: seedLotCVincomDongKhoiQ1Id,
      name: 'Bai C - Vincom Dong Khoi',
      address: '72 Le Thanh Ton, Ben Nghe, Quan 1, TP.HCM',
      lat: 10.7780,
      lng: 106.7035,
      status: 'open',
      ownerId: 'owner_demo',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  final lotVehicleTypes = <String, List<VehicleTypeModel>>{
    seedLotANguyenHueQ1Id: [
      VehicleTypeModel(
        id: 'car',
        type: 'car',
        totalSlots: 10,
        availableSlots: 10,
        pricingModel: 'per_day',
        priceAmount: 40000,
        monthlyAmount: null,
        updatedAt: now.toDate(),
      ),
      VehicleTypeModel(
        id: 'moto',
        type: 'moto',
        totalSlots: 100,
        availableSlots: 100,
        pricingModel: 'per_day',
        priceAmount: 10000,
        monthlyAmount: null,
        updatedAt: now.toDate(),
      ),
    ],
    seedLotBLeVanSyQ3Id: [
      VehicleTypeModel(
        id: 'car',
        type: 'car',
        totalSlots: 20,
        availableSlots: 20,
        pricingModel: 'per_day',
        priceAmount: 35000,
        monthlyAmount: null,
        updatedAt: now.toDate(),
      ),
      VehicleTypeModel(
        id: 'moto',
        type: 'moto',
        totalSlots: 80,
        availableSlots: 80,
        pricingModel: 'per_day',
        priceAmount: 8000,
        monthlyAmount: null,
        updatedAt: now.toDate(),
      ),
    ],
    seedLotCVincomDongKhoiQ1Id: [
      VehicleTypeModel(
        id: 'moto',
        type: 'moto',
        totalSlots: 50,
        availableSlots: 50,
        pricingModel: 'per_trip',
        priceAmount: 5000,
        monthlyAmount: null,
        updatedAt: now.toDate(),
      ),
    ],
  };

  for (final lot in lots) {
    final lotRef = lotsCollection.doc(lot.id);
    batch.set(lotRef, lot.toFirestore());

    final vehicleTypes = lotVehicleTypes[lot.id] ?? <VehicleTypeModel>[];
    for (final vehicleType in vehicleTypes) {
      final vehicleTypeRef =
          lotRef.collection('vehicle_types').doc(vehicleType.id);
      batch.set(vehicleTypeRef, {
        ...vehicleType.toFirestore(),
        'createdAt': now,
      });

      for (var i = 1; i <= vehicleType.totalSlots; i++) {
        final prefix = vehicleType.type == 'car' ? 'C' : 'M';
        final code = '$prefix${i.toString().padLeft(3, '0')}';
        final slotId = '${vehicleType.type}_${code.toLowerCase()}';
        final slot = ParkingSlotModel(
          id: slotId,
          code: code,
          vehicleType: vehicleType.type,
          status: 'empty',
          vehiclePlate: null,
          checkedInAt: null,
          staffId: null,
        );

        final slotRef = lotRef.collection('slots').doc(slotId);
        batch.set(slotRef, {
          ...slot.toFirestore(),
          'createdAt': now,
          'updatedAt': now,
        });
      }
    }
  }

  await batch.commit();
}

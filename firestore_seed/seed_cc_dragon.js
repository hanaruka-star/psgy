const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seedCCDragon() {
  const lotId = 'lot_cc_dragon';
  const ownerUid = 'MpES1KcgtfeypJNX7YVIT91aCV92';
  const now = admin.firestore.Timestamp.now();

  // 1. Tao parking_lot
  await db.collection('parking_lots').doc(lotId).set({
    name: 'CC Dragon',
    address: 'Chung cu CC Dragon, TP.HCM',
    lat: 10.762215,
    lng: 106.758809,
    status: 'open',
    ownerId: ownerUid,
    createdAt: now,
    updatedAt: now,
  });
  console.log('parking_lots/lot_cc_dragon created');

  // 2. Tao vehicle_types
  await db
    .collection('parking_lots')
    .doc(lotId)
    .collection('vehicle_types')
    .doc('moto')
    .set({
      type: 'moto',
      totalSlots: 200,
      availableSlots: 200,
      pricingModel: 'per_trip',
      priceAmount: 5000,
      monthlyAmount: null,
      createdAt: now,
      updatedAt: now,
    });
  console.log('vehicle_types/moto created');

  await db
    .collection('parking_lots')
    .doc(lotId)
    .collection('vehicle_types')
    .doc('car')
    .set({
      type: 'car',
      totalSlots: 100,
      availableSlots: 100,
      pricingModel: 'per_trip',
      priceAmount: 30000,
      monthlyAmount: null,
      createdAt: now,
      updatedAt: now,
    });
  console.log('vehicle_types/car created');

  // 3. Update owner lotId
  await db.collection('staff_profiles').doc(ownerUid).update({
    lotId: lotId,
    updatedAt: now,
  });
  console.log('staff_profiles owner updated with lotId');

  // 4. Tao pricing_history
  await db.collection('pricing_history').add({
    lotId: lotId,
    vehicleTypeId: 'moto',
    oldPrice: 0,
    newPrice: 5000,
    pricingModel: 'per_trip',
    changedBy: ownerUid,
    changedAt: now,
    createdAt: now,
    updatedAt: now,
  });

  await db.collection('pricing_history').add({
    lotId: lotId,
    vehicleTypeId: 'car',
    oldPrice: 0,
    newPrice: 30000,
    pricingModel: 'per_trip',
    changedBy: ownerUid,
    changedAt: now,
    createdAt: now,
    updatedAt: now,
  });
  console.log('pricing_history created');

  console.log('CC Dragon setup complete!');
  process.exit(0);
}

seedCCDragon().catch((err) => {
  console.error('Error:', err);
  process.exit(1);
});

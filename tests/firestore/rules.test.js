/**
 * ParkingLink Firestore Security Rules — emulator tests (CP25)
 *
 * Run:
 *   firebase emulators:exec --only firestore --project parkinglink-v2 \
 *     "cd tests/firestore && npm install && npm test"
 */
const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');

const PROJECT_ID = 'parkinglink-v2';
const RULES = fs.readFileSync(
  path.resolve(__dirname, '../../firestore.rules'),
  'utf8',
);

let testEnv;

async function seedBaseData(context) {
  await testEnv.withSecurityRulesDisabled(async (disabledContext) => {
    const db = disabledContext.firestore();

    await db.doc('parking_lots/lot_a').set({
      id: 'lot_a',
      name: 'Lot A',
      address: 'Address A',
      lat: 10.77,
      lng: 106.7,
      status: 'open',
      ownerId: 'owner_uid',
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    await db.doc('parking_lots/lot_a/vehicle_types/moto').set({
      id: 'moto',
      type: 'moto',
      totalSlots: 10,
      availableSlots: 5,
      pricingModel: 'per_day',
      priceAmount: 10000,
      updatedAt: new Date(),
    });

    await db.doc('staff_profiles/staff_uid').set({
      uid: 'staff_uid',
      name: 'Staff A',
      email: 'staff@test.com',
      role: 'staff',
      lotId: 'lot_a',
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    await db.doc('staff_profiles/owner_uid').set({
      uid: 'owner_uid',
      name: 'Owner A',
      email: 'owner@test.com',
      role: 'owner',
      lotId: 'lot_a',
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    await db.doc('surveying_lots/survey_1').set({
      name: 'Future Lot',
      address: 'Planned address',
      lat: 10.78,
      lng: 106.71,
      status: 'surveying',
    });
  });
}

async function run() {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: { rules: RULES },
  });

  await seedBaseData();

  // --- User app: public reads ---
  {
    const anon = testEnv.unauthenticatedContext();
    const db = anon.firestore();
    await assertSucceeds(db.doc('parking_lots/lot_a').get());
    await assertSucceeds(db.doc('parking_lots/lot_a/vehicle_types/moto').get());
    await assertSucceeds(db.doc('surveying_lots/survey_1').get());
    await assertFails(db.doc('parking_sessions/s1').get());
  }

  // --- surveying_lots: no client writes ---
  {
    const authed = testEnv.authenticatedContext('anyone', { email: 'x@test.com' });
    const db = authed.firestore();
    await assertFails(
      db.doc('surveying_lots/hacked').set({ name: 'Hack', status: 'surveying' }),
    );
  }

  // --- Staff check-in blocked without profile ---
  {
    const stranger = testEnv.authenticatedContext('stranger', { email: 's@test.com' });
    const db = stranger.firestore();
    await assertFails(
      db.collection('parking_sessions').doc('sess_1').set({
        id: 'sess_1',
        lotId: 'lot_a',
        vehicleType: 'moto',
        vehiclePlate: '51A-12345',
        checkedInAt: new Date(),
        status: 'active',
        staffId: 'stranger',
        metadata: {},
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
    );
  }

  // --- Staff check-in with valid profile + available slot ---
  {
    const staff = testEnv.authenticatedContext('staff_uid', { email: 'staff@test.com' });
    const db = staff.firestore();
    await assertSucceeds(
      db.collection('parking_sessions').doc('sess_ok').set({
        id: 'sess_ok',
        lotId: 'lot_a',
        vehicleType: 'moto',
        vehiclePlate: '51A-12345',
        checkedInAt: new Date(),
        status: 'active',
        staffId: 'staff_uid',
        metadata: { check_in_method: 'manual' },
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
    );
  }

  // --- Staff cannot read other lot sessions (no doc seeded — create then read as wrong lot staff) ---
  {
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await ctx.firestore().doc('parking_sessions/other_lot_sess').set({
        id: 'other_lot_sess',
        lotId: 'lot_b',
        vehicleType: 'moto',
        vehiclePlate: '51B-99999',
        checkedInAt: new Date(),
        status: 'active',
        staffId: 'other_staff',
        metadata: {},
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    });

    const staff = testEnv.authenticatedContext('staff_uid', { email: 'staff@test.com' });
    await assertFails(
      staff.firestore().doc('parking_sessions/other_lot_sess').get(),
    );
  }

  // --- Owner can update lot status ---
  {
    const owner = testEnv.authenticatedContext('owner_uid', { email: 'owner@test.com' });
    await assertSucceeds(
      owner.firestore().doc('parking_lots/lot_a').update({
        status: 'closed',
        updatedAt: new Date(),
      }),
    );
  }

  // --- Default deny unknown collection ---
  {
    const owner = testEnv.authenticatedContext('owner_uid', { email: 'owner@test.com' });
    await assertFails(
      owner.firestore().doc('secret_data/abc').set({ value: 1 }),
    );
  }

  console.log('All Firestore rules tests passed.');
  await testEnv.cleanup();
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});

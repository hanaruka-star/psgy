const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const auth = admin.auth();

async function seedStaffDragon() {
  const lotId = 'lot_cc_dragon';
  const now = admin.firestore.Timestamp.now();

  const staffAccounts = [
    {
      email: 'staff_dragon1@parkinglink.com',
      password: 'Dragon2026!',
      name: 'Staff Dragon 1',
    },
    {
      email: 'staff_dragon2@parkinglink.com',
      password: 'Dragon2026!',
      name: 'Staff Dragon 2',
    },
  ];

  for (const staff of staffAccounts) {
    try {
      // Tao Auth account
      let userRecord;
      try {
        userRecord = await auth.createUser({
          email: staff.email,
          password: staff.password,
          displayName: staff.name,
        });
        console.log(`Auth created: ${staff.email}`);
      } catch (err) {
        if (err.code === 'auth/email-already-exists') {
          userRecord = await auth.getUserByEmail(staff.email);
          console.log(`Auth exists: ${staff.email}`);
        } else {
          throw err;
        }
      }

      // Tao staff_profiles document
      await db.collection('staff_profiles').doc(userRecord.uid).set({
        uid: userRecord.uid,
        email: staff.email,
        name: staff.name,
        role: 'staff',
        lotId: lotId,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      });
      console.log(`Profile created: ${staff.name}`);
    } catch (err) {
      console.error(`Error for ${staff.email}:`, err.message);
    }
  }

  console.log('Staff Dragon setup complete!');
  process.exit(0);
}

seedStaffDragon().catch((err) => {
  console.error('Fatal:', err);
  process.exit(1);
});

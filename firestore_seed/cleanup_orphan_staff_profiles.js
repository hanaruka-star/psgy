const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const APPLY = process.argv.includes('--apply');
const BATCH_LIMIT = 500;

function line() {
  console.log('-'.repeat(70));
}

async function run() {
  console.log(
    `MODE: ${APPLY ? '🛠  APPLY (--apply, WILL DELETE)' : '🔍 DRY RUN (no writes)'}`
  );
  console.log('Scope: Firestore staff_profiles only (NOT Firebase Auth users)');
  line();

  const lotsSnap = await db.collection('parking_lots').get();
  const lotIds = new Set(lotsSnap.docs.map((d) => d.id));
  console.log(`parking_lots in project: ${lotIds.size}`);

  const profilesSnap = await db.collection('staff_profiles').get();
  const orphans = profilesSnap.docs.filter((d) => {
    const lotId = d.data().lotId;
    return lotId && !lotIds.has(lotId);
  });

  console.log(`staff_profiles total: ${profilesSnap.size}`);
  console.log(`orphan profiles (lotId set but lot missing): ${orphans.length}`);
  line();

  if (orphans.length === 0) {
    console.log('Nothing to delete.');
    process.exit(0);
  }

  console.log('Orphans:');
  for (const doc of orphans) {
    const data = doc.data();
    console.log(
      `  - uid=${doc.id} email=${data.email ?? '(no email)'} role=${data.role ?? '?'} lotId=${data.lotId}`
    );
  }
  line();

  if (!APPLY) {
    console.log('DRY RUN — pass --apply to delete these Firestore documents.');
    console.log('Firebase Auth accounts are NOT modified by this script.');
    process.exit(0);
  }

  let deleted = 0;
  for (let i = 0; i < orphans.length; i += BATCH_LIMIT) {
    const chunk = orphans.slice(i, i + BATCH_LIMIT);
    const batch = db.batch();
    for (const doc of chunk) {
      batch.delete(doc.ref);
    }
    await batch.commit();
    deleted += chunk.length;
    console.log(`Batch committed: ${chunk.length} deletes`);
  }

  line();
  console.log(`✅ Deleted ${deleted} orphan staff_profiles document(s).`);
  process.exit(0);
}

run().catch((err) => {
  console.error('Fatal:', err.message);
  process.exit(1);
});

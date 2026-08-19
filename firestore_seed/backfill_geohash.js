const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');
const ngeohash = require('ngeohash');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function backfillGeohash() {
  const snapshot = await db.collection('surveying_lots').get();

  let updated = 0;
  let skipped = 0;
  const batch = db.batch();

  for (const doc of snapshot.docs) {
    const data = doc.data();

    // Skip nếu đã có geohash
    if (data.geohash) {
      skipped++;
      continue;
    }

    // Skip nếu không có lat/lng
    if (!data.lat || !data.lng) {
      console.log(`⚠️ Skip ${doc.id}: no lat/lng`);
      continue;
    }

    const geohash = ngeohash.encode(data.lat, data.lng, 7);

    batch.update(doc.ref, {
      geohash: geohash,
    });
    updated++;

    console.log(`✅ ${doc.id}: ${data.lat},${data.lng} → ${geohash}`);
  }

  if (updated > 0) {
    await batch.commit();
    console.log(`\n🎉 Updated: ${updated}`);
  }
  console.log(`⏭️ Skipped: ${skipped}`);
  process.exit(0);
}

backfillGeohash().catch((err) => {
  console.error('❌', err);
  process.exit(1);
});

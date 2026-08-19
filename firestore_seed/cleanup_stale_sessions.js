const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

const APPLY = process.argv.includes('--apply');
const LOT_ID = 'lot_cc_dragon';
const STALE_HOURS = 24;

function line() {
  console.log('-'.repeat(70));
}

function tsToIso(ts) {
  if (ts && typeof ts._seconds === 'number') {
    return new Date(ts._seconds * 1000).toISOString();
  }
  if (ts && typeof ts.toDate === 'function') return ts.toDate().toISOString();
  return String(ts);
}

async function run() {
  console.log(
    `MODE: ${APPLY ? '🛠  APPLY (--apply, WILL WRITE)' : '🔍 AUDIT (dry-run, NO writes)'}`
  );
  const cutoffMs = Date.now() - STALE_HOURS * 60 * 60 * 1000;
  const cutoff = admin.firestore.Timestamp.fromMillis(cutoffMs);
  console.log(`Lot       : ${LOT_ID}`);
  console.log(`Stale rule: status == 'active' AND checkedInAt < ${new Date(cutoffMs).toISOString()} (now - ${STALE_HOURS}h)`);
  line();

  // Query active sessions for the lot. checkedInAt range filter applied client-side
  // to avoid composite-index requirement / missing-field edge cases.
  const snap = await db
    .collection('parking_sessions')
    .where('lotId', '==', LOT_ID)
    .where('status', '==', 'active')
    .get();

  const stale = [];
  for (const doc of snap.docs) {
    const d = doc.data();
    const ci = d.checkedInAt;
    const ciMs =
      ci && typeof ci._seconds === 'number'
        ? ci._seconds * 1000
        : ci && typeof ci.toMillis === 'function'
        ? ci.toMillis()
        : null;
    if (ciMs === null) {
      console.log(`  ⚠️  ${doc.id} has no usable checkedInAt -> SKIPPED`);
      continue;
    }
    if (ciMs < cutoffMs) {
      stale.push({ doc, data: d });
    }
  }

  console.log(`Active sessions @ lot: ${snap.size} | stale (> ${STALE_HOURS}h): ${stale.length}`);
  line();

  for (const { doc, data } of stale) {
    console.log(`STALE -> ${doc.id}`);
    console.log(`   vehicleType = ${JSON.stringify(data.vehicleType)}`);
    console.log(`   plate       = ${JSON.stringify(data.vehiclePlate)}`);
    console.log(`   checkedInAt = ${tsToIso(data.checkedInAt)}`);
  }
  line();

  let cleaned = 0;

  if (APPLY) {
    for (const { doc, data } of stale) {
      const vehicleType = data.vehicleType;
      const sessionRef = doc.ref;
      const vtRef = db
        .collection('parking_lots')
        .doc(LOT_ID)
        .collection('vehicle_types')
        .doc(vehicleType);

      console.log(`✍️  CLEANING ${doc.id} (vt=${vehicleType}) ...`);
      try {
        await db.runTransaction(async (tx) => {
          const vtSnap = await tx.get(vtRef);
          if (!vtSnap.exists) {
            throw new Error(`vehicle_type "${vehicleType}" not found`);
          }
          const vt = vtSnap.data();
          const available = Number(vt.availableSlots) || 0;
          const total = Number(vt.totalSlots) || 0;
          const nextAvailable = Math.min(available + 1, total);

          tx.update(sessionRef, {
            status: 'completed',
            checkedOutAt: FieldValue.serverTimestamp(),
            checkOutStaffId: 'system_cleanup',
            'metadata.cleanup_reason': 'stale_test_data',
            'metadata.cleaned_at': FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
          });

          tx.update(vtRef, {
            availableSlots: nextAvailable,
            updatedAt: FieldValue.serverTimestamp(),
          });

          console.log(`    ${vehicleType}: availableSlots ${available} -> ${nextAvailable} (total ${total})`);
        });
        cleaned += 1;
        console.log(`    ✅ done`);
      } catch (e) {
        console.log(`    ❌ failed: ${e.message}`);
      }
    }
    line();
  }

  // Final slots
  console.log('Final available slots per vehicle type:');
  const vt = await db.collection('parking_lots').doc(LOT_ID).collection('vehicle_types').get();
  vt.forEach((d) => {
    const x = d.data();
    console.log(`   ${d.id}: available=${x.availableSlots}/${x.totalSlots}`);
  });
  line();

  console.log('SUMMARY');
  console.log(`  Total stale sessions found : ${stale.length}`);
  console.log(`  Total cleaned              : ${APPLY ? cleaned : 0}${APPLY ? '' : '  (dry-run, run with --apply to write)'}`);
  line();

  process.exit(0);
}

run().catch((err) => {
  console.error('Fatal:', err.message);
  process.exit(1);
});

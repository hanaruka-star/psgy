const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const APPLY = process.argv.includes('--apply');

// Collections to scan. `null` fields => scan ALL string fields of the doc.
const TARGETS = [
  { collection: 'staff_profiles', fields: null },
  { collection: 'user_vehicles', fields: null },
  { collection: 'users', fields: ['displayName', 'phoneNumber'] },
  { collection: 'parking_lots', fields: ['name', 'status'] },
];

function isDirtyString(value) {
  if (typeof value !== 'string') return false;
  return /[\n\r]/.test(value) || value !== value.trim();
}

function cleanString(value) {
  // Remove CR/LF anywhere, then trim leading/trailing whitespace.
  return value.replace(/[\n\r]/g, '').trim();
}

function line() {
  console.log('-'.repeat(70));
}

async function run() {
  console.log(
    `MODE: ${APPLY ? '🛠  FIX (--apply, WILL WRITE)' : '🔍 AUDIT (dry-run, NO writes)'}`
  );
  console.log('Checks: contains \\n / \\r OR has leading/trailing whitespace');
  line();

  let dirtyCount = 0;
  let updateCount = 0;

  for (const target of TARGETS) {
    const { collection, fields } = target;
    let snap;
    try {
      snap = await db.collection(collection).get();
    } catch (err) {
      console.log(`❌ Error reading collection "${collection}": ${err.message}`);
      line();
      continue;
    }

    console.log(`Collection: ${collection}  (docs: ${snap.size})`);

    for (const doc of snap.docs) {
      const data = doc.data();
      const fieldNames =
        fields === null ? Object.keys(data) : fields;

      const updatePayload = {};

      for (const fieldName of fieldNames) {
        const value = data[fieldName];
        if (!isDirtyString(value)) continue;

        const cleaned = cleanString(value);
        dirtyCount += 1;

        console.log('');
        console.log(`  DIRTY → ${collection}/${doc.id}/${fieldName}`);
        console.log(`    raw     = ${JSON.stringify(value)}`);
        console.log(`    cleaned = ${JSON.stringify(cleaned)}`);

        updatePayload[fieldName] = cleaned;
      }

      if (APPLY && Object.keys(updatePayload).length > 0) {
        const keys = Object.keys(updatePayload);
        console.log(
          `    ✍️  WRITING ${collection}/${doc.id} fields: [${keys.join(', ')}]`
        );
        try {
          await doc.ref.update(updatePayload);
          updateCount += keys.length;
          console.log(`    ✅ updated ${keys.length} field(s)`);
        } catch (err) {
          console.log(`    ❌ update failed: ${err.message}`);
        }
      }
    }
    line();
  }

  console.log('SUMMARY');
  console.log(`  Total dirty fields found : ${dirtyCount}`);
  console.log(
    `  Total fields updated     : ${APPLY ? updateCount : 0}${
      APPLY ? '' : '  (dry-run, run with --apply to write)'
    }`
  );
  line();

  process.exit(0);
}

run().catch((err) => {
  console.error('Fatal:', err);
  process.exit(1);
});

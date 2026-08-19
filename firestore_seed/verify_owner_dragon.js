const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const auth = admin.auth();

const OWNER_EMAIL = 'owner_dragon@parkinglink.com';
const LOT_ID = 'lot_cc_dragon';

function line() {
  console.log('-'.repeat(60));
}

async function verify() {
  console.log('READ-ONLY verify for owner_dragon (no writes)');
  line();

  // 1. UID auth thật của owner_dragon@parkinglink.com
  let ownerUid = null;
  try {
    const userRecord = await auth.getUserByEmail(OWNER_EMAIL);
    ownerUid = userRecord.uid;
    console.log(`1. Auth UID of ${OWNER_EMAIL}:`);
    console.log(`   uid       = ${ownerUid}`);
    console.log(`   disabled  = ${userRecord.disabled}`);
    console.log(`   claims    = ${JSON.stringify(userRecord.customClaims || {})}`);
  } catch (err) {
    console.log(`1. ❌ Could not load auth user "${OWNER_EMAIL}": ${err.message}`);
    line();
    console.log('Aborting: no auth uid to continue.');
    process.exit(1);
  }
  line();

  // 2. staff_profiles/{ownerUid}: role, isActive, lotId
  let profileLotId = null;
  let profileExists = false;
  try {
    const profileSnap = await db.collection('staff_profiles').doc(ownerUid).get();
    profileExists = profileSnap.exists;
    console.log(`2. staff_profiles/${ownerUid}:`);
    if (profileExists) {
      const p = profileSnap.data();
      profileLotId = p.lotId ?? null;
      console.log(`   exists    = true`);
      console.log(`   role      = ${JSON.stringify(p.role)}`);
      console.log(`   isActive  = ${JSON.stringify(p.isActive)}`);
      console.log(`   lotId     = ${JSON.stringify(p.lotId)}`);
      console.log(`   uid field = ${JSON.stringify(p.uid)}`);
    } else {
      console.log(`   exists    = ❌ false (NO PROFILE DOC FOR THIS UID)`);
    }
  } catch (err) {
    console.log(`2. ❌ Error reading staff_profiles/${ownerUid}: ${err.message}`);
  }
  line();

  // 3. parking_lots/lot_cc_dragon: ownerId, status/isActive
  let lotOwnerId = null;
  let lotExists = false;
  try {
    const lotSnap = await db.collection('parking_lots').doc(LOT_ID).get();
    lotExists = lotSnap.exists;
    console.log(`3. parking_lots/${LOT_ID}:`);
    if (lotExists) {
      const l = lotSnap.data();
      lotOwnerId = l.ownerId ?? null;
      console.log(`   exists    = true`);
      console.log(`   ownerId   = ${JSON.stringify(l.ownerId)}`);
      console.log(`   status    = ${JSON.stringify(l.status)}`);
      console.log(`   isActive  = ${JSON.stringify(l.isActive)}`);
      console.log(`   name      = ${JSON.stringify(l.name)}`);
    } else {
      console.log(`   exists    = ❌ false (LOT DOC DOES NOT EXIST)`);
    }
  } catch (err) {
    console.log(`3. ❌ Error reading parking_lots/${LOT_ID}: ${err.message}`);
  }
  line();

  // 4. So sánh
  console.log('4. Comparisons (what the security rule requires):');

  // Check A: lot must exist (rule: exists(lotPath(lotId)))
  if (lotExists) {
    console.log(`   [A] parking_lots/${LOT_ID} exists        → ✅`);
  } else {
    console.log(`   [A] parking_lots/${LOT_ID} exists        → ❌ MISMATCH (lot missing)`);
  }

  // Check B: ownerUid_auth == parking_lots.ownerId
  if (lotExists && lotOwnerId === ownerUid) {
    console.log(`   [B] auth uid == lot.ownerId               → ✅ MATCH`);
  } else {
    console.log(`   [B] auth uid == lot.ownerId               → ❌ MISMATCH`);
    console.log(`        auth uid      = ${ownerUid}`);
    console.log(`        lot.ownerId   = ${lotOwnerId}`);
  }

  // Check C: staff_profiles.lotId == 'lot_cc_dragon'
  if (profileExists && profileLotId === LOT_ID) {
    console.log(`   [C] profile.lotId == '${LOT_ID}'      → ✅ MATCH`);
  } else {
    console.log(`   [C] profile.lotId == '${LOT_ID}'      → ❌ MISMATCH`);
    console.log(`        profile.lotId = ${profileLotId}`);
  }

  // Rule verdict: isOwnerOfLot passes if (B) OR (C), AND (A) must hold.
  const isOwnerOfLot =
    lotExists && (lotOwnerId === ownerUid || profileLotId === LOT_ID);
  line();
  console.log('VERDICT (owner-create-staff for lotId=lot_cc_dragon):');
  console.log(`   exists(lot)        = ${lotExists ? '✅' : '❌'}`);
  console.log(`   isOwnerOfLot       = ${isOwnerOfLot ? '✅' : '❌'}`);
  if (lotExists && isOwnerOfLot) {
    console.log('   → Rule data conditions SATISFIED. If create still fails,');
    console.log('     suspect role/isActive of owner profile, or form lotId differs.');
  } else {
    console.log('   → Rule data conditions NOT satisfied. This explains permission-denied.');
  }
  line();

  process.exit(0);
}

verify().catch((err) => {
  console.error('Fatal:', err);
  process.exit(1);
});

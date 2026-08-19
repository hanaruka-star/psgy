const { JWT } = require('google-auth-library');
const serviceAccount = require('./serviceAccountKey.json');

const PROJECT = 'parkinglink-v2';

async function main() {
  const client = new JWT({
    email: serviceAccount.client_email,
    key: serviceAccount.private_key,
    scopes: ['https://www.googleapis.com/auth/cloud-platform'],
  });

  // 1. Find the ruleset currently released for cloud.firestore
  const releaseUrl = `https://firebaserules.googleapis.com/v1/projects/${PROJECT}/releases/cloud.firestore`;
  const release = await client.request({ url: releaseUrl });
  const rulesetName = release.data.rulesetName;
  console.log('LIVE release -> rulesetName:', rulesetName);
  console.log('createTime:', release.data.createTime, '| updateTime:', release.data.updateTime);
  console.log('-'.repeat(70));

  // 2. Fetch the ruleset source
  const rulesetUrl = `https://firebaserules.googleapis.com/v1/${rulesetName}`;
  const ruleset = await client.request({ url: rulesetUrl });
  const files = ruleset.data.source.files;

  for (const f of files) {
    const src = f.content;
    console.log(`FILE: ${f.name}  (length ${src.length})`);
    console.log('-'.repeat(70));

    const checks = [
      'validStaffProfileCreate',
      'isOwnerOfLot',
      'function isOwner()',
      "role == 'owner'",
      'isOwner() && validStaffProfileCreate',
    ];
    console.log('Presence checks in LIVE source:');
    for (const c of checks) {
      console.log(`  ${src.includes(c) ? '✅' : '❌'}  ${c}`);
    }
    console.log('-'.repeat(70));

    // Print the staff_profiles create block for eyeballing
    const idx = src.indexOf('match /staff_profiles');
    if (idx >= 0) {
      console.log('LIVE staff_profiles block (excerpt):');
      console.log(src.substring(idx, idx + 900));
    } else {
      console.log('❌ No "match /staff_profiles" found in LIVE source.');
    }
  }
  process.exit(0);
}

main().catch((err) => {
  console.error('Fatal:', err.response ? JSON.stringify(err.response.data) : err.message);
  process.exit(1);
});

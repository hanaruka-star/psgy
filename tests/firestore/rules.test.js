/**
 * PSgy Firestore rules — default deny-all stub.
 *
 * Run:
 *   firebase emulators:exec --only firestore --project psgy-app \
 *     "cd tests/firestore && npm install && npm test"
 */
const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertFails,
} = require('@firebase/rules-unit-testing');

const PROJECT_ID = 'psgy-app';
const RULES = fs.readFileSync(
  path.resolve(__dirname, '../../firestore.rules'),
  'utf8',
);

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: { rules: RULES },
  });
});

after(async () => {
  if (testEnv) await testEnv.cleanup();
});

afterEach(async () => {
  await testEnv.clearFirestore();
});

describe('default deny', () => {
  it('rejects unauthenticated reads', async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(db.doc('anything/x').get());
  });

  it('rejects authenticated writes until backend adds collection rules', async () => {
    const db = testEnv.authenticatedContext('uid-1').firestore();
    await assertFails(db.doc('users/uid-1').set({ phone: '+84000000000' }));
  });
});

# PSgy — Firestore Security Rules

**Golden Rule:** file local `firestore.rules` là nguồn thật. Không sửa rules trên Firebase Console.

```bash
./scripts/deploy_firestore_rules.sh
# FIREBASE_PROJECT=psgy-app by default
```

Verify: [Firebase Console → psgy-app → Firestore → Rules](https://console.firebase.google.com/project/psgy-app/firestore/rules).

Emulator:

```bash
firebase emulators:start --only firestore --project psgy-app
firebase emulators:exec --only firestore --project psgy-app \
  "cd tests/firestore && npm test"
```

Hiện tại rules là **deny-all** (stub). Đội backend thêm collection gym/coach/booking theo `docs/handoff/`.

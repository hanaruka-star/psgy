# ParkingLink — Firestore Security Rules (CP25)

Production rules live in [`firestore.rules`](../../firestore.rules).

## Deploy

```bash
# From repo root
./scripts/deploy_firestore_rules.sh

# Or manually
firebase deploy --only firestore:rules --project parkinglink-v2
```

Verify in [Firebase Console → Firestore → Rules](https://console.firebase.google.com/project/parkinglink-v2/firestore/rules).

## Emulator

Requires **Java (JRE 11+)** for the Firestore emulator.

```bash
# Start Firestore emulator only
firebase emulators:start --only firestore --project parkinglink-v2

# Run rules unit tests (requires Node.js + Java)
cd tests/firestore && npm install && npm test

# One-shot: emulator + tests
firebase emulators:exec --only firestore --project parkinglink-v2 \
  "cd tests/firestore && npm install && npm test"
```

If `java -version` fails, install a JRE (Android Studio JBR works on macOS).

## Role permission matrix

### Anonymous / User app (no `staff_profiles`)

| Collection | Read | Write |
|---|---|---|
| `parking_lots` | ✅ Public | ❌ |
| `parking_lots/{id}/vehicle_types` | ✅ Public (availability + price) | ❌ |
| `surveying_lots` | ✅ Public | ❌ |
| `parking_lots/{id}/slots` | ❌ | ❌ |
| `parking_sessions` | ❌ | ❌ |
| `staff_profiles` | ❌ | ❌ |
| `manual_adjustments` | ❌ | ❌ |
| `pricing_history` | ❌ | ❌ |
| `bookings` | ❌ (own only when signed in) | ❌ |

User app map works **without authentication**. Vehicle type subcollection is public read so lot detail cards show slot counts.

### Staff (`staff_profiles.role == 'staff'`, `isActive == true`, assigned `lotId`)

| Resource | Read | Write |
|---|---|---|
| Own `staff_profiles/{uid}` | ✅ | ❌ |
| Assigned `parking_lots/{lotId}` | ✅ (via parent public read) | ❌ |
| `vehicle_types` | ✅ | ✅ `availableSlots ±1` only (check-in/out/manual adjust) |
| `slots` | ✅ | ✅ occupancy fields only |
| `parking_sessions` | ✅ (assigned lot) | ✅ create check-in, update check-out |
| `manual_adjustments` | ✅ | ✅ create only |
| Other lots | ❌ | ❌ |
| `surveying_lots` | ✅ | ❌ |
| `staff_profiles` (others) | ❌ | ❌ |
| `pricing_history` | ✅ (assigned lot) | ❌ |
| `owner_private` | ❌ | ❌ |

Business rules enforced in rules:

- Check-in blocked if `availableSlots <= 0`
- Check-in/out only when lot `status == 'open'`
- Session checkout only from `active` → `completed`
- Staff cannot change pricing, total slots, or lot ownership

### Owner (`staff_profiles.role == 'owner'`, `isActive == true`)

| Resource | Read | Write |
|---|---|---|
| `staff_profiles` in own lot | ✅ list/get | ✅ create staff, toggle `isActive` |
| `parking_lots/{lotId}` | ✅ | ✅ `status` only |
| `vehicle_types` | ✅ | ✅ pricing, totals, availability |
| `slots` | ✅ | ✅ full CRUD |
| `parking_sessions` | ✅ | ❌ (staff operations) |
| `manual_adjustments` | ✅ | ❌ |
| `pricing_history` | ✅ | ✅ create audit entries |
| `owner_private` | ✅ | ✅ revenue / sensitive data |
| `surveying_lots` | ✅ | ❌ (Monitor pipeline) |

Owner bootstrap: first owner profile may be created when `parking_lots/{lotId}.ownerId == auth.uid`, or via **Admin SDK** / `admin` custom claim (recommended for production).

### Admin / Monitor (Admin SDK, Cloud Functions)

| Resource | Access |
|---|---|
| `surveying_lots` | Full write (bypasses rules) |
| `parking_lots` create | Provisioning |
| All collections | Full access via Admin SDK |

## Rate limiting

Path: `_security/rate_limits/{uid}/buckets/{minuteBucket}`

- Max **30 writes/minute** per authenticated user (configurable in rules)
- Rules check `withinWriteRateLimit()` on all client writes
- **Recommended:** bump counter in the same Firestore transaction as check-in/out (future client update)

## Sensitive data

- Revenue / payroll → `parking_lots/{lotId}/owner_private/` (owner-only)
- Staff salaries → not in client schema; keep in owner_private or Admin-only collections
- `pricing_history` → owner/staff read, owner create only

## Multi-app notes

- **User app** (`com.parkinglink.user`): unauthenticated map reads + optional future bookings
- **Staff app** (`com.parkinglink.staff`): authenticated staff/owner via Firebase Auth + `staff_profiles`

Both apps share one Firebase project; authorization is **role-based**, not app-based.

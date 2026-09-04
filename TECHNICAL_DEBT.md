# PSgy — Technical Debt

ParkingLink-era debts for surveying lots / staff QR no longer apply.

Still relevant:
- DEBT-009: FCM/APNs delay on dev builds
- UserProfileNotifier reads Firestore `users/{uid}` — permission-denied until backend rules + profile flow exist (handoff B7). Do not re-enable User `PhoneAuthScreen` until that is cleaned.

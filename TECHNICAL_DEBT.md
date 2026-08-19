# ParkingLink — Technical Debt Registry
_Last updated: 26/05/2026 (DEBT-009)_

## High Priority

## Medium Priority

- **DEBT-012 — Rate limiting removed from Firestore rules; needs server-side implementation**  
  Client-side `withinWriteRateLimit()` was removed from staff/owner hot paths (`parking_sessions` create, `vehicle_types` update, `slots` update, `manual_adjustments` create, `staff_profiles` toggle update). Long-term rate limiting should be enforced server-side (Cloud Functions / App Check + backend), not via rules that depend on client-written `_rate_limits` docs.

- **DEBT-008 — Isar migration is manual/version-constant based**  
  Schema migration is managed via a hardcoded version and ad-hoc clearing logic.
- **DEBT-009 — FCM / APNs on dev vs production**  
  FCM works on production builds; dev builds may have APNs delay (`getAPNSToken()` null until retries exhaust).  
  `FcmNotificationService` now retries 5× with 3s delay and logs a light warning without blocking startup.  
  Remaining gap: no token-state telemetry dashboard / alerting and no server-side APNs lifecycle diagnostics.

## Low Priority

## Resolved

- **R-011 (was DEBT-006) — Staff history is now realtime stream with pagination**  
  History now merges realtime `parking_sessions` + `manual_adjustments`, and supports `Load more` pagination using `startAfter` cursors.
- **R-010 (was DEBT-004) — Slot updates are clamped in checkout/manual adjust**  
  `checkOut` now clamps `availableSlots` with `min(current + 1, totalSlots)`, and `manualAdjust` clamps with `min/max`, preventing underflow/overflow drift.
- **R-007 (was DEBT-002) — Plate validation strengthened in Staff check-in**  
  Plate input is normalized (trim + uppercase), validated with `^[A-Z0-9\-]{6,12}$`, and non-standard formats now show warning while still allowing submission.
- **R-008 (was DEBT-005) — Manual adjust now validates against live vehicle-type snapshot**  
  `ManualAdjustScreen` now watches realtime vehicle-type data via provider and validates boundaries with current `availableSlots` / `totalSlots`.
- **R-009 (was DEBT-010) — Legacy staff dashboard removed**  
  Removed obsolete `staff_dashboard.dart` duplicate to avoid class/import ambiguity with `staff_dashboard_screen.dart`.
- **R-004 (was DEBT-001) — Staff role guard enforced in DI**  
  `staffProfileProvider` now allows only `staff` / `owner`; invalid roles throw `Unauthorized: invalid role for staff app`.
- **R-005 (was DEBT-003) — Duplicate active session check added for check-in**  
  `checkIn` transaction now checks active `parking_sessions` by `lotId + vehiclePlate + status` before creating a new session.
- **R-006 (was DEBT-011) — Debug menu opening path stabilized via root navigator key**  
  Debug menu now opens directly from root navigator (Splash long-press, map logo long-press, and debug FAB), avoiding context-above-navigator failures.
- **R-001 — Check-in/out transaction atomicity implemented**  
  Slot update + session mutation now run inside Firestore transactions (no longer tracked as debt).
- **R-002 — Surveying lot cache schema sync fixes completed**  
  Surveying Isar schema expansion and sticky-cache stabilization are already implemented.
- **R-003 — Surveying lot crash-on-image handling fixed**  
  Viewer path now has null/empty/error guard and user-safe fallback dialogs.

- **R-012 (was DEBT-007) — Surveying lots now use geohash range query**  
  `UserSurveyingDataSource.watchGeohashNearbyLots` now queries `surveying_lots` via geohash range (`status` + `geohash` composite index), with client-side distance filter remaining available through `watchClientSideNearbyLots`.

---

Notes:
- This registry is based on current repository audit state and CP-E pre-audit.
- `DEBT-XXX` inline comments are added at relevant code locations for traceability.
- Cloud Function merge: intentionally removed; manual process is preferred for high-density areas.

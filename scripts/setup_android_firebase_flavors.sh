#!/usr/bin/env bash
# Regenerate flavor-specific google-services.json from Firebase (requires: firebase login)
set -euo pipefail

PROJECT_ID="${FIREBASE_PROJECT_ID:-parkinglink-v2}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> ParkingLink Android Firebase flavor setup (project: ${PROJECT_ID})"

firebase apps:list --project "${PROJECT_ID}" ANDROID

USER_APP_ID="$(firebase apps:list --project "${PROJECT_ID}" ANDROID --json | python3 -c "
import json,sys
data=json.load(sys.stdin)
for app in data.get('result',[]):
  if app.get('namespace')=='com.parkinglink.user':
    print(app['appId']); break
" 2>/dev/null || true)"

STAFF_APP_ID="$(firebase apps:list --project "${PROJECT_ID}" ANDROID --json | python3 -c "
import json,sys
data=json.load(sys.stdin)
for app in data.get('result',[]):
  if app.get('namespace')=='com.parkinglink.staff':
    print(app['appId']); break
" 2>/dev/null || true)"

if [[ -z "${USER_APP_ID}" || -z "${STAFF_APP_ID}" ]]; then
  echo "Creating Android apps if missing..."
  firebase apps:create ANDROID "ParkingLink User" \
    --package-name=com.parkinglink.user --project="${PROJECT_ID}" || true
  firebase apps:create ANDROID "ParkingLink Staff" \
    --package-name=com.parkinglink.staff --project="${PROJECT_ID}" || true
fi

mkdir -p "${ROOT_DIR}/android/app/src/user" "${ROOT_DIR}/android/app/src/staff"

firebase apps:sdkconfig ANDROID com.parkinglink.user \
  --project "${PROJECT_ID}" \
  --out "${ROOT_DIR}/android/app/src/user/google-services.json"

firebase apps:sdkconfig ANDROID com.parkinglink.staff \
  --project "${PROJECT_ID}" \
  --out "${ROOT_DIR}/android/app/src/staff/google-services.json"

echo "✓ Wrote android/app/src/user/google-services.json"
echo "✓ Wrote android/app/src/staff/google-services.json"
echo "Re-run: flutter build apk --flavor user --dart-define=FLAVOR=user"

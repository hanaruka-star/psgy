#!/usr/bin/env bash
# Regenerate flavor-specific google-services.json from Firebase (requires: firebase login)
set -euo pipefail

PROJECT_ID="${FIREBASE_PROJECT_ID:-psgy-app}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> PSgy Android Firebase flavor setup (project: ${PROJECT_ID})"

firebase apps:list --project "${PROJECT_ID}" ANDROID

mkdir -p "${ROOT_DIR}/android/app/src/user" "${ROOT_DIR}/android/app/src/coach"

firebase apps:sdkconfig ANDROID com.psgy.user \
  --project "${PROJECT_ID}" \
  --out "${ROOT_DIR}/android/app/src/user/google-services.json"

firebase apps:sdkconfig ANDROID com.psgy.coach \
  --project "${PROJECT_ID}" \
  --out "${ROOT_DIR}/android/app/src/coach/google-services.json"

echo "✓ Wrote android/app/src/user/google-services.json"
echo "✓ Wrote android/app/src/coach/google-services.json"
echo "Re-run: flutter build apk --flavor user --dart-define=FLAVOR=user"

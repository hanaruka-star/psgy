#!/usr/bin/env bash
# Build production Android AAB (+ optional APK) for User and Coach flavors.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

FLUTTER_DEFINES=(
  "--dart-define=ENV=production"
)

if [[ ! -f android/key.properties ]]; then
  echo "Missing android/key.properties — run: ./scripts/create_android_release_keystore.sh --dev"
  exit 1
fi

echo "==> Building User AAB"
flutter build appbundle \
  --flavor user \
  --release \
  --dart-define=FLAVOR=user \
  "${FLUTTER_DEFINES[@]}"

echo "==> Building Coach AAB"
flutter build appbundle \
  --flavor coach \
  --release \
  --dart-define=FLAVOR=coach \
  "${FLUTTER_DEFINES[@]}"

echo ""
echo "✓ User AAB:  build/app/outputs/bundle/userRelease/app-user-release.aab"
echo "✓ Coach AAB: build/app/outputs/bundle/coachRelease/app-coach-release.aab"
echo ""
ls -lh build/app/outputs/bundle/userRelease/*.aab build/app/outputs/bundle/coachRelease/*.aab 2>/dev/null || true

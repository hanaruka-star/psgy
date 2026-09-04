#!/usr/bin/env bash
# Build all production mobile artifacts: Android APK + AAB (user & coach).
# iOS: run ./scripts/build_production_ios.sh [user|coach] separately (requires Xcode signing).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

DEFINES=(--dart-define=ENV=production)

if [[ ! -f android/key.properties ]]; then
  echo "Missing android/key.properties"
  echo "Run: ./scripts/create_android_release_keystore.sh --dev   # local"
  echo "  or ./scripts/create_android_release_keystore.sh         # production keystore"
  exit 1
fi

build_android_flavor() {
  local flavor="$1"
  local flavor_upper
  flavor_upper="$(tr '[:lower:]' '[:upper:]' <<< "${flavor:0:1}")${flavor:1}"

  echo ""
  echo "==> Android ${flavor_upper}: APK"
  flutter build apk \
    --flavor "${flavor}" \
    --release \
    --dart-define=FLAVOR="${flavor}" \
    "${DEFINES[@]}"

  echo "==> Android ${flavor_upper}: AAB (Play Store)"
  flutter build appbundle \
    --flavor "${flavor}" \
    --release \
    --dart-define=FLAVOR="${flavor}" \
    "${DEFINES[@]}"
}

echo "PSgy — Mobile Production Build (Android)"
build_android_flavor user
build_android_flavor coach

echo ""
echo "=== Android artifacts ==="
ls -lh build/app/outputs/flutter-apk/app-user-release.apk 2>/dev/null || true
ls -lh build/app/outputs/flutter-apk/app-coach-release.apk 2>/dev/null || true
ls -lh build/app/outputs/bundle/userRelease/app-user-release.aab 2>/dev/null || true
ls -lh build/app/outputs/bundle/coachRelease/app-coach-release.aab 2>/dev/null || true

echo ""
echo "iOS TestFlight: ./scripts/build_production_ios.sh user"
echo "                ./scripts/build_production_ios.sh coach"
echo "Checks:         ./scripts/final_release_checks.sh"

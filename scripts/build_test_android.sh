#!/usr/bin/env bash
# Build PSgy APK for real Android device testing (User / Coach, debug or profile).
#
# Usage:
#   ./scripts/build_test_android.sh [user|coach|both] [debug|profile]
#
# Install:
#   flutter install --flavor user -d <DEVICE_ID>
#   adb install -r build/app/outputs/flutter-apk/app-user-debug.apk
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

FLAVOR="${1:-user}"
MODE="${2:-debug}"

if [[ "${FLAVOR}" != "user" && "${FLAVOR}" != "coach" && "${FLAVOR}" != "both" ]]; then
  echo "Usage: $0 [user|coach|both] [debug|profile]"
  exit 1
fi

if [[ "${MODE}" != "debug" && "${MODE}" != "profile" ]]; then
  echo "Mode must be debug or profile"
  exit 1
fi

build_flavor() {
  local flavor="$1"

  echo ""
  echo "==> Building Android ${flavor} (${MODE}) APK"
  echo "    ENV=development  FLAVOR=${flavor}"

  local env_define="development"
  if [[ "${MODE}" == "profile" ]]; then
    env_define="staging"
  fi

  flutter build apk \
    --flavor "${flavor}" \
    --"${MODE}" \
    --dart-define=FLAVOR="${flavor}" \
    "--dart-define=ENV=${env_define}"

  local apk_suffix="${MODE}"
  if [[ "${MODE}" == "profile" ]]; then
    apk_suffix="profile"
  fi

  echo ""
  echo "✓ APK: build/app/outputs/flutter-apk/app-${flavor}-${apk_suffix}.apk"
  echo ""
  echo "Install:"
  echo "  flutter install --flavor ${flavor} -d <DEVICE_ID>"
  echo "  adb install -r build/app/outputs/flutter-apk/app-${flavor}-${apk_suffix}.apk"
}

if [[ "${FLAVOR}" == "both" ]]; then
  build_flavor user
  build_flavor coach
else
  build_flavor "${FLAVOR}"
fi

echo ""
echo "Done. Debug menu: long-press splash logo or map search bar (dev/staging builds only)."

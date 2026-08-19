#!/usr/bin/env bash
# Build production iOS for TestFlight / App Store (User or Staff).
#
# Requires: Xcode, Apple Developer account, valid signing certificates.
# See store_assets/ios/SIGNING_AND_ARCHIVE.txt
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

FLAVOR="${1:-user}"
EXPORT_METHOD="${2:-app-store}"

if [[ "${FLAVOR}" != "user" && "${FLAVOR}" != "staff" ]]; then
  echo "Usage: $0 [user|staff] [app-store|development|ad-hoc]"
  exit 1
fi

SCHEME="$(tr '[:lower:]' '[:upper:]' <<< "${FLAVOR:0:1}")${FLAVOR:1}"

echo "==> Building iOS (${FLAVOR}) export-method=${EXPORT_METHOD}"

if flutter build ipa \
  --flavor "${FLAVOR}" \
  --release \
  --dart-define=FLAVOR="${FLAVOR}" \
  --dart-define=ENV=production \
  --export-method "${EXPORT_METHOD}"; then
  echo ""
  echo "✓ IPA: build/ios/ipa/"
  ls -lh build/ios/ipa/*.ipa 2>/dev/null || true
  exit 0
fi

echo ""
echo "IPA export failed (signing). Building unsigned iOS app for verification..."
flutter build ios \
  --flavor "${FLAVOR}" \
  --release \
  --no-codesign \
  --dart-define=FLAVOR="${FLAVOR}" \
  --dart-define=ENV=production

echo ""
echo "✓ Unsigned: build/ios/iphoneos/Runner.app"
echo ""
echo "For TestFlight upload, configure signing in Xcode:"
echo "  open ios/Runner.xcworkspace"
echo "  Scheme: ${SCHEME} → Product → Archive → Distribute App"

#!/usr/bin/env bash
# Post-build release checks: artifact sizes, signing, permissions.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

echo "==> Release artifact sizes"
for f in \
  build/app/outputs/bundle/userRelease/app-user-release.aab \
  build/app/outputs/bundle/coachRelease/app-coach-release.aab \
  build/app/outputs/flutter-apk/app-user-release.apk \
  build/app/outputs/flutter-apk/app-coach-release.apk \
  "build/ios/ipa/PSgy User.ipa" \
  "build/ios/ipa/PSgy Coach.ipa"; do
  if [[ -f "${f}" ]]; then
    ls -lh "${f}"
  fi
done

echo ""
echo "==> AAB signing (User)"
if [[ -f build/app/outputs/bundle/userRelease/app-user-release.aab ]]; then
  unzip -l build/app/outputs/bundle/userRelease/app-user-release.aab | head -5 || true
  if command -v jarsigner >/dev/null 2>&1; then
    jarsigner -verify -verbose -certs build/app/outputs/bundle/userRelease/app-user-release.aab 2>&1 | tail -3 || true
  fi
fi

echo ""
echo "==> Merged Android permissions (User release manifest)"
MANIFEST="build/app/intermediates/merged_manifests/userRelease/processUserReleaseManifest/AndroidManifest.xml"
if [[ -f "${MANIFEST}" ]]; then
  grep "uses-permission" "${MANIFEST}" | sort -u || true
else
  echo "(Run flutter build appbundle first to generate merged manifest)"
fi

echo ""
echo "==> Version"
grep "^version:" pubspec.yaml

echo ""
echo "==> key.properties configured"
if [[ -f android/key.properties ]]; then
  echo "yes (gitignored)"
else
  echo "NO — run ./scripts/create_android_release_keystore.sh"
fi

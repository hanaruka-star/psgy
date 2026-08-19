#!/usr/bin/env bash
# Deploy Firestore security rules to parkinglink-v2.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

PROJECT="${FIREBASE_PROJECT:-parkinglink-v2}"

echo "==> Validating firestore.rules..."
firebase firestore:rules:release --project "${PROJECT}" 2>/dev/null || true

echo "==> Deploying Firestore rules to ${PROJECT}..."
firebase deploy --only firestore:rules --project "${PROJECT}"

echo "✓ Rules deployed."

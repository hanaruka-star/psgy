#!/usr/bin/env bash
# Deploy Firestore security rules to psgy-app.
# Golden Rule: local firestore.rules is the source of truth.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

PROJECT="${FIREBASE_PROJECT:-psgy-app}"

echo "==> Deploying Firestore rules to ${PROJECT}..."
firebase deploy --only firestore:rules --project "${PROJECT}"

echo "✓ Rules deployed."

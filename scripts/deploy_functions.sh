#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/functions"

if ! command -v firebase >/dev/null 2>&1; then
  echo "firebase CLI not found. Install: npm i -g firebase-tools"
  exit 1
fi

npm install
cd "$ROOT"
firebase deploy --only functions:notifyWatchlistOnLotOpen

echo "Deployed notifyWatchlistOnLotOpen to asia-southeast1"

#!/usr/bin/env bash
# Build / run ParkingLink on a real iPhone (User or Staff, debug or profile).
#
# Quick start (fastest — recommended for QA):
#   ./scripts/build_test_iphone.sh --run
#   ./scripts/build_test_iphone.sh user --run
#   ./scripts/build_test_iphone.sh staff --run
#
# Build + install:
#   ./scripts/build_test_iphone.sh user debug --install
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

FLAVOR="user"
MODE="debug"
ACTION="run"
DEVICE=""
SKIP_PODS=false

usage() {
  cat <<'EOF'
Usage: ./scripts/build_test_iphone.sh [user|staff|both] [debug|profile] [options]

Options:
  --run           Run on device with hot reload (default)
  --build-only    Build ios/ without installing
  --install       Build then flutter install
  --device ID     Device ID from `flutter devices`
  --skip-pods     Skip pod install
  -h, --help      Show help

Examples:
  ./scripts/build_test_iphone.sh --run
  ./scripts/build_test_iphone.sh staff --run
  ./scripts/build_test_iphone.sh user profile --install
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    user|staff|both) FLAVOR="$1" ;;
    debug|profile) MODE="$1" ;;
    --run) ACTION="run" ;;
    --build-only) ACTION="build" ;;
    --install) ACTION="install" ;;
    --skip-pods) SKIP_PODS=true ;;
    --device) DEVICE="${2:?Missing value for --device}"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1"; usage; exit 1 ;;
  esac
  shift
done

detect_ios_device() {
  if [[ -n "${DEVICE}" ]]; then
    echo "${DEVICE}"
    return
  fi
  flutter devices 2>/dev/null | awk '
    /ios •/ && !/simulator/ { print $2; exit }
  '
}

env_define="development"
[[ "${MODE}" == "profile" ]] && env_define="staging"

run_flavor() {
  local flavor="$1"
  local scheme
  scheme="$(tr '[:lower:]' '[:upper:]' <<< "${flavor:0:1}")${flavor:1}"
  local dev_id
  dev_id="$(detect_ios_device)"

  local flutter_args=(
    "--flavor" "${flavor}"
    "--${MODE}"
    "--dart-define=FLAVOR=${flavor}"
    "--dart-define=ENV=${env_define}"
  )

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo " ParkingLink iPhone QA"
  echo " Flavor: ${flavor}  Mode: ${MODE}  ENV: ${env_define}"
  echo " Scheme: ${scheme}  Action: ${ACTION}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ "${SKIP_PODS}" == false && -f ios/Podfile ]]; then
    echo "→ pod install..."
    (cd ios && pod install --silent 2>/dev/null) || (cd ios && pod install)
  fi

  case "${ACTION}" in
    run)
      if [[ -z "${dev_id}" ]]; then
        echo ""
        echo "No physical iPhone detected."
        echo "  1. Connect iPhone via USB, Trust this Mac"
        echo "  2. Settings → Privacy & Security → Developer Mode → ON"
        echo "  3. Run: flutter devices"
        exit 1
      fi
      echo "→ flutter run -d ${dev_id}"
      flutter run "${flutter_args[@]}" -d "${dev_id}"
      ;;
    build)
      echo "→ flutter build ios..."
      flutter build ios "${flutter_args[@]}"
      echo "✓ build/ios/iphoneos/Runner.app"
      echo "  Install: flutter install --flavor ${flavor} -d <DEVICE_ID>"
      ;;
    install)
      if [[ -z "${dev_id}" ]]; then
        echo "No physical iPhone detected. Run: flutter devices"
        exit 1
      fi
      flutter build ios "${flutter_args[@]}"
      flutter install --flavor "${flavor}" -d "${dev_id}"
      echo "✓ Installed ${flavor} on ${dev_id}"
      ;;
  esac

  echo ""
  echo "Debug Menu: giữ logo Splash / giữ thanh Map / tap nút 🐛 góc dưới-trái"
}

if [[ "${FLAVOR}" == "both" ]]; then
  [[ "${ACTION}" == "run" ]] && echo "Note: running User only. Re-run with staff --run for Staff."
  run_flavor user
  [[ "${ACTION}" != "run" ]] && run_flavor staff
else
  run_flavor "${FLAVOR}"
fi

#!/usr/bin/env bash
# Chạy nhanh cho demo — debug mode, hot reload sẵn sàng.
# KHÔNG build native lại nếu không thêm package mới (dùng cache Xcode/Gradle).
#
# Usage:
#   ./scripts/run_dev_fast.sh
#   ./scripts/run_dev_fast.sh user
#   ./scripts/run_dev_fast.sh coach
#   ./scripts/run_dev_fast.sh user -d 70EB1BCD-5A7C-43FF-8701-B11C06B71AB5
#
# Sau khi lên: sửa Dart → phím `r` (hot reload). Đổi DI/theme/global state → `R`.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

FLAVOR="${1:-user}"
if [[ "${FLAVOR}" != "user" && "${FLAVOR}" != "coach" ]]; then
  echo "Usage: $0 [user|coach] [extra flutter run args...]"
  exit 1
fi
shift || true

# --flavor bắt buộc với scheme iOS/Android của repo này.
exec flutter run \
  --flavor "${FLAVOR}" \
  --dart-define=FLAVOR="${FLAVOR}" \
  --dart-define=ENV=development \
  --debug \
  "$@"

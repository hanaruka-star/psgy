#!/usr/bin/env bash
# =============================================================================
# claude_runner.sh — cầu nối để Claude (Cowork) chạy test / Simulator trên Mac.
#
# Claude KHÔNG gõ được vào Terminal. Claude chỉ ghi một "yêu cầu" (1 dòng) vào
# build/claude/inbox/. Script này đối chiếu yêu cầu với DANH SÁCH CỐ ĐỊNH bên
# dưới rồi mới chạy — không bao giờ chạy lệnh tuỳ ý, không đụng tới git.
#
# Chạy:  bash scripts/claude_runner.sh        Dừng: Ctrl+C
#
# Lệnh được phép:
#   analyze                       flutter analyze
#   test [test/<đường dẫn>]       flutter test (toàn bộ, hoặc 1 file/thư mục trong test/)
#   update-goldens [test/<...>]   flutter test --update-goldens (cập nhật ảnh UI tham chiếu)
#   pub-get                       flutter pub get
#   run user|coach                build + chạy app (debug) trên iOS Simulator
#   reload | restart              hot reload / hot restart app đang chạy
#   stop                          dừng app đang chạy
#   screenshot                    chụp màn hình Simulator
#   uninstall user|coach          gỡ app khỏi Simulator (để thấy lại các màn lần đầu)
# =============================================================================
set -u
cd "$(dirname "$0")/.." || exit 1
ROOT="$(pwd)"
BASE="$ROOT/build/claude"
INBOX="$BASE/inbox"; OUT="$BASE/out"; DONE="$BASE/done"
FLUTTER_PID="$BASE/flutter_run.pid"   # do flutter run ghi (--pid-file) — dùng để hot reload
JOB_PID="$BASE/flutter_run.job"       # tiến trình nền bao quanh flutter run
mkdir -p "$INBOX" "$OUT" "$DONE"

log() { printf '[claude-runner %s] %s\n' "$(date +%H:%M:%S)" "$*"; }

app_running() { [ -f "$FLUTTER_PID" ] && kill -0 "$(cat "$FLUTTER_PID")" 2>/dev/null; }

stop_app() {
  if [ -f "$FLUTTER_PID" ]; then kill -TERM "$(cat "$FLUTTER_PID")" 2>/dev/null; fi
  sleep 2
  if [ -f "$JOB_PID" ]; then
    pkill -P "$(cat "$JOB_PID")" 2>/dev/null
    kill "$(cat "$JOB_PID")" 2>/dev/null
    rm -f "$JOB_PID"
  fi
}

UDID_RE='[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'

ensure_simulator() {
  local udid
  udid="$(xcrun simctl list devices booted | grep -Eo "$UDID_RE" | head -1)"
  if [ -z "$udid" ]; then
    udid="$(xcrun simctl list devices available | grep 'iPhone' | grep -Eo "$UDID_RE" | head -1)"
    if [ -n "$udid" ]; then xcrun simctl boot "$udid" >/dev/null 2>&1; fi
  fi
  open -a Simulator >/dev/null 2>&1
  printf '%s' "$udid"
}

valid_test_path() {  # chỉ chấp nhận đường dẫn nằm trong test/, không có ".."
  printf '%s' "$1" | grep -Eq '^test/[A-Za-z0-9_./-]+$' && ! printf '%s' "$1" | grep -q '\.\.'
}

handle() {  # $1=id  $2=verb  $3=arg
  local id="$1" verb="$2" arg="${3:-}" out="$OUT/$1.log" rc=0 udid sig bundle
  case "$verb" in
    analyze)
      log "flutter analyze"
      flutter analyze >"$out" 2>&1; rc=$? ;;
    test|update-goldens)
      if [ -n "$arg" ] && ! valid_test_path "$arg"; then
        echo "Đường dẫn test không hợp lệ: $arg" >"$out"; rc=2
      else
        if [ "$verb" = "update-goldens" ]; then
          log "flutter test --update-goldens $arg"
          if [ -n "$arg" ]; then flutter test --update-goldens "$arg" >"$out" 2>&1; else flutter test --update-goldens >"$out" 2>&1; fi
        else
          log "flutter test $arg"
          if [ -n "$arg" ]; then flutter test "$arg" >"$out" 2>&1; else flutter test >"$out" 2>&1; fi
        fi
        rc=$?
      fi ;;
    pub-get)
      log "flutter pub get"
      flutter pub get >"$out" 2>&1; rc=$? ;;
    run)
      if [ "$arg" != "user" ] && [ "$arg" != "coach" ]; then
        echo "run cần: user hoặc coach" >"$out"; rc=2
      else
        if app_running; then stop_app; fi
        udid="$(ensure_simulator)"
        if [ -z "$udid" ]; then
          echo "Không tìm thấy iPhone Simulator" >"$out"; rc=4
        else
          log "flutter run --flavor $arg trên Simulator $udid"
          rm -f "$FLUTTER_PID"
          ( tail -f /dev/null | flutter run --flavor "$arg" --dart-define=FLAVOR="$arg" \
              --dart-define=ENV=development --debug -d "$udid" --pid-file "$FLUTTER_PID" \
              >"$OUT/run.log" 2>&1 ) &
          echo $! >"$JOB_PID"
          echo "Đã khởi động flutter run ($arg) trên $udid — log: build/claude/out/run.log" >"$out"
        fi
      fi ;;
    reload|restart)
      if app_running; then
        if [ "$verb" = "reload" ]; then sig=USR1; else sig=USR2; fi
        log "hot $verb"
        kill -"$sig" "$(cat "$FLUTTER_PID")" >"$out" 2>&1; rc=$?
        echo "Đã gửi $verb" >>"$out"
      else
        echo "Chưa có app nào đang chạy" >"$out"; rc=3
      fi ;;
    stop)
      log "dừng app"
      stop_app; echo "Đã dừng" >"$out" ;;
    screenshot)
      log "chụp màn hình Simulator"
      xcrun simctl io booted screenshot "$OUT/$id.png" >"$out" 2>&1; rc=$? ;;
    uninstall)
      case "$arg" in
        user) bundle="com.psgy.user" ;;
        coach) bundle="com.psgy.coach" ;;
        *) bundle="" ;;
      esac
      if [ -z "$bundle" ]; then
        echo "uninstall cần: user hoặc coach" >"$out"; rc=2
      else
        log "gỡ $bundle khỏi Simulator"
        xcrun simctl uninstall booted "$bundle" >"$out" 2>&1; rc=$?
      fi ;;
    *)
      log "TỪ CHỐI lệnh ngoài danh sách: $verb"
      echo "Lệnh không nằm trong danh sách cho phép: $verb" >"$out"; rc=127 ;;
  esac
  echo "$rc" >"$OUT/$id.status"
}

trap 'log "Dừng runner"; if app_running; then stop_app; fi; exit 0' INT TERM

log "Sẵn sàng trong $ROOT — chờ yêu cầu từ Claude (Ctrl+C để dừng)"
while true; do
  date +%s >"$BASE/heartbeat"
  for req in "$INBOX"/*.req; do
    [ -e "$req" ] || continue
    id="$(basename "$req" .req)"
    line="$(head -n 1 "$req" | tr -d '\r')"
    mv "$req" "$DONE/" 2>/dev/null || rm -f "$req"
    if ! printf '%s' "$id" | grep -Eq '^[A-Za-z0-9_-]+$'; then log "Bỏ qua yêu cầu có tên lạ"; continue; fi
    verb="$(printf '%s\n' "$line" | awk '{print $1}')"
    arg="$(printf '%s\n' "$line" | awk '{print $2}')"
    handle "$id" "$verb" "$arg"
  done
  sleep 1
done

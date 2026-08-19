# Real Device Test Plan — ParkingLink

**Version:** CP31  
**Target:** iPhone thật (ưu tiên) + Android  
**Build:** `ENV=development` — có Dev switcher + Debug Menu  
**Debug Menu:** Giữ logo Splash • Giữ thanh Map • Nút 🐛 góc dưới-trái

---

## How to Test on iPhone (Step-by-Step)

### Bước 0 — One-time setup (15 phút)

| # | Việc cần làm | Chi tiết |
|---|---------------|----------|
| 1 | Cài Xcode | App Store → Xcode (mở 1 lần, accept license) |
| 2 | Apple ID | Xcode → Settings → Accounts → thêm Apple ID |
| 3 | Developer Mode trên iPhone | Settings → Privacy & Security → **Developer Mode** → ON → restart |
| 4 | Trust Mac | Cắm cáp USB → iPhone popup "Trust This Computer" → Trust |
| 5 | Kiểm tra device | Terminal: `flutter devices` → thấy iPhone (không phải simulator) |
| 6 | APNs (cho push) | Firebase Console → Project Settings → Cloud Messaging → upload APNs key |

### Bước 1 — Chạy app User flavor (nhanh nhất)

```bash
cd /path/to/parking_link

# Cách 1: Script tự detect iPhone và chạy (khuyến nghị)
./scripts/build_test_iphone.sh --run

# Cách 2: Chỉ định flavor
./scripts/build_test_iphone.sh user --run
```

Lần đầu Xcode có thể hỏi **Signing** — mở `ios/Runner.xcworkspace`, chọn Team (Apple ID), bật "Automatically manage signing" cho target **Runner** (User + Staff).

### Bước 2 — Chạy app Staff flavor

```bash
./scripts/build_test_iphone.sh staff --run
```

Hoặc trong app User (dev build): tap **"Chuyen sang Staff"** trên map.

### Bước 3 — Mở Debug Menu trên iPhone

| Cách | Thao tác |
|------|----------|
| **A** | Trên Splash: **giữ logo** ~2 giây (trước khi chuyển màn) |
| **B** | Trên Map: **giữ thanh tìm kiếm** "Parking Link..." ~2 giây |
| **C** | Tap nút **🐛** góc dưới-trái màn Map (dev build only) |

Menu có: Force Sync, Clear Cache, Simulate Offline, Fake Notification, Reset Watchlist, Cache Metrics.

### Bước 4 — Test theo thứ tự P0 (mục 3 bên dưới)

Đánh dấu ✓ trên checklist. Ghi bug vào mục 7.

### Bước 5 — Test Push Notification (cần device thật)

1. User app → theo dõi 1 bãi khảo sát  
2. Debug Menu → **Trigger Fake Notification** (test foreground)  
3. Home button → Firestore tạo `parking_lots/{lotId}` với `metadata.source = "surveying_lot"` (test background)  
4. Tap notification → map mở đúng bãi  

---

## Lệnh Build & Run (Copy-Paste)

### User flavor

```bash
# QA nhanh — hot reload
./scripts/build_test_iphone.sh user --run

# Hoặc trực tiếp:
flutter devices
flutter run --flavor user --debug \
  --dart-define=FLAVOR=user \
  --dart-define=ENV=development \
  -d <DEVICE_ID>
```

### Staff flavor

```bash
./scripts/build_test_iphone.sh staff --run

# Hoặc:
flutter run --flavor staff --debug \
  --dart-define=FLAVOR=staff \
  --dart-define=ENV=development \
  -d <DEVICE_ID>
```

### Build + cài (không hot reload)

```bash
./scripts/build_test_iphone.sh user debug --install
./scripts/build_test_iphone.sh staff debug --install
```

### Rebuild nhanh (bỏ qua pod install)

```bash
./scripts/build_test_iphone.sh user --run --skip-pods
```

### Profile build (gần release)

```bash
./scripts/build_test_iphone.sh user profile --run
```

### Android (tham khảo)

```bash
./scripts/build_test_android.sh user debug
flutter install --flavor user -d <DEVICE_ID>
```

---

## P0 — Must Pass Before Launch (12 cases)

**Hoàn thành 12/12 trước khi submit Store.**

| # | ID | Area | Test on iPhone | Steps | Expected | ✓ |
|---|-----|------|----------------|-------|----------|---|
| 1 | C-01 | Launch | User | Mở app | Splash → Map, no crash | ☐ |
| 2 | C-02 | Location | User | Allow location | Map centers / clear prompt | ☐ |
| 3 | C-03 | Map | User | Xem map + sheet | Markers + lot list load | ☐ |
| 4 | C-05 | Surveying | User | Tap yellow marker | Bottom sheet + "Theo dõi bãi này" | ☐ |
| 5 | C-06 | Watchlist | User | Tap follow | Bell anim + toast + saved state | ☐ |
| 6 | N-02 | Push FG | User | Debug → Fake Notification | Local notif + bell badge | ☐ |
| 7 | N-05 | Deep link | User | Tap notification | Map opens + sheet on lot | ☐ |
| 8 | O-01 | Offline | User | Debug → Simulate Offline ON | Cache banner, no new sync | ☐ |
| 9 | O-03 | Online | User | Debug → Offline OFF | Auto sync resumes | ☐ |
| 10 | S-01 | Staff | Staff | Login valid creds | Dashboard loads | ☐ |
| 11 | S-02 | Check-in | Staff | Enter plate + check in | Session created, slot −1 | ☐ |
| 12 | P-01 | Perf | User | Bật "Hiện tất cả bãi" | Map usable, no freeze >1s | ☐ |

### Error recovery (bonus P0 — nếu có thời gian)

| ID | Test | Expected | ✓ |
|----|------|----------|---|
| E-01 | Simulate Offline → pull refresh | Error view + retry works | ☐ |
| E-02 | Deny location | Fallback TP.HCM + prompt | ☐ |
| S-03 | Staff check-out | Session closes, slot +1 | ☐ |

---

## Full Test Cases (P1–P6)

### P1 — Notifications (FCM)

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| N-01 | Permission | First launch User | iOS notification prompt | ☐ |
| N-03 | Background push | Home → Firestore lot create | System notification | ☐ |
| N-04 | Terminated | Force quit → FCM trigger | Push + tap opens app | ☐ |
| N-06 | Settings OFF | Watchlist → Settings → toggle OFF | No fake notif | ☐ |
| N-08 | Badge clear | Open Watchlist | "Mới" badge clears | ☐ |

### P2 — Offline & Cache

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| O-02 | Cached visible | Offline after load | Cached lots still show | ☐ |
| O-04 | Clear cache | Debug → Clear Isar | Fresh network fetch | ☐ |
| O-05 | Force sync | Debug → Force Sync | Metrics update | ☐ |
| O-06 | Airplane mode | Real airplane toggle | Same as simulate | ☐ |

### P3 — Staff Operations

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| S-04 | Manual adjust | +/- buttons | Slot count correct | ☐ |
| S-05 | Realtime | Watch dashboard | Live updates | ☐ |
| S-06 | Logout | Sign out | Back to login | ☐ |

### P4 — Error Recovery

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| E-03 | Empty state | Area with no lots | CTA visible | ☐ |

### P5 — Performance

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| P-02 | Background sync | 10 min foreground | No abnormal battery drain | ☐ |
| P-03 | Memory | Map ↔ Watchlist ×20 | No crash / severe lag | ☐ |
| P-04 | Cold start | Force quit → reopen | Map interactive <3s | ☐ |

### P6 — Dark Mode + Accessibility

| ID | Case | Steps | Expected | ✓ |
|----|------|-------|----------|---|
| A-01 | Dark mode | iOS Settings → Dark | Readable UI | ☐ |
| A-04 | Touch targets | Tap chips / FAB | Easy to tap | ☐ |

---

## Debug Menu Reference

| Action | Mục đích |
|--------|----------|
| Force Background Sync | Test sync + refresh map data |
| Clear Isar Cache | Cold fetch from Firestore |
| Simulate Offline | Test offline UX (no Wi‑Fi toggle) |
| Trigger Fake Notification | Foreground notif + badge |
| Reset Watchlist | Clear followed lots |
| View Cache Metrics | Inspect cache counts |

---

## Troubleshooting iPhone

| Vấn đề | Giải pháp |
|--------|-----------|
| `flutter devices` không thấy iPhone | Unlock phone, Trust Mac, bật Developer Mode, thử cáp khác |
| Signing error | Xcode → Runner.xcworkspace → Signing & Capabilities → chọn Team |
| App crash on launch | `flutter run` xem log; thử `--skip-pods` hoặc `cd ios && pod install` |
| Không nhận push | Kiểm tra APNs key trên Firebase; notification permission ON |
| Debug Menu không hiện | Build phải có `ENV=development`, không phải production |
| Map trống | Bật location; Debug → Force Sync; kiểm tra Firestore data |

---

## Test Execution Log

| Date | Tester | Device | Build | P0 (12) | Notes |
|------|--------|--------|-------|---------|-------|
| | | iPhone __ / iOS __ | user debug | /12 | |

---

## E2E Watchlist Notification

1. `./scripts/build_test_iphone.sh user --run`  
2. Follow surveying lot (C-06)  
3. Debug → Fake Notification (N-02)  
4. Firestore: create `parking_lots/{id}` with `metadata.source = "surveying_lot"`  
5. Background/terminated push (N-03/N-04) → tap (N-05)  

---

*Cập nhật checklist sau mỗi vòng QA.*

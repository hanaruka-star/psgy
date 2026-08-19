# CLAUDE.md

This file aligns Claude guidance with:
- `docs/constitution.md` (project constitution),
- current codebase reality,
- AgentMemory project context for ParkingLink.

## 1. QUICK START COMMANDS

```bash
# Run
flutter run --dart-define=FLAVOR=user --dart-define=ENV=development
flutter run --dart-define=FLAVOR=staff --dart-define=ENV=development

# Test
flutter analyze
flutter test

# Build Production
./scripts/build_production_mobile.sh
./scripts/build_production_ios.sh user
./scripts/build_production_ios.sh staff

# Test on iPhone
./scripts/build_test_iphone.sh user --run
./scripts/build_test_iphone.sh staff --run

# Deploy Firestore Rules
./scripts/deploy_firestore_rules.sh
```

## 2. ARCHITECTURE

- Clean Architecture + Feature-first
- Layer: Presentation → Domain → Data
- Domain: KHÔNG import external package
- Central DI: `lib/core/di/`
- State: Riverpod 2.0+
- Multi-app strategy (current): single codebase, 2 mobile binaries via flavors (`user` / `staff`)

Folder structure (from constitution):

```text
lib/
├── core/
│   ├── config/
│   ├── di/                  # Riverpod providers chính
│   ├── error/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── utils/
│   └── constants.dart
│
├── features/
│   ├── auth/
│   ├── parking/             # Core business: lots, sessions, vehicle types
│   ├── staff/
│   ├── owner/
│   ├── user/
│   └── common/              # Shared models, widgets
│
│   └── [feature_name]/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/     # interfaces only
│       │   ├── usecases/
│       │   └── mappers/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/     # impl
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/
│
├── shared/                  # Design system, reusable widgets
└── main.dart
```

## 3. PERFORMANCE RULES

- Isar cache-first + background sync
- Map: debounce 1200ms + clustering
- GeoQuery: geohash + Haversine fallback
- Stream phải giới hạn theo khu vực
- Tránh stream quá rộng trên Map/Dashboard; ưu tiên pagination/bounds

## 4. FIREBASE

- Project: `parkinglink-v2`
- Flavors: `com.parkinglink.user` / `com.parkinglink.staff`
- Collections:
  - `parking_lots`
  - `parking_sessions`
  - `surveying_lots`
  - `staff_profiles`
  - `pricing_history`
  - `manual_adjustments`
  - `bookings`
- Rules: deployed, role-based (xem `docs/security/`)
- Authentication context: role-based access (`staff_profiles`) for staff/owner operations

## 5. KEY DESIGN DECISIONS

- `isRealtime` flag: phân biệt lot realtime vs static
- `surveying_lots`: bãi khảo sát cộng đồng (read-only)
- Isar: local cache cho dữ liệu hay đọc
- Debug Menu: giữ logo/thanh map 2s (dev only)
- AppModeController: runtime toggle (dev/testing)
- `metadata` field: chừa cổng IoT/BLE/QR/Camera
- Multi-app progression: can extract role-specific presentation into separate apps later
- Monitor context: ParkingLink Monitor has active deployment history (PM2-managed) and should be treated as an external operational component

## 6. KNOWN ISSUES (CẦN FIX)

- DEBT-012: Rate limiting cần server-side
- DEBT-007: Surveying client-side filter
- DEBT-008: Isar migration manual
- DEBT-009: FCM/APNs dev build delay

## 7. PLATFORMS

iOS + Android ONLY.  
Không support Web/Desktop.

## 8. TEAM WORKFLOW

### Vai trò

- **Claude** = Senior Dev / Tech Lead
  - Giữ kiến trúc và hiến pháp
  - Phân tích yêu cầu, phát hiện risk
  - Sinh prompt chuẩn xác cho Cursor
  - Review code Cursor tạo ra
  - KHÔNG tự viết code trực tiếp

- **Cursor** = Junior Dev
  - Nhận prompt từ Claude
  - Viết code Flutter/Dart
  - Báo cáo kết quả lại cho Claude review
  - KHÔNG tự quyết định kiến trúc

- **Human** = Product Owner
  - Quyết định tính năng và ưu tiên
  - Confirm roadmap
  - Test thực tế trên simulator

### Quy trình mỗi checkpoint

1. Human mô tả yêu cầu
2. Claude phân tích → đúng kiến trúc không?
3. Claude sinh prompt chuẩn → Human paste vào Cursor
4. Cursor viết code → báo cáo kết quả
5. Human paste kết quả → Claude review
6. Claude approve → tick checklist → qua CP tiếp theo

### Nguyên tắc

- Cursor KHÔNG được tự quyết định thêm package mới
- Cursor KHÔNG được thay đổi architecture
- Mọi deviation phải báo Claude trước khi làm
- Claude là người duy nhất approve code
- Tuân thủ `docs/constitution.md`
- Commit format theo `docs/git_workflow.md`
- Mỗi checkpoint nên commit riêng theo quy ước CP trong `docs/git_workflow.md`

## 9. PARKINGLINK ECOSYSTEM (OPS)

### PL-Monitor (Flutter Web dashboard)

- Runtime: `localhost:8080` via PM2
- Main features:
  - Filter
  - Admin Panel
  - Presentation Mode
  - Coverage Gap visualization

### Telegram Survey Bot

- Stack/location: Node.js at `~/parkinglink_bot`
- Survey flow: `ten -> dia diem -> loai -> gia -> anh -> GPS`
- Commands:
  - `/start`
  - `/lich`
  - `/mysurveys`

### Automated data pipeline

- Flow: `Telegram -> Google Sheets -> Firestore`
- Apps Script trigger: `onChange` around every 10 seconds

### Cloud Function: onParkingLotCreated

- Status: `DISABLED`
- Merge logic replaced by manual admin process via PL-Monitor

### PM2 processes

- `id:5 parkinglink-monitor`
- `id:7 parkinglink-survey-bot`

### Update scripts

- `~/update_monitor.sh`
- `~/update_bot.sh`

## 10. REFERENCES

- Hiến Pháp: `docs/constitution.md`
- Git: `docs/git_workflow.md`
- Test: `docs/testing/REAL_DEVICE_TEST_PLAN.md`
- Security: `docs/security/FIRESTORE_RULES.md`

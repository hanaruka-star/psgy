# CLAUDE.md

This file aligns Claude guidance with:
- `docs/constitution.md` (project constitution),
- current codebase reality,
- AgentMemory project context for PSgy.

## 1. QUICK START COMMANDS

```bash
# Run
flutter run --dart-define=FLAVOR=user --dart-define=ENV=development
flutter run --dart-define=FLAVOR=coach --dart-define=ENV=development

# Test
flutter analyze
flutter test

# Build Production
./scripts/build_production_mobile.sh
./scripts/build_production_ios.sh user
./scripts/build_production_ios.sh coach

# Test on iPhone
./scripts/build_test_iphone.sh user --run
./scripts/build_test_iphone.sh coach --run

# Deploy Firestore Rules
./scripts/deploy_firestore_rules.sh
```

## 2. ARCHITECTURE

- Clean Architecture + Feature-first
- Layer: Presentation → Domain → Data
- Domain: KHÔNG import external package
- Central DI: `lib/core/di/`
- State: Riverpod 2.0+
- Multi-app strategy (current): single codebase, 2 mobile binaries via flavors (`user` / `coach`)

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
│   ├── user/                # Phone Auth OTP
│   ├── common/
│   └── pilot_demo/          # mock UI tham khảo
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

- Project: `psgy-app`
- Flavors: `com.psgy.user` / `com.psgy.coach`
- Collections: do đội backend định nghĩa (gym / coach / booking) — xem `docs/handoff/`
- Rules: local `firestore.rules` = nguồn thật (`docs/security/FIRESTORE_RULES.md`)
- Authentication: Phone Auth (OTP). User app tạm mock OTP; `PhoneAuthScreen` thật được giữ.

## 5. KEY DESIGN DECISIONS

- Isar: local cache + migration pattern (AppSettings)
- Debug Menu: giữ logo Splash 2s (dev only)
- AppModeController: runtime toggle User/Coach (dev)
- Multi-app: flavors `user` / `coach`

## 6. KNOWN ISSUES (CẦN FIX)

- User app đang bypass Phone Auth thật bằng `MockPhoneAuthScreen` vì `UserProfileNotifier` đọc `users/{uid}` gây `permission-denied` (handoff B7)
- DEBT-009: FCM/APNs dev build delay
- DEBT-008: Isar migration manual

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

## 9. OPS

PSgy không dùng ParkingLink Monitor / Telegram survey bot / Apps Script pipeline.

Deploy rules: `./scripts/deploy_firestore_rules.sh`

## 10. REFERENCES

- Hiến Pháp: `docs/constitution.md`
- Git: `docs/git_workflow.md`
- Test: `docs/testing/REAL_DEVICE_TEST_PLAN.md`
- Security: `docs/security/FIRESTORE_RULES.md`

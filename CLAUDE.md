# CLAUDE.md

This file aligns Claude guidance with:
- `docs/constitution.md` (project constitution),
- current codebase reality,
- AgentMemory project context for PSgy.

## 1. QUICK START COMMANDS

```bash
# Run (demo — nhanh, hot reload)
./scripts/run_dev_fast.sh user
./scripts/run_dev_fast.sh coach

# Run (tương đương)
flutter run --flavor user --dart-define=FLAVOR=user --dart-define=ENV=development --debug
flutter run --flavor coach --dart-define=FLAVOR=coach --dart-define=ENV=development --debug

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
- Ngoại lệ: `lib/features/pilot_demo/` là prototype demo — miễn Clean Architecture/Riverpod (xem mục 8)

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
- Flavors: `com.psgy.user` (tên hiển thị **PSGymer User**) / `com.psgy.coach` (**PSGymer Coach**)
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

### Mục đích repo (chốt 29/09/2026)

Repo này là **bản demo sống**: app chạy được với dữ liệu giả để đội dev *nhìn thấy* hệ thống hoạt động thế nào, rồi ước lượng và xây platform thật.
Ưu tiên: **sửa nhanh** + **thể hiện đúng nghiệp vụ**. Đây KHÔNG phải code production.

### Vai trò (giai đoạn DEMO & UI POLISH)

- **Claude** = Tech Lead + người sửa code demo
  - Sửa code Dart **trực tiếp** trong repo (chủ yếu `lib/features/pilot_demo/`, theme, tài liệu)
  - Giữ đúng nghiệp vụ trong demo — demo chính là spec cho đội dev
  - Mỗi tính năng thêm/sửa → cập nhật mục tương ứng trong `docs/handoff/` (demo làm gì / bản thật cần gì / luật nghiệp vụ / ảnh màn hình)
  - Soạn sẵn commit message; **KHÔNG tự commit/push**
- **Human** = Product Owner
  - Nêu yêu cầu (lời, ảnh chụp, phác thảo), chạy app và xem
  - Duyệt thay đổi và commit
- **Cursor** = tuỳ chọn, khi Human muốn tự vibe code. **Không sửa cùng lúc với Claude.**

### Vòng làm việc

1. Human chạy `./scripts/run_dev_fast.sh user` (hoặc `coach`) một lần
2. Human nêu yêu cầu → Claude sửa code
3. Human bấm `r` (hot reload) → xem → góp ý → lặp lại. Đổi DI/theme/state toàn cục → `R` (hot restart)
4. Ổn → Claude soạn commit message → Human commit theo `docs/git_workflow.md`

### Quy tắc demo

- `lib/features/pilot_demo/` là **prototype**: được miễn Clean Architecture/Riverpod. Singleton `MockUserSession` / `MockCoachSession` + `setState` là **chủ ý** để sửa nhanh. Đội dev KHÔNG coi đây là kiến trúc mẫu.
- Chỉ Dart + mock data. Không thêm native package nếu không thật sự cần (phải build lại native — chậm nhất).
- Mock data mới đánh dấu `// DEMO DATA` để dễ tìm và xoá sau.
- Đổi style qua `lib/core/theme/`, không hardcode màu trong widget.
- Sửa `Info.plist`, tên app, package native → phải build lại; hot reload không áp dụng.
- Cursor (nếu dùng) tuân thủ `.cursor/rules/demo-dart-only.mdc` và `docs/cursor_prompt_templates.md` (Template A/B/C); không tự thêm package hay đổi kiến trúc — lệch quy tắc phải báo Claude trước.

### Khi sang giai đoạn backend thật

Quay lại mô hình: Claude = Tech Lead (phân tích, sinh prompt, review) → Cursor = Junior Dev (viết code) → Human = PO (duyệt, test).
Tuân thủ `docs/constitution.md`; commit theo quy ước CP trong `docs/git_workflow.md`.

## 9. OPS

PSgy không dùng ParkingLink Monitor / Telegram survey bot / Apps Script pipeline.

Deploy rules: `./scripts/deploy_firestore_rules.sh`

## 10. REFERENCES

- Hiến Pháp: `docs/constitution.md`
- Git: `docs/git_workflow.md`
- Test: `docs/testing/REAL_DEVICE_TEST_PLAN.md`
- Security: `docs/security/FIRESTORE_RULES.md`

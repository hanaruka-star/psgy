# PSgy

Flutter app tìm gym + đặt lịch với PT/Coach tại TP.HCM.

> **Repo này là bản demo** (dữ liệu giả, các tính năng chưa nối backend thật) để đội dev xem hệ thống chạy thế nào, từ đó ước lượng và xây platform thật. Cách làm việc: xem `CLAUDE.md` mục 8.

Hai binary cùng codebase:

- **PSGymer User** — `com.psgy.user` (`--flavor user`)
- **PSGymer Coach** — `com.psgy.coach` (`--flavor coach`)

Firebase project: `psgy-app`. Chỉ iOS + Android.

## Chạy

```bash
# Cách nhanh (khuyên dùng) — debug, hot reload sẵn
./scripts/run_dev_fast.sh user
./scripts/run_dev_fast.sh coach

# Tương đương — --flavor và --dart-define=FLAVOR phải KHỚP nhau
flutter run --flavor user --dart-define=FLAVOR=user --dart-define=ENV=development
flutter run --flavor coach --dart-define=FLAVOR=coach --dart-define=ENV=development
```

## Test / analyze

```bash
flutter analyze
flutter test
```

## 📸 UI Reference — giữ đúng UI/UX khi làm backend thật

Bộ ảnh **mục tiêu** (cái đội dev phải tái tạo y hệt) nằm ở:

| Thư mục | Nội dung |
|---|---|
| `screenshots/` | Ảnh đích từng màn — gồm `NN_*.png` (bản dựng UI từ golden test) + `IMG_*.jpeg` (ảnh máy thật iPhone). Đối chiếu màn nào làm xong với ảnh tương ứng. |
| `test/pilot_demo/goldens/` | 19 ảnh golden gốc (390×844) do widget test sinh ra. |
| `test/pilot_demo/capture_19_screens_test.dart` | Test chụp 19 màn → chạy lại để tự sinh ảnh: `flutter test test/pilot_demo/capture_19_screens_test.dart --update-goldens` |

> Code UI reference: `lib/features/pilot_demo/` — commit cuối đụng tới: `45c943b` (xem `git log -- lib/features/pilot_demo`).
> Nếu sửa UI, chạy lại golden test để cập nhật ảnh reference cho đội dev.

## Firestore rules

Local `firestore.rules` là nguồn thật. Deploy:

```bash
./scripts/deploy_firestore_rules.sh
```

Tài liệu chuyển giao backend: `docs/handoff/`.

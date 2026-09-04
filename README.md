# PSgy

Flutter app tìm gym + đặt lịch với PT/Coach tại TP.HCM.

Hai binary cùng codebase:

- **User** — `com.psgy.user` (`--dart-define=FLAVOR=user`)
- **Coach** — `com.psgy.coach` (`--dart-define=FLAVOR=coach`)

Firebase project: `psgy-app`. Chỉ iOS + Android.

## Chạy

```bash
flutter run --dart-define=FLAVOR=user --dart-define=ENV=development
flutter run --dart-define=FLAVOR=coach --dart-define=ENV=development
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

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

## Firestore rules

Local `firestore.rules` là nguồn thật. Deploy:

```bash
./scripts/deploy_firestore_rules.sh
```

Tài liệu chuyển giao backend: `docs/handoff/`.

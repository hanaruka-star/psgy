# 05 — Assets

`pubspec.yaml` khai báo: `assets/images/`, `images/branding/`, `images/icons/`, `images/journal/`, `assets/avatars/`, `assets/animations/`, `assets/map_style/`.  
**Không** khai báo `assets/brand/` (SVG logo Ruka) — Dart không load; header là `HeaderLogo` CustomPaint.

Font: **Inter** qua `google_fonts` (không file `.ttf` trong repo).

## Ảnh đang dùng

| Đường dẫn | Kích thước | Màn | Nguồn / giấy phép |
|---|---|---|---|
| `assets/avatars/coach_01.png` … `coach_06.png` | CẦN XÁC NHẬN (file PNG local; không ghi px trong code) | U07/U08 card, U09 slideshow tấm 1, U12 AppBar, U13, C01 | `SOURCE.txt`: chân dung mock do **Ruka** cung cấp. Thay Fluent Emoji 3D cũ (emoji **không còn** trong repo). |
| `assets/images/journal/seed_01.jpg` … `seed_04.jpg` | CẦN XÁC NHẬN | Slideshow Coach 2–5, before/after kết quả, cert lightbox, lưới nhật ký User/Cộng đồng/Coach, thumbnail PT AI | **CHƯA RÕ NGUỒN** |
| `assets/map_style/map_style_light.json` | n/a (JSON) | U07 light | **CHƯA RÕ NGUỒN** (soạn cho E3) |
| `assets/map_style/map_style_dark.json` | n/a | U07 dark | **CHƯA RÕ NGUỒN** |

Avatar mapping (`SOURCE.txt`):  
coach_01 Nguyễn Văn Long NL · coach_02 Trần Thị Mai TM · coach_03 Lê Hoàng Nam LN · coach_04 Phạm Minh Châu PC · coach_05 Võ Thành Đạt VĐ · coach_06 Hoàng Thị Thu Hà HH.

## Icon / splash / branding — có file nhưng lib không vẽ

| Đường dẫn | Dùng | Nguồn |
|---|---|---|
| `assets/images/icons/app_icon_user.png` | `flutter_launcher_icons` User | **CHƯA RÕ NGUỒN** |
| `assets/images/icons/app_icon_coach.png` | launcher Coach | **CHƯA RÕ NGUỒN** |
| `assets/images/icons/app_icon.png` | legacy? không grep trong `lib/` | **CHƯA RÕ NGUỒN** |
| `assets/images/branding/splash_blank.png` | native splash android_12 (blank) | **CHƯA RÕ NGUỒN** |
| `assets/images/branding/logo_light.png` / `logo_dark.png` | không reference `lib/` | **CHƯA RÕ NGUỒN** |
| `assets/brand/gymps_logo.svg` (+ `_coach`, `_mark`, `icon_ta.png/.svg`) | không trong pubspec, không dùng Dart | **CHƯA RÕ NGUỒN** (E9: Ruka thiết kế; runtime dùng CustomPaint) |
| `assets/animations/` | chỉ `.gitkeep` | n/a |

Launch iOS: `LaunchScreen.storyboard` scene `splash-blank-vc` — **không** còn logo ParkingLink trong storyboard. Flutter splash sau đó = `SplashScreen` + `HeaderLogo`.

## Badge

Không có file PNG. `iconAsset` = key logic `badge_first_session` / `badge_streak_3` / `badge_streak_7` → Material: `emoji_events_outlined` / `local_fire_department_outlined` / `workspace_premium_outlined`.

## Ảnh runtime khác

- Avatar User lúc tạo hồ sơ: path local từ `image_picker` (không seed).
- PT AI session: `camera` plugin — không asset; fallback chữ `Đang mở camera trước…`.
- Journal User đăng mới: ảnh user chọn (file/http/asset qua `journal_media.dart`).

# Task: Demo 3 style UI — Material 3 Expression / Glassmorphism / Neumorphism (theme switcher)

## Context
- Project: PSgy (GymPS) — Flutter 3.41.7, Clean Architecture + Riverpod 2.0
- Codebase: /Users/ruka/psgy (branch: main)
- Theme hiện tại: `lib/core/theme/app_theme.dart` — `AppTheme.light` / `AppTheme.dark` (Material 3)
- Mục đích: **Ruka muốn XEM 3 style UI rồi CHỌN 1 cái** — làm theme switcher để đổi style ngay trên simulator, không cần build lại
- Demo phase: DART-ONLY, mock data, hot reload (`r`)

## Yêu cầu — 3 style cần làm

### Style 1 — Material 3 Expression
- Giữ `ColorScheme.fromSeed` với seed color hiện tại của app (xem `app_colors.dart`)
- Tăng độ "biểu cảm": shape tròn hơn (rounded 20-24px), icon nét đậm hơn, state layer rõ, typography expressive (weight/letter-spacing)
- Vẫn trong khuôn Material 3 chuẩn — đây là style mặc định, an toàn

### Style 2 — Glassmorphism (kính mờ)
- Card/Sheet: nền trong suốt + hiệu ứng mờ đục — dùng `BackdropFilter` + `ImageFilter.blur` (dart:ui — KHÔNG cần package)
- Viền sáng mỏng (border 1px trắng alpha ~0.3), shadow nhẹ, corner radius lớn
- Nền app: gradient màu tươi (xanh → tím) để hiệu ứng kính "ăn" ảnh
- Chữ đậm rõ trên nền mờ (contrast đủ)

### Style 3 — Neumorphism (mềm mại 3D)
- Card/Button: nền cùng màu với background, 2 shadow: light (trên-trái, offset âm) + dark (dưới-phải, offset dương)
- Nút bấm có hiệu ứng "lõm xuống" khi nhấn (pressed state)
- Corner radius tròn mềm, background màu pastel nhạt
- KHÔNG dùng package — tự làm bằng BoxShadow + custom widget

## Cách làm (theme switcher)

### Bước 1 — Tạo 3 theme
Tạo trong `lib/core/theme/`:
- `theme_m3_expression.dart` → `ThemeData buildM3Expression({required bool isDark})`
- `theme_glass.dart` → `ThemeData buildGlass({required bool isDark})` + widget `GlassCard`/`GlassPanel` (dùng BackdropFilter)
- `theme_neumorphic.dart` → `ThemeData buildNeumorphic({required bool isDark})` + widget `NeuCard`/`NeuButton`

### Bước 2 — Provider đổi theme (Riverpod)
Tạo `lib/core/di/theme_provider.dart`:
- `enum AppStyle { m3Expression, glass, neumorphic }`
- `StateProvider<AppStyle>` mặc định `m3Expression`
- Provider trả `ThemeData` theo style + dark mode hiện tại
- Sửa `lib/main.dart` (hoặc `PsgyApp`) dùng `Consumer` lấy theme từ provider

### Bước 3 — Debug switcher (dev only)
- Thêm widget nhỏ (FAB hoặc floating panel, chỉ hiện khi `kDebugMode`)
- 3 nút: `M3 Expression` / `Glass` / `Neumorphic` — bấm đổi `AppStyle`, hot reload/restart tự áp
- Nhớ đánh dấu `// DEMO DATA` / `// DEV ONLY` để dễ xoá sau

### Bước 4 — Áp dụng lên 3-4 màn chính cho dễ so sánh
- Chọn màn đại diện: Home/Browse, Chi tiết Coach, Booking, Profile (hoặc màn dễ thấy nhất)
- Đảm bảo card/button/dialog dùng theme → tự đổi style theo switcher

## Ràng buộc BẮT BUỘC
- ❌ KHÔNG thêm package mới (kể cả pure Dart) — BackdropFilter từ dart:ui, BoxShadow có sẵn
- ❌ KHÔNG đổi logic/domain/architecture — CHỈ theme + widget hiển thị
- ❌ KHÔNG phá `AppTheme.light/dark` cũ — thêm mới, giữ fallback m3Expression = giống hiện tại
- ✅ Style qua ThemeData, không hardcode màu trong từng screen
- ✅ Chạy được cả 2 flavor (user + coach)

## Definition of Done
- [ ] `flutter analyze` KHÔNG có error mới
- [ ] `./scripts/run_dev_fast.sh user` chạy được
- [ ] Trên simulator: bấm switcher đổi được cả 3 style (hot reload `r` hoặc `R`)
- [ ] Chụp screenshot từng style (3 ảnh) — Simulator Cmd+S
- [ ] Commit: feat: add 3-style UI demo switcher (CPxx)
- [ ] Báo cáo: file tạo, cách dùng switcher, 3 screenshot

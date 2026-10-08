# 03 — Design tokens

Màu resolve: `flutter test prototype/docs/audit/tools/dump_theme_test.dart`  
File máy: `design_tokens.json`.

## Nguyên tắc

- `AppTheme.light` / `AppTheme.dark` = `ColorScheme.fromSeed` + Inter + `AppShapes` (squircle 0.8).
- Seed **light** `#00A0E0` → `primary` thật **`#236488`**. Seed **dark** `#9290FA` → `primary` **`#C3C1FF`**.
- Một số màu **hardcode** ngoài fromSeed: `AppStatusColors` (E8) và `AppColors` (logo + textTheme gốc).
- User vs Coach: Coach canvas / AppBar = `sheetBackground` (`#DEF0F1` light / `#1E2A2A` dark). User scaffold = `#F8FAFC` / `#0F172A`.

## ColorScheme (đủ field)

Xem bảng đầy đủ trong `design_tokens.json` → `colorScheme.light` / `colorScheme.dark`.

Điểm dùng nhiều:

| Token | Light | Dark |
|---|---|---|
| primary | `#236488` | `#C3C1FF` |
| onPrimary | `#FFFFFF` | `#2B2A60` |
| primaryContainer | `#C7E7FF` | `#424178` |
| onPrimaryContainer | `#004C6D` | `#E2DFFF` |
| secondaryContainer | `#D2E5F5` | `#464559` |
| tertiaryContainer | `#E9DDFF` | `#603C50` |
| error | `#BA1A1A` | `#FFB4AB` |
| surface | `#F6FAFE` | `#131318` |
| onSurface | `#181C20` | `#E5E1E9` |
| outline | `#71787E` | `#928F9A` |
| surfaceContainerHigh (bubble chat đối phương) | `#E5E8ED` | `#2A292F` |

`cardTheme.color` (không còn viền E7): Light `#EFF3FA` · Dark `#36363B` (blend 15% trắng lên surface).

## AppStatusColors (E8 — hardcode)

| Token | Light | Dark | Dùng |
|---|---|---|---|
| tagBackground | `#EFF3FA` | `#2F2F34` | chip Rảnh, tag gói, tag bài |
| highlight | `#346B34` | `#7BC17B` | chữ “Rảnh…”, sao phẳng `Icons.star`, FAB PT AI, marker Coach/gym hệ thống |
| onHighlight | `#FFFFFF` | `#14532D` | chữ/icon trên fill highlight |
| tabActive | `#275F95` | `#7BAEE0` | tab đang chọn + nhãn PT AI |
| tabInactive | `#94A3B8` | `#94A3B8` | tab không chọn + marker gym thu thập |
| sheetBackground | `#DEF0F1` | `#1E2A2A` | sheet Map, canvas Coach |
| sheetTitle | `#2E2F2F` | `#E8E8E8` | “Coach gần bạn” |
| warning pair | `#FFEDD5` / `#7C2D12` | `#5C3D1A` / `#FFEDD5` | chip pending / awaiting |
| success pair | `#DCFCE7` / `#14532D` | `#14532D` / `#DCFCE7` | inProgress / completed |
| danger pair | `#FEE2E2` / `#7F1D1D` | `#7F1D1D` / `#FEE2E2` | cancelled |
| warningFg / successFg | `#F97316` / `#16A34A` | `#FDBA74` / `#86EFAC` | badge streak |

Like đã thả: `Icons.favorite` màu `colorScheme.error` (không hex riêng).

## Chip Mục tiêu / Đối tượng (H2a) — `_ProfileTag` colored

Chỉ trên `CoachDetailScreen`. Hình thức **không** colored (tag xám `#EFF3FA`).

| Nhãn | Light bg / fg |
|---|---|
| Tăng cơ | success `#DCFCE7` / `#14532D` |
| Giảm mỡ | warning `#FFEDD5` / `#7C2D12` |
| Tăng sức bền | primaryContainer `#C7E7FF` / `#004C6D` |
| Phục hồi sau chấn thương | tertiaryContainer `#E9DDFF` / `#4B4263` |
| Nam | secondaryContainer `#D2E5F5` / `#384956` |
| Nữ | sheet `#DEF0F1` / `#2E2F2F` |
| VĐV | highlight 18% / `#346B34` |
| Người mới bắt đầu | tabActive 16% / `#275F95` |
| Phục hồi chấn thương | danger 85% / `#7F1D1D` |

Dark: cùng token `AppStatusColors` / `ColorScheme` (hue giữ, sáng hơn).

## Marker bản đồ + legend gym

- Coach: giọt nước 36×48, fill = highlight, lỗ = onHighlight.
- Gym hệ thống: vuông bo 6 + đuôi, fill highlight. Legend: `Hệ thống — đối tác PSgy`.
- Gym thu thập: fill `#94A3B8`. Legend: `Thu thập — chỉ tham khảo`.
- Style JSON: `assets/map_style/map_style_light.json` / `map_style_dark.json` (ẩn POI/transit).

## Typography — Inter

`GoogleFonts.interTextTheme(AppTextStyles.textTheme(isDark: …))` + `fontFamily: Inter`.

| Style | Size | Weight | Height | Letter | Chỗ dùng điển hình |
|---|---|---|---|---|---|
| displaySmall | 32 | 800 | 1.2 | −0.5 | (ít dùng) |
| headlineMedium | 24 | 700 | 1.25 | −0.3 | tên Coach (U09) |
| titleLarge | 20 | 700 | 1.3 | — | AppBar, tên trên Home Coach |
| titleMedium | 16 | 600 | 1.35 | — | tiêu đề section |
| bodyLarge | 16 | 400 | 1.5 | — | body |
| bodyMedium | 14 | 400 | 1.45 | — | bio, mô tả |
| bodySmall | 12 | 400 | 1.4 | — | phụ, rating suffix |
| labelLarge | 14 | 600 | — | 0.2 | nút |
| labelMedium | 12 | 600 | — | 0.3 | chip |
| labelSmall | theme mặc định | | | | nhãn bottom bar |

HeaderLogo: `gym` w800 + mark + `PS` w900; Coach thêm `coach` w600 size × 0.42. Light: gym `#1E3A8A`, PS `#0F172A`. Dark: gym = scheme.primary, PS = onSurface.

Màu chữ gốc AppTextStyles: light `#0F172A` / `#64748B`; dark `#F8FAFC` / `#94A3B8` — Inter overlay lên trên.

## Radius / spacing / shadow

| Token | px |
|---|---|
| xs / sm / md / lg / xl / xxl | 4 / 8 / 16 / 24 / 32 / 48 |
| radiusSm chip/input | 12 |
| radiusMd button **và card** (E7) | 16 |
| radiusLg dialog | 24 |
| radiusXl sheet | 28 |
| cornerSmoothing | 0.8 (`figma_squircle`) |
| Card elevation | 0, không `side` |
| AppBar elevation | 0 |
| Bottom bar Material elevation | 3 |
| FAB PT AI | 4, CircleBorder 60×60 |

Input vẫn `OutlineInputBorder` (không squircle).

## Chiều cao / avatar

| | |
|---|---|
| AppBar User | `kToolbarHeight` (56) |
| AppBar Coach + logo | 72 |
| Bottom bar | 64 + safe inset + FAB lift 16 |
| CoachAvatar mặc định | radius 28 (map/list); chat 16; lịch sử 20 |
| Gym list avatar | 24 |
| Setup hồ sơ | 48 |
| Badge nhật ký | 20 |
| Slideshow hồ sơ Coach | cao 240 |

## Icon Material

Xem bảng đầy đủ theo màn trong `01_MAN_HINH.md`. Nhóm chính:

- Nav User: `map` / `auto_stories` / `groups` / `receipt_long` (+ `_outlined` khi không chọn)
- PT AI: `videocam_outlined`, `smart_toy_outlined`
- Map: `person_outline`, `fitness_center_outlined`, `directions_outlined`
- Booking/chat: `chat_bubble_outline`, `send`, `star` / `star_border`
- Coach Home: `edit_outlined`, `auto_stories_outlined`, `fitness_center_outlined`, `my_location_outlined`
- Journal: `favorite` / `favorite_border`, `photo_outlined`, badge `emoji_events_outlined` / `local_fire_department_outlined` / `workspace_premium_outlined`
- Dev switcher: `person` / `engineering`

Sao đánh giá: `Icons.star` tô phẳng 1 màu highlight — không BoxShadow/gradient.

## AppColors còn trong repo nhưng không drive ColorScheme

`#2563EB` primary cũ, gradient brand, slotColor — **không** gán vào `ThemeData.colorScheme`. Prototype nên theo dump fromSeed + AppStatusColors, không theo `AppColors.primary`.

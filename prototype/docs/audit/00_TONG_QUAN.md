# 00 — Tổng quan audit UI/UX

Nguồn: tag `flutter-reference-final` = `245437c` trên `main`.  
WIP Flutter còn dở (Theme Switcher L, flavor naming…) nằm nhánh `archive/flutter-wip` @ `26c393e` — **không** thuộc bản mẫu này.

## Số màn / số luồng

| | Số |
|---|---|
| Màn User (U01–U22) | **22** |
| Overlay User (sheet gym, dialog mua gói, xem chứng chỉ, badge, dừng PT AI) | **5** |
| Màn Coach (C01–C07) | **7** |
| Overlay Coach (dialog không đến, CRUD dịch vụ/gói, địa điểm/chứng chỉ, time picker) | **8** |
| **Tổng màn route** | **29** |
| Luồng chính (xem `02_LUONG.md`) | **16** |

Dev-only: U03 `ModeSwitcherScreen` (nút AppBar `Chuyển sang Coach` / `Chuyển sang User`) — chỉ khi `ENV=development`.

## 8 vấn đề lớn nhất

1. **Copy màn đồng ý quyền riêng tư còn “bãi xe”** (`PrivacyConsentScreen`) — sót ParkingLink, lệch nghiệp vụ gym/Coach.
2. **Hai phiên mock không đồng bộ.** `MockUserSession` và `MockCoachSession` độc lập: chat, booking, nhật ký User không hiện bên Coach và ngược lại. Demo UI, không phải luồng xuyên app.
3. **Primary light từ `fromSeed(#00A0E0)` ra `#236488`** — trầm hơn ảnh mẫu. Checklist E1-sửa còn chờ Ruka ưng tông.
4. **Địa chỉ + mã giảm giá trên Xác nhận đặt lịch chỉ là UI** — không lưu vào booking, nút `Áp dụng` chỉ unfocus.
5. **H3 đợt 2 chưa xong trên màn sửa hồ sơ Coach:** slideshow 5 ảnh và khối Kết quả học viên không chỉnh được trong `CoachProfileEditScreen` (chỉ xem được phía User).
6. **Đánh giá khách chỉ seed cho `coach_01`.** Coach 02–06 hiện `Chưa có đánh giá.`
7. **Theme Switcher (L) không có trên main.** Code dở trên `archive/flutter-wip`. Prototype không cần tool debug này trừ khi Ruka muốn mang sang web.
8. **Ảnh journal / splash / icon app: CHƯA RÕ NGUỒN** — không bàn giao nhầm bản quyền. Avatar Coach: ảnh Ruka (thay Fluent Emoji).

## Mô hình Gói (Đảo ngược lần 2) — code hiện tại

**Gói theo từng Coach** (`MockPackage.coachId`). Không còn ví hệ thống.

- Không có `user_wallet_screen.dart`, `MockWalletPackage`, `mockSystemPackages`, tab Ví.
- Bottom bar User: Bản đồ · Nhật ký · **PT AI (FAB giữa)** · Cộng đồng · Lịch sử.
- Coach `C05` có 2 tab Dịch vụ / Gói; không xoá hết dịch vụ.
- Đặt lịch dùng gói: trừ **1 buổi**, không trừ tiền / không “trả thêm chênh lệch”.

Checklist A6-sửa-2 / B2-sửa-2 / B3-sửa-2 / E6-sửa vẫn `[ ]` nhưng **code trên main đã làm**. Chi tiết `06_DOI_CHIEU_CHECKLIST.md`.

## Điểm cần Ruka quyết định

1. **Tông primary light `#236488` vs seed `#00A0E0`** — giữ fromSeed trầm, hay ép hex sáng hơn trên prototype web?
2. **Light vs Dark** — prototype web mặc định mode nào? (App theo hệ thống; debug Theme Switcher không nằm trên main.)
3. **Copy “bãi xe”** trên màn quyền riêng tư — sửa thành gym/Coach trước khi dựng prototype, hay dựng đúng như code?
4. **Tên hiển thị** — `FlavorConfig` main: `'PSgy'` / `'PSgy Coach'`; checklist muốn **PSGymer User / PSGymer Coach**. WIP archive đã sửa native; **CẦN XÁC NHẬN** tên prototype.
5. **PT AI** — camera + cue giả theo timer, không nhận diện tư thế. Prototype web: giả camera hay placeholder?
6. **Ảnh journal seed** — giữ file hiện có (nguồn chưa rõ) hay thay stock có phép?
7. **Theme Switcher 4 style** — bỏ hẳn (đúng freeze) hay mang 4 hướng sang web cho Ruka chọn?

## File đang dở (Bước 0 — không trên main)

Nhánh `archive/flutter-wip`:

- `lib/core/theme/debug_theme_switcher.dart` + `lib/main.dart` (Theme Switcher L)
- `test/pilot_demo/debug_theme_screenshot_test.dart` + goldens + `screenshots/debug_theme/`
- `lib/core/config/flavor.dart`, `ios/`, `android/` (đổi tên app)
- `CHECKPOINT.md`, `CLAUDE.md`, `README.md`, `scripts/claude_runner.sh`
- `privacy_consent_screen.dart`, `app_error_view.dart`, `app_root_screen.dart` (chỉnh nhỏ)

H3 đợt 2 (ảnh + kết quả trên editor Coach) và H2 tinh chỉnh chip — **không có WIP uncommitted**; thiếu trong code main.

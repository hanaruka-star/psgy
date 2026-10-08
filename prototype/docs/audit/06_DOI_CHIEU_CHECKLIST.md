# 06 — Đối chiếu checklist

Checklist: `docs/handoff/PSgy-Reference-Build-Checklist.md`  
Code: tag `flutter-reference-final` (`245437c`).  
Trạng thái: **Đã làm** / **Làm 1 phần** / **Chưa làm** / **Có nhưng khác spec**.

## Đảo ngược Package lần 2

| Mục | Trạng thái | Bằng chứng |
|---|---|---|
| A6-sửa-2 khôi phục tab Gói Coach | **Đã làm** (checklist còn `[ ]`) | `coach_services_screen.dart` TabBar `Dịch vụ` \| `Gói`; FAB theo tab; chặn xoá dịch vụ cuối — SnackBar `Phải giữ ít nhất 1 dịch vụ để khách tập thử 1 buổi.` |
| B2-sửa-2 gỡ ví hệ thống, gói theo Coach | **Đã làm** | Không có `user_wallet_screen.dart` / `MockWalletPackage` / `mockSystemPackages`. `MockPackage.coachId` bắt buộc. U09 tab `Gói` + dialog `Xác nhận mua`. |
| B3-sửa-2 trừ theo số buổi | **Đã làm** | `booking_summary_screen.dart` radio `Dùng gói {name} ({remainingLabel})`; hoá đơn `Trừ 1 buổi gói`; `placeBooking` paymentMethod package. **Không** còn “trả thêm Y đ”. |
| E6-sửa bỏ tab Ví | **Đã làm** | `main_shell_screen.dart`: 4 tab Bản đồ / Nhật ký / Cộng đồng / Lịch sử + FAB PT AI giữa. Không Ví. |
| B2-content 3/5/10 buổi hệ thống | **Chưa làm / vô hiệu** | Catalog là gói **theo Coach** (10/20 buổi coach_01, 5 buổi Mai…). Không còn `mockSystemPackages`. |

**Kết luận mô hình:** Gói theo từng Coach, không ví hệ thống. Checklist tick sót.

## F

| Mục | Trạng thái | Bằng chứng |
|---|---|---|
| F1 Coach detail: Giới thiệu, đánh giá, bình luận | **Đã làm** | `coach_detail_screen.dart`: `Về tôi` + bio; `Đánh giá` + bar 5★–1★; `Bình luận khách hàng`; seed `mock_coach_reviews.dart` (8 review, **chỉ coach_01**). |
| F2 summary: Địa chỉ, Trao đổi, Mã giảm giá | **Làm 1 phần** | Card `Địa chỉ` hint `Nhập địa chỉ muốn tập`; `Trao đổi với Coach` → `UserChatScreen` inquiry. Card `Mã giảm giá` + `Áp dụng` **không validate, không trừ tiền**. Address/promo **không** ghi vào `placeBooking`. |

## D2-sửa / D4-sửa

| Mục | Trạng thái | Bằng chứng |
|---|---|---|
| D2-sửa ảnh bắt buộc, caption tuỳ chọn 100 ký tự | **Làm 1 phần** | `create_journal_post_screen.dart`: `Ảnh buổi tập` / `Bắt buộc · tối thiểu 1 ảnh`; caption max 100 `Còn N ký tự`; Đăng disable khi chưa ảnh; SnackBar `Vui lòng thêm ít nhất 1 ảnh`. Checklist chờ máy thật. |
| D4-sửa grid 3 màn | **Làm 1 phần** | `JournalPhotoGrid` 3 cột, chỉ thumbnail; `my_journal_screen` / `community_feed_screen` / `coach_student_journal_screen`. Seed 4 bài có `seed_0N.jpg`. Checklist chờ máy thật. |

## E UI

| Mục | Trạng thái | Bằng chứng |
|---|---|---|
| E1-sửa seed #00A0E0 / #9290FA | **Đã làm** (chờ ưng tông) | `app_theme.dart` dòng seed. Dump: primary light `#236488` ≠ seed. Coach đã cùng 1 `AppTheme`. |
| E3 map style + marker primary | **Làm 1 phần** | JSON light/dark; marker **không** còn primary — dùng `AppStatusColors.highlight` (E8). Dark+Coach map: CẦN XÁC NHẬN ảnh. |
| E3b Inter + squircle | **Đã làm** | `google_fonts` Inter, `AppShapes` smoothing 0.8, radius token. |
| E4 rà màu cứng | **Đã làm** | `AppStatusColors` + theme. Còn hex overlay camera PT AI (`#99000000`…) — màn sau E4. |
| E5 test Light/Dark máy | **Chưa làm** | Không có bộ ảnh xác nhận đủ 2 mode 2 flavor trong phạm vi audit. |
| E6 bottom bar + E6 mở rộng tab | **Có nhưng khác spec** | Spec gốc 5 tab gồm Ví. Code: **4 tab + FAB PT AI** (sau E6-sửa + K5). IndexedStack, không push 4 màn gốc. |
| E7 card không viền, blend, radiusMd | **Đã làm** | `cardTheme` elevation 0, `AppStatusColors.cardBackground`, shape `radiusMd` 16. |
| E8 tag/highlight/tab hex | **Đã làm** | `#EFF3FA` `#346B34` `#275F95` + dark suy ra trong `app_status_colors.dart`. Sao phẳng. |
| E9 logo header | **Đã làm** | `HeaderLogo` AppBar (ModeSwitcher / Coach Home). Không banner dưới AppBar. |
| E10 xoá splash ParkingLink | **Đã làm** | `LaunchScreen.storyboard` `splash-blank-vc`. Không `flutter_native_splash.yaml`. |

## H / J / K / L (không nằm section đánh số trong checklist file; có trong commit/prompt)

| Mục | Trạng thái | Bằng chứng |
|---|---|---|
| H2a–H2g field User coach-detail | **Đã làm** | Commit `625124d`. U09: lịch trống 7 ngày, địa điểm, kết quả, cert, mục tiêu/đối tượng/hình thức, gym fee tag, chính sách. Chip màu H2a trong `_ProfileTag`. |
| H3 editor hồ sơ Coach | **Làm 1 phần** | `coach_profile_edit_screen.dart` + comment Đợt 2: **chưa** slideshow 5 ảnh, **chưa** CRUD kết quả học viên. |
| J1 avatar chân dung | **Đã làm** | `assets/avatars/coach_0N.png`, `CoachAvatar`, `SOURCE.txt`. |
| K4 PT AI mock | **Đã làm** | U19–U22, `mock_ai_exercises.dart`. Cue theo timer, không pose. |
| K5 PT AI giữa bottom bar | **Đã làm** | `main_shell_screen.dart` `_PtAiNavButton` Key `nav_pt_ai`. |
| L Theme Switcher | **Chưa làm trên main** | File chỉ có trên `archive/flutter-wip`. |

## Mục đã tick sẵn (xác nhận nhanh)

A1–A9, B1–B7 (trừ mô hình ví đã đảo), D1, D3, D5–D10, C0 hướng Admin — **Đã làm** như checklist (Admin **Chưa làm** C1–C5).

C1–C5 Admin web: **Chưa làm**. `admin_web/` không có.

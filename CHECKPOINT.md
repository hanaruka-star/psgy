# Checkpoint — PSgy (GymPS)

> Cập nhật: 08/09/2026 — giai đoạn DEMO & UI POLISH

## Đã hoàn thành

### Nền tảng
- Clean Architecture 4-layer (Presentation → Domain → Data), Riverpod 2.0
- Flavor cấu hình: `user` / `coach` — chạy 2 app từ 1 codebase
- AppModeController: runtime toggle User/Coach (dev)
- Design system: `lib/core/theme/` (màu, typography, spacing)
- Firebase project `psgy-app` + firestore.rules local = nguồn thật

### UI/UX Reference (pilot_demo)
- `lib/features/pilot_demo/` — mock UI chuẩn 20 màn (User + Coach)
- Screenshots máy thật + golden test: `psgy_screenshots/`
- Walkthrough web (board + ảnh + docs cho team): `/psgy-walkthrough/` trên VPS

### Backend foundation
- Phone Auth OTP screen thật (User app tạm dùng MockPhoneAuthScreen — xem KNOWN ISSUES)
- Isar local cache + background sync pattern
- Geohash + Haversine cho tìm coach gần

## Giai đoạn hiện tại: DEMO & UI POLISH 🎨

- Mục tiêu: thêm tính năng demo ấn tượng + đổi style UI nhanh để demo cho khách hàng
- **LUỒNG LÀM VIỆC**: Claude/Hermes = Tech Lead (phân tích + sinh prompt) → Cursor = Junior Dev (code) → Claude review
- **Template prompt chuẩn**: xem `docs/cursor_prompt_templates.md` (Template A: thêm tính năng, B: đổi style, C: fix bug)

### Nguyên tắc giai đoạn demo
1. Mọi tính năng demo dùng mock data, đánh dấu `// DEMO DATA` — dễ xoá
2. Đổi style qua theme (`lib/core/theme/`), KHÔNG hardcode màu trong widget
3. Commit nhỏ theo `docs/git_workflow.md` — dễ rollback khi thử nghiệm
4. Chụp screenshot trước/sau mỗi lần đổi UI

## KNOWN ISSUES (cần fix khi vào backend thật)
- User app bypass Phone Auth thật bằng MockPhoneAuthScreen (permission-denied khi đọc users/{uid} — handoff B7)
- DEBT-009: FCM/APNs dev build delay
- DEBT-008: Isar migration manual

## Tiếp theo (gợi ý backlog — xem board walkthrough)
- Firebase per-flavor + Firestore rules
- Phone Auth OTP thật (2 app)
- Booking flow thật: đặt lịch → xác nhận → chat
- Chi tiết coach + dịch vụ & giá

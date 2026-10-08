# 04 — Mock data

Xuất từ code bằng `prototype/docs/audit/tools/dump_mocks_test.dart`. Chuỗi tiếng Việt giữ nguyên.

| File | Nội dung |
|---|---|
| `coaches.json` | 6 Coach đủ H1/H2 (bio, ảnh, dịch vụ+promo, gói, lịch offsetDays, địa điểm, kết quả, cert) |
| `services.json` | Dịch vụ gắn `coachId` + `promoLabel` |
| `packages.json` | Gói theo Coach (`coachId` bắt buộc) |
| `reviews.json` | 8 review — chỉ `coach_01` |
| `gyms.json` | 10 phòng, `gymSourceType` `hệ thống`/`thu thập`, lat/lng |
| `sample_users.json` | Phạm Minh Khoa, Ngô Thanh Hà, Đặng Quốc Việt |
| `journal_posts.json` / `journal_comments.json` | Seed cộng đồng |
| `badges.json` / `streak.json` | Catalog + quy tắc |
| `pt_ai_exercises.json` | 6 bài + cue theo giây |
| `coach_session_seed.json` | Profile Coach + bookings + messages + nhật ký học viên |
| `bookings.json` / `messages.json` | Tách từ seed Coach |
| `user_runtime.json` | Quy tắc sinh (DateTime.now(), OTP, welcome chat) |
| `README.json` | Mô hình gói theo Coach |

`weeklyAvailability.offsetDays`: `DateTime(now.year, now.month, now.day).add(Duration(days: offsetDays))` — không ghi ngày lịch cứng.

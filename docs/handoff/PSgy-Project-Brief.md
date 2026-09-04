# PSgy — Bối cảnh & Quyết định Kiến trúc

> **Tài liệu chuyển giao từ dự án ParkingLink.** Upload file này vào Project Knowledge của Project "PSgy" để Claude có đầy đủ ngữ cảnh ngay từ đầu, không cần giải thích lại.

---

## 1. PSgy là gì

App tìm phòng gym + đặt lịch với PT/HLV thể hình tại TP.HCM — mô hình tương tự app đặt dịch vụ tại nhà (ví dụ Glow) áp dụng cho ngành gym/PT.

**User app (v1, ưu tiên chính):**
- Tìm phòng gym trên bản đồ, xem giá cả
- Xem danh sách PT/Coach đang rảnh gần vị trí, ưu tiên theo khoảng cách
- Hồ sơ Coach: ảnh, thành tích, các dịch vụ + giá
- Đặt lịch → Coach xác nhận → chat trong app chốt giờ/địa điểm chính xác → thực hiện dịch vụ → khách đánh giá

**Coach app (v1, mô hình kiểu "app tài xế"):**
- Coach đăng nhập (Phone Auth)
- Tự bật/tắt "đang rảnh" + khung giờ rảnh hiện tại
- Nhận + xác nhận booking mới
- Chat với khách để chốt chi tiết

---

## 2. Vì sao clone từ ParkingLink

ParkingLink (Flutter + Firebase, quản lý bãi gửi xe HCMC) đã xây xong hạ tầng cốt lõi qua nhiều tháng phát triển, đặc biệt:

- **Phone Auth (OTP) trên iOS** — từng tốn rất nhiều công debug (3 nguyên nhân riêng biệt: thiếu APNs Auth Key, GoogleService-Info.plist thiếu REVERSED_CLIENT_ID, Info.plist thiếu CFBundleURLTypes khiến reCAPTCHA fallback callback không bao giờ trả về). Clone lại = tránh lặp lại toàn bộ quá trình debug này.
- Geohash + tìm kiếm theo khoảng cách (Haversine) đã hoạt động ổn định, có spec chốt rõ ràng
- Clean Architecture 4-layer đã được rèn qua nhiều đợt dọn nợ code (presentation/domain/data/core, dependency luôn hướng vào domain)
- CI, pattern test baseline, quy trình deploy Firestore rules an toàn đã có sẵn

---

## 3. Quyết định: Cách clone

**Đã chọn: Clone độc lập hoàn toàn** (KHÔNG phải package dùng chung 2 business).

```
- Repo git MỚI, tách khỏi lịch sử ParkingLink (gỡ .git cũ, init lại)
- Firebase project MỚI (không dùng chung parkinglink-v2)
- Bundle ID mới, Apple Developer app entry riêng
- KHÔNG chia sẻ code/package giữa 2 repo sau khi clone — 2 business
  độc lập hoàn toàn, sửa bug 1 bên không tự động lan sang bên kia
```

**Lý do chọn cách này thay vì package dùng chung:** 2 business khác nhau hoàn toàn (gửi xe vs gym/PT). Package dùng chung giữa 2 domain khác nhau là trừu tượng hoá sớm (premature abstraction) — thêm rủi ro vận hành (publish/version package) không cần thiết ở giai đoạn này. ParkingLink cũng đang giữa lúc tách monorepo riêng của chính nó (Phase 2, pl_core/pl_user/pl_staff) — không muốn 2 việc lớn chồng lên nhau.

> ⚠️ **QUAN TRỌNG: Việc xây PSgy KHÔNG ảnh hưởng gì đến dự án ParkingLink gốc.** ParkingLink giữ nguyên, tiếp tục phát triển riêng trong Project "ParkingLink" trên Claude — quay lại đó khi cần tiếp tục Phase 2 (Melos monorepo setup) hoặc việc khác của ParkingLink.

---

## 4. Kiến trúc PSgy — Giữ gì, bỏ gì

### ✅ GIỮ nguyên (copy trực tiếp từ ParkingLink)

| Thành phần | Lý do |
|---|---|
| Phone Auth (OTP) + toàn bộ setup iOS (APNs key, REVERSED_CLIENT_ID, CFBundleURLTypes) | Giá trị lớn nhất — tránh lặp lại nửa ngày debug |
| `geohash_utils.dart`, `geo_distance.dart` (Haversine) | Thuật toán thuần túy, không phụ thuộc domain |
| `currency_formatter.dart` (VND) | Cùng thị trường HCMC, cùng đơn vị tiền |
| Isar local cache + migration pattern | Pattern đã chứng minh chạy ổn định |
| Clean Architecture 4-layer (presentation/domain/data/core) | Convention, không phải code cụ thể |
| Firestore rules Golden Rule (local file = nguồn thật, echo trick deploy) | Quy trình an toàn đã dùng nhiều lần |
| CI (`flutter analyze`) + pattern viết test baseline | Lưới an toàn khi refactor |
| Google Maps + marker clustering | Pattern hiển thị bản đồ đã ổn |
| `AppErrorState` + error handling pattern | UI pattern chung |
| Realtime watch pattern (`watchSession` → đổi thành `watchBooking`) | Kiến trúc UseCase → Repository → Firestore đã chuẩn |

### 🗑️ BỎ hẳn

- `features/staff/`, `features/owner/` (Coach thay thế Staff, không có khái niệm Owner)
- `features/parking/` (thay bằng gym/coach/booking)
- QR check-in/check-out flow (không cần ở PSgy)
- Surveying lot + Apps Script pipeline
- Ý tưởng "Cloud Function bypass rules" — KHÔNG cần, vì Coach có tài khoản Auth thật nên Firestore rules chuẩn theo `auth.uid` là đủ

### 🆕 Multi-flavor mới: `user` + `coach` (thay vì `user` + `staff`)

Giữ pattern multi-flavor tạm thời để dễ test — đúng bài học từ ParkingLink: multi-flavor chỉ là bước gộp tạm, nếu sau này cần 2 app riêng trên App Store thì tách sau (không phải ngay từ đầu).

---

## 5. Domain Model mới

```
Gym {
  id, name, geohash, lat, lng, giá tham khảo, ảnh, tiện ích, giờ mở
  → cấu trúc mượn TRỰC TIẾP từ ParkingLot (geohash + map + giá)
}

Coach {
  id, name, ảnh, bio, thành tích, kinh nghiệm
  isAvailableNow: bool              ← Coach tự bật/tắt
  availableFrom / availableUntil: Timestamp?  ← khung giờ rảnh hiện tại
                                        (v1: KHÔNG làm calendar nhiều ngày)
  ratingAvg, ratingCount            ← cập nhật từ Review

  → Hồ sơ (ảnh, bio, thành tích): ADMIN quản lý/duyệt ở v1 (giữ chất
    lượng thương hiệu, format ảnh chuẩn).
  → Lịch rảnh: Coach TỰ cập nhật (bắt buộc, vì đổi liên tục trong ngày,
    admin không thể làm trung gian kịp).
}

Service {
  id, coachId, tên dịch vụ, giá, thời lượng
  → cấu trúc mượn từ VehicleType (1 entity cha có nhiều loại giá khác nhau)
}

Booking {
  id, userId, coachId, serviceId, status, totalFee
  expiresAt        ← auto-cancel nếu Coach không xác nhận kịp (~15 phút,
                      giống QrToken.isExpired pattern)
  agreedTime, agreedAddress, agreedLat/Lng
                    ← CHỐT CỨNG sau khi 2 bên thống nhất qua chat (nút
                      "Chốt lịch hẹn" riêng — không để hệ thống tự đọc
                      hiểu nội dung tin nhắn)

  State machine: pending → confirmed → completed / cancelled
}

Booking/messages/{msgId} {
  senderRole: "user" | "coach", text, sentAt
  → Firestore rules chuẩn: allow read/write nếu
    auth.uid == booking.userId HOẶC auth.uid == booking.coachId
  → Coach CÓ tài khoản Auth thật nên dùng rules chuẩn được, KHÔNG cần
    Cloud Function bypass
}

Review {
  id, bookingId, coachId, userId, rating, comment
  → cập nhật Coach.ratingAvg / ratingCount sau khi tạo, ảnh hưởng thứ
    tự ưu tiên hiển thị Coach
}
```

---

## 6. Flow hoàn chỉnh (đã thống nhất, tham khảo app Glow)

```
1. Browse: List Gym trên map (giá cả) + List Coach gần đó (ảnh, sao,
   khoảng cách, "sớm nhất X giờ", filter theo loại dịch vụ)
2. Xem hồ sơ Coach: ảnh, badge tin cậy, kinh nghiệm, dịch vụ + giá
3. Chọn dịch vụ → xác nhận đặt (thanh toán tiền mặt v1, giống ParkingLink)
4. Tạo Booking status=pending, hiện màn chờ + countdown auto-hủy
5. Coach (app riêng, đã login) thấy booking mới → Xác nhận / Từ chối
6. Xác nhận xong → mở Chat trong app (2 phía, realtime qua Firestore)
7. 2 bên chốt giờ + địa điểm chính xác qua chat → bấm "Chốt lịch hẹn"
8. Thực hiện dịch vụ → Booking status=completed
9. User đánh giá Coach (Review) → cập nhật điểm ưu tiên hiển thị
```

---

## 7. Việc mới cần setup (KHÔNG có sẵn trong ParkingLink)

- Firebase project mới hoàn toàn (Firestore, Auth, Storage, Hosting)
- Bundle ID mới (ví dụ `com.psgy.user`, `com.psgy.coach`) — cần chốt tên chính thức
- Apple Developer: app entry mới, **APNs key mới** (dù quy trình giống hệt lần trước, vẫn cần tạo key MỚI vì key cũ gắn với bundle ID ParkingLink)
- Repo git mới (GitHub riêng)

---

## 8. Quyết định còn TREO — cần bàn tiếp trong Project PSgy

- [ ] Tên bundle ID chính thức + tên hiển thị app
- [ ] Xác nhận lại: lịch rảnh Coach chỉ 1 khung giờ hiện tại (không multi-day calendar) — đã giả định, cần PO confirm hoặc điều chỉnh
- [ ] Phương thức thanh toán v1: giả định tiền mặt như ParkingLink — cần xác nhận
- [ ] Phân kỳ đề xuất: Milestone 1 (browse + book + xác nhận, CHƯA có chat) → Milestone 2 (thêm chat) — theo đúng cách làm MOD-12b-4 của ParkingLink (check-in trước, check-out sau, verify từng bước)
- [ ] Cách xử lý voucher/mã giảm giá (thấy trong ảnh tham khảo, chưa bàn kỹ)
- [ ] Clone `pubspec.yaml` từ ParkingLink rồi dọn bớt dependency không cần (ví dụ nếu không cần Telegram bot pipeline)

---

## 9. Ghi chú làm việc

- Team: Ruka (Product Owner) + Claude (Tech Lead, không viết code) + Cursor (Implementation) — giữ nguyên mô hình đã chạy tốt ở ParkingLink
- Ngôn ngữ làm việc: tiếng Việt
- Phong cách: hướng dẫn ngắn gọn, có ưu/nhược điểm rõ ràng, không áp đặt 1 chiều
- Dự án ParkingLink gốc: xem lại Project "ParkingLink" trên Claude khi cần tiếp tục Phase 2 hoặc việc khác của ParkingLink — KHÔNG lẫn vào Project này

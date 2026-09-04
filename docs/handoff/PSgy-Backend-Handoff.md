# PSgy — Handoff kỹ thuật cho đội Dev (Backend)

> Trạng thái tại 2026-09-04. Người soạn: Claude (Tech Lead giai đoạn tham khảo, không viết code). Đội dev thật tiếp nhận từ đây trở đi.

## 0. Cách đọc tài liệu này

Đây là **bản tham khảo hoạt động thật** (functional reference), không phải code production. Toàn bộ 2 app (User + Coach) đã build bằng Flutter dưới `lib/features/pilot_demo/`, chạy đúng luồng/UI/trạng thái nhưng **dữ liệu 100% mock** (in-memory, `ChangeNotifier`, không persist, không Firestore thật). Việc của đội dev: **giữ nguyên UI/UX đang có, thay lớp dữ liệu mock bằng backend thật** (Firebase — Firestore/Auth/Storage/Functions).

3 tài liệu nguồn đầy đủ, đọc thêm khi cần:

| Tài liệu | Nội dung |
|---|---|
| `PSgy-Project-Brief.md` | Bối cảnh business, mọi quyết định kiến trúc/domain model đã chốt, lý do đằng sau từng quyết định (kể cả các lần đảo ngược) |
| `PSgy-Reference-Build-Checklist.md` | Nhật ký build từng tính năng, tick `[x]`/`[ ]`, ngày chốt, ai xác nhận — nguồn "sự thật" chi tiết nhất nếu tài liệu này thiếu gì |
| `PSgy-Clone-Checklist.md` | Quy trình clone kỹ thuật ban đầu từ ParkingLink (bundle ID, icon, Phone Auth iOS setup, Firestore rules Golden Rule...) — tham khảo khi setup Firebase/iOS project mới |
| `PSgy-Codebase-Inventory.md` | Cursor xuất trực tiếp từ code thật — tên class/field/method THẬT (không phải suy đoán), đối chiếu bắt buộc trước khi code backend đụng vào field nào |

**Nguyên tắc quan trọng nhất:** UI/UX hiện tại được xem là **bản duyệt cuối** cho bản tham khảo này. Đội dev **không cần** và **không nên** thiết kế lại màn hình — chỉ cần làm cho dữ liệu/hành vi phía sau là thật thay vì mock. Nếu phát hiện UI có vấn đề rõ ràng khi lên backend thật (vd 1 field mock không đủ để model thật hoạt động), báo lại để bàn — không tự ý đổi.

---

## 1. Tổng quan hệ thống

- **App tìm phòng gym + đặt lịch PT/Coach tại TP.HCM** — mô hình marketplace phi tập trung (nhiều Coach/gym độc lập), tương tự app đặt dịch vụ tại nhà.
- **3 app Flutter độc lập:**
  - **User app** — tên hiển thị "PSGymer User" (bundle `com.psgy.user`)
  - **Coach app** — tên hiển thị "PSGymer Coach" (bundle `com.psgy.coach`)
  - **Admin tool** — **CHƯA build**, hướng đã chốt: Flutter Web, project độc lập trong `admin_web/` (xem mục 7)
- User + Coach hiện là **2 flavor của cùng 1 codebase Flutter** (`lib/main.dart`/`MaterialApp` dùng chung, entry point khác nhau theo flavor) — pattern tạm thời để dễ test, có thể tách app riêng sau nếu cần lên 2 listing App Store khác nhau.
- **Clean Architecture 4 lớp** (presentation/domain/data/core) kế thừa từ ParkingLink — đội dev đọc code hiểu được, tiếp tục convention này khi thay mock bằng backend thật (không viết ẩu).
- **Codebase là clone độc lập từ ParkingLink** (app quản lý bãi gửi xe cùng công ty) — repo Git mới, Firebase project mới, không chia sẻ code sau khi clone. Lý do clone: tái dùng hạ tầng đã chứng minh ổn định, tránh lặp lại debug tốn công (đặc biệt Phone Auth iOS).

**Giữ nguyên từ ParkingLink (đã hoạt động, dùng lại được):**

| Thành phần | Ghi chú |
|---|---|
| Phone Auth (OTP) + setup iOS đầy đủ (APNs key, `REVERSED_CLIENT_ID`, `CFBundleURLTypes`) | Coach app đang dùng thật. User app hiện tạm bypass bằng OTP giả lập cho bản demo (xem mục 6) — code Auth thật vẫn còn nguyên, chỉ cần trỏ lại |
| `geohash_utils.dart`, `geo_distance.dart` (Haversine) | Cần MỞ RỘNG cho bài toán tìm Gym gần điểm giữa Coach–User (mục 4) |
| `currency_formatter.dart` (VND) | Dùng lại nguyên |
| Isar local cache + migration pattern | Dùng lại nguyên |
| Firestore rules Golden Rule (local file = nguồn thật, echo trick deploy) | Quy trình deploy rules an toàn đã dùng nhiều lần — theo đúng pattern này khi viết rules PSgy |
| CI (`flutter analyze`) + baseline test pattern | Giữ nguyên |
| Google Maps + marker clustering | Dùng lại cho marker Coach realtime |
| `AppErrorState` + error handling pattern | Dùng lại nguyên |
| Realtime watch pattern (`watchSession` → `watchBooking`) | Kiến trúc UseCase→Repository→Firestore đã chuẩn, áp thẳng cho Booking + live location Coach |

**Setup mới cần làm (không có sẵn từ ParkingLink):** Firebase project mới hoàn toàn (Firestore/Auth/Storage/Functions/Hosting), Apple Developer app entry mới + APNs key mới (bundle ID khác ParkingLink nên không dùng lại key cũ được), repo Git mới.

---

## 2. Kiến trúc mock hiện tại — vì sao và cách thay thế

Toàn bộ state hiện nằm trong 2 class `ChangeNotifier` độc lập, **không persist, không sync**:

- **`MockUserSession`** (User app) — chứa `profile`, `bookings`, `journalPosts`, `journalComments`, `userStreak`, `userBadges`, tin nhắn chat... Toàn bộ method (`placeBooking`, `updateBookingStatus`, `toggleJournalLike`, `purchasePackage`...) là nơi business logic mock đang nằm.
- **`MockCoachSession`** (Coach app) — chứa `coachProfile`, `bookingRequests`, `services`, `packages` (sau khi khôi phục theo mô hình gốc), `studentJournalPosts`, tin nhắn chat phía Coach...

**Điểm quan trọng nhất cho đội dev:** 2 session này **hoàn toàn độc lập, không nói chuyện với nhau** — vd User đặt lịch bên app User không tự động hiện bên app Coach (vì không có backend thật kết nối). Mọi luồng "2 chiều" (booking, chat) hiện chỉ minh hoạ ĐÚNG UI/UX 1 phía, chưa phải luồng nối thật xuyên app. Đây là việc lớn nhất backend thật phải giải quyết: **1 Firestore project dùng chung, cả 2 app đọc/ghi cùng collection, sync qua Firestore realtime listener** thay vì 2 mock session riêng.

**Xác nhận từ Cursor (đọc code thật, `PSgy-Codebase-Inventory.md`) — mức độ tách rời còn sâu hơn dự tính:** ngay cả khái niệm **Coach cũng đang có 2 nguồn KHÔNG trùng nhau** trong cùng bản mock:
- `MockCoach` (`models/mock_coach.dart`) — catalog phía **User app** dùng cho Map/List/Coach Detail, có `bio`, `services`, `packages` riêng.
- `MockCoachProfile` (`models/mock_coach_profile.dart`) — hồ sơ phía **Coach app** (`MockCoachSession.profile`), có `bio` riêng (ngắn hơn, seed khác), không có `services`/`packages` (2 field đó nằm riêng trên `MockCoachSession.services`/`.packages`).

Hai nguồn này **không sync với nhau ngay trong bản mock** — sửa profile bên Coach app không phản ánh sang catalog bên User app. Đây không phải lỗi cần Cursor sửa (đúng chủ đích bản demo, tách UI cho đơn giản) — nhưng backend thật **bắt buộc phải gộp lại thành 1 document `Coach` duy nhất** trên Firestore, cả 2 app đọc/ghi cùng 1 nguồn. Tương tự, Journal cũng có 2 nguồn tách biệt: `MockUserSession.journalPosts` (User tự đăng) và `MockCoachSession.studentJournalPosts` (seed riêng phía Coach, không lọc từ nguồn User) — backend cần 1 collection `JournalPost` chung, Coach app query lọc theo `coachId`/`privacy` thay vì đọc seed riêng.

**Cách tiếp cận khuyến nghị:** giữ đúng chữ ký (interface) các hàm mock đang gọi từ UI (`placeBooking`, `updateBookingStatus`, `purchasePackage`...), viết lại phần triển khai bên trong bằng UseCase → Repository → Firestore thật (đúng Clean Architecture đã có), để việc thay thế không đòi hỏi sửa lại UI/widget.

---

## 3. Domain Model — bản chốt mới nhất (đã hợp nhất mọi lần sửa)

⚠️ Model `Package` mô tả trong `PSgy-Project-Brief.md` mục 5/10a (ví hệ thống dùng chung mọi Coach) **đã bị đảo ngược lần 2 (2026-09-02), không còn hiệu lực** — dùng đúng bản dưới đây.

### Gym
```
Gym { id, name, lat, lng, geohash, giá tham khảo, ảnh, tiện ích, giờ mở, status: "inSystem" | "market" }
```
Mock hiện tại (`MockGym`, phía Admin — C4, **chưa build**) chỉ minh hoạ khái niệm, chưa có nguồn dữ liệu gym thị trường thật (Google Places API hoặc tương đương — việc đội dev nối sau).

### Coach
```
Coach {
  id, name, avatarUrl, bio (MỚI — mục F1, đoạn giới thiệu Coach tự viết),
  isAvailableNow: bool,       ← Coach tự bật/tắt TAY, NHƯNG hệ thống server
                                  phải tự động override false khi có Booking
                                  confirmed, true lại khi completed (mục 4)
  lat, lng, geohash,          ← vị trí HIỆN TẠI, cập nhật realtime khi rảnh
  availableFrom, availableUntil: Timestamp?,   ← v1 chỉ 1 khung giờ, KHÔNG
                                  cần multi-day calendar (quyết định có chủ đích)
  ratingAvg, ratingCount,     ← tính từ Review thật (mục 3 — CoachReview)
  yearsExperience,
  isSystemPromoted: bool,     ← Admin gắn cờ tay, không phải thuật toán
  approvalStatus: "pending" | "approved" | "rejected"
}
```
Hồ sơ (ảnh, bio, thành tích, `isSystemPromoted`) do **Admin quản lý/duyệt**; lịch rảnh + vị trí do **Coach tự cập nhật** (đổi liên tục trong ngày).

### Service (dịch vụ lẻ, 1 buổi)
```
Service { id, coachId, tên, giá, thời lượng }
```
Giá riêng từng Coach tự đặt. **Ràng buộc MỚI (F1/A6-sửa-2): mỗi Coach luôn phải có ≥1 Service** — không cho xoá hết, đảm bảo User luôn có lựa chọn "tập thử 1 buổi". Enforce ở cả UI (đã làm) lẫn backend rule (đội dev thêm validate khi xoá).

### Package (gói nhiều buổi — mô hình ĐÃ KHÔI PHỤC về bản gốc, chốt 2026-09-02)
```
Package { id, coachId, name, sessionCount: int, totalPriceVnd: int, description }
```
- **CÓ `coachId`** — Coach tự tạo/sửa/xoá, chỉ dùng được với đúng Coach đó tạo ra nó.
- **KHÔNG có** ví/wallet dùng chéo Coach, không có `UserWalletPackage`, không có màn "Ví" riêng.

**Tên thật trong code (xác nhận qua `PSgy-Codebase-Inventory.md`, không cần đoán nữa):**
```
MockPurchasedPackage {       ← "gói User đã mua của 1 Coach cụ thể"
  id, packageId,             ← packageId = id của MockPackage gốc (catalog)
  coachId, packageName,      ← copy tên lúc mua, không cần join lại Package
  sessionCount: int,         ← tổng buổi lúc mua
  remainingSessions: int,    ← còn lại, giảm dần qua Booking
  purchasedAt: DateTime
}
```
Đặt lịch dùng Gói: chọn `paymentMethod = "package"` (enum `MockPaymentMethod { cash, package }`) → trừ **1 buổi** khỏi `remainingSessions` của đúng `MockPurchasedPackage`, không liên quan giá dịch vụ thật (khác hẳn mô hình ví hệ thống đã bị huỷ ở mục 10a brief). Backend đặt tên collection/class thế nào cũng được, miễn giữ đúng quan hệ `userId → nhiều MockPurchasedPackage → mỗi cái gắn đúng 1 coachId + 1 packageId gốc`.

### Booking
```
Booking {
  id, userId, coachId, serviceId,
  status: pending → confirmed → inProgress → awaitingUserConfirmation
          → completed / cancelled,
  totalFee,
  expiresAt,                 ← auto-cancel nếu Coach không xác nhận (~15 phút)
  paymentMethod: "cash" | "package",
  purchasedPackageId?,        ← tên field THẬT (xác nhận qua inventory) — trỏ
                                 đúng `MockPurchasedPackage.id` đang dùng
                                 (KHÔNG phải id của Package gốc/catalog),
                                 chỉ có khi paymentMethod == "package"
  purchasedPackageName?,      ← copy tên lúc đặt, để hiển thị không cần join lại

  locationType: "userLocation" | "systemGym",  ← chốt lúc đặt lịch, xem mục 4
  agreedTime, agreedAddress, agreedLat, agreedLng,
  gymId?,                    ← chỉ có khi locationType == "systemGym"

  coachStartedAt: Timestamp?,        ← Coach bấm "Bắt đầu buổi tập"
  coachMarkedDoneAt: Timestamp?,     ← Coach bấm "Hoàn thành dịch vụ"
  userConfirmedAt: Timestamp?,       ← User xác nhận + rating (tạo Review cùng lúc)
  completionTimeoutAt: Timestamp?,   ← = coachMarkedDoneAt + 10 phút

  cancelledBy: "user" | "coach" | "system"?,
  cancelReason: String?      ← vd "no_show"
}

Booking/messages/{msgId} { senderRole: "user" | "coach", text, sentAt }
```
> Field `topUpAmountVnd` xuất hiện trong `PSgy-Project-Brief.md` mục 5 gắn với mô hình ví hệ thống cũ — **đã lỗi thời**, không dùng trong mô hình Package hiện tại (mục 10b).

**F2 đã build xong (xác nhận qua inventory) — chat "tiền booking" theo `coachId`, KHÔNG gắn `bookingId`:** dùng để User trao đổi địa chỉ/lịch tập với Coach trước khi đặt lịch chính thức. Tên thật trong code: `MockUserSession.coachInquiryMessages` — `Map<String, List<MockMessage>>` với **key = `coachId`** (tách biệt hoàn toàn với `messages`, map theo `bookingId`, dùng cho chat sau `confirmed`). `user_chat_screen.dart` (`UserChatScreen`) tự chuyển chế độ dựa trên có `inquiryCoachId` hay `bookingId` được truyền vào.

Đề xuất schema Firestore (đội dev đặt tên khác cũng được, miễn giữ đúng 2 luồng tách biệt):
```
CoachInquiryThread { id (= "{userId}_{coachId}"), userId, coachId }
CoachInquiryThread/messages/{msgId} { senderRole, text, sentAt }
```

### Review / đánh giá Coach — ⚠️ CẦN HỢP NHẤT, đọc kỹ

Có **2 khái niệm review đang tồn tại riêng lẻ trong bản mock**, cần hợp nhất thành 1 model thật khi lên backend:

1. **Review thật theo brief gốc** (mục 5) — tạo khi User bấm "Xác nhận đã nhận dịch vụ" lúc `userConfirmedAt`, gắn với đúng `bookingId`, cập nhật `Coach.ratingAvg`/`ratingCount`.
2. **`MockCoachReview`** (F1, đã build xong — `models/mock_coach_review.dart`) — seed **độc lập, không gắn booking/user thật** (chỉ có `reviewerName` dạng text, không có `userId`/`bookingId`), sống hoàn toàn ngoài 2 session, không qua `MockUserSession`/`MockCoachSession`. Chỉ để demo UI card "% phân bổ theo sao" + danh sách bình luận trên `coach_detail_screen.dart` trước khi có đủ review thật. Field thật: `id, coachId, reviewerName, rating (1-5), comment, date`. Seed 8 review, toàn bộ `coachId: 'coach_01'`, trong `data/mock_coach_reviews.dart`.

**Backend thật chỉ cần 1 model duy nhất** (dùng đúng cấu trúc mục 5 — gắn `bookingId` + `userId` thật), card "% phân bổ theo sao" + danh sách bình luận trên Coach Detail tính trực tiếp từ collection Review thật theo `coachId`, không cần bảng riêng như bản mock F1.
```
Review { id, bookingId, coachId, userId, rating: int (1-5), comment, createdAt }
```
**Tham khảo cách tính % phân bổ đã đúng trong mock** (`MockCoachReviewStats`, hàm `reviewStatsFor()`): `count` (tổng số), `average` (điểm trung bình), `countsByStar: List<int>` (index 1-5 = số review mỗi mức sao), có sẵn `percentOf(star)` và `summaryLabel` (vd "4.1/5 · 8 đánh giá") — backend port đúng công thức này, chỉ đổi nguồn dữ liệu từ list mock sang Firestore query.
Nếu hết 10 phút timeout mà User không xác nhận, Booking vẫn `completed` nhưng KHÔNG có Review — User có thể đánh giá trễ sau (không bắt buộc).

### Journal / Social (Nhật ký + Streak/Badge)
```
JournalPost {
  id, userId, bookingId, coachId, coachName, serviceName, durationMinutes,
  caption: String (tối đa 100 ký tự, TUỲ CHỌN — đã đảo ngược D2-sửa),
  mediaUrl: String? (⚠️ field THẬT là SỐ ÍT — bắt buộc chọn ≥1 ảnh ở bước
    tạo bài (validate UI, chặn nút Đăng), nhưng model chỉ lưu 1 URL, không
    phải mảng nhiều ảnh — nếu backend muốn hỗ trợ nhiều ảnh/bài thật sự,
    đây là chỗ cần đổi type thành List<String>, không phải giữ nguyên),
  privacy: "private" | "coachOnly" | "public",
  createdAt, likeUserIds: List<String>, commentCount: int, reported: bool
}
JournalComment { id, postId, authorId, authorName, text, createdAt }
UserStreak { userId, currentStreak: int, longestStreak: int, lastCompletedDate }
Badge { id, name, description, iconAsset }
UserBadge { userId, badgeId, earnedAt }
```
Lưu ý: caption/ảnh đã ĐẢO NGƯỢC so với bản đầu (D2 gốc: ảnh tuỳ chọn/caption bắt buộc) — chốt cuối 2026-08-31: **ảnh bắt buộc, caption tuỳ chọn**.

### SupportTicket (Admin — chưa build)
```
SupportTicket { id, fromRole: "user" | "coach", fromId, subject, message, status: "open" | "resolved", createdAt }
```

### UserProfile
```
UserProfile { id (= uid), phone, name, avatarUrl, createdAt }
```

---

## 4. Business rules / state machine cần server enforce thật

Bản mock hiện dùng **`Timer`/`setState` phía client** để giả lập auto-advance (vd "Theo dõi Booking" tự chuyển mốc mỗi 3 giây) — đây **chỉ để demo UI**, KHÔNG phải logic thật. Backend cần thay bằng Cloud Functions/trigger thật.

1. **Booking state machine đầy đủ:**
   `pending →(Coach xác nhận)→ confirmed →(Coach bấm "Bắt đầu")→ inProgress →(Coach bấm "Hoàn thành")→ awaitingUserConfirmation →(User xác nhận + rating, trong 10 phút)→ completed`, hoặc `cancelled` ở các bước đầu.
   - `pending` tự `cancelled` nếu Coach không xác nhận trong ~15 phút (dùng Cloud Function scheduled hoặc `expiresAt` + client check, tương tự pattern `QrToken.isExpired` cũ bên ParkingLink).
   - `awaitingUserConfirmation` tự chuyển `completed` (không kèm Review) nếu User không phản hồi trong 10 phút — lý do chốt: giải phóng Coach khỏi trạng thái "bận" nhanh nhất, KHÔNG phải để bảo vệ tính toàn vẹn Review.
2. **`Coach.isAvailableNow` tự động theo trạng thái Booking** (không chỉ toggle tay): server tự set `false` khi 1 Booking của Coach đó chuyển `confirmed`, tự set `true` lại khi `completed`. User vẫn đặt lịch được với Coach đang "bận" (đặt trước, vào thẳng hồ sơ Coach) — filter "đang rảnh" trên Browse chỉ ảnh hưởng thứ tự hiển thị, không chặn đặt lịch.
3. **Xếp hạng Coach trên Browse:** nhóm `isSystemPromoted = true` lên trước; trong từng nhóm xếp theo khoảng cách + rating + `yearsExperience` — **trọng số cụ thể chưa chốt**, để tinh chỉnh sau khi có dữ liệu thật (bắt đầu đơn giản: sort khoảng cách trước, rating tie-break).
4. **Xác định địa điểm lúc đặt lịch** (2 nhánh, chốt ngay lúc đặt, không cần chờ Chat):
   - Nhánh A — User đã có gym: share vị trí chính xác cho Coach **chỉ sau khi Coach đã Xác nhận** (không share trước khi nhận job, tránh lộ vị trí).
   - Nhánh B — User chưa có gym: gợi ý Gym có sẵn trong hệ thống gần **điểm giữa** Coach–User, bán kính mặc định **7km**; không có gym trong bán kính → mở rộng dần hoặc báo không tìm được, đề xuất chọn nhánh A. Cần mở rộng `geo_distance.dart` để tính điểm gần với 2 toạ độ.
5. **Package/Gói:** đặt lịch `paymentMethod = "package"` phải chọn đúng Gói của đúng Coach đang đặt, chặn nếu `remainingSessions <= 0`, trừ đúng 1 khi Booking tạo thành công (hoặc khi hoàn thành — đội dev quyết định trừ lúc đặt hay lúc hoàn thành, bản mock hiện trừ lúc đặt).
6. **Streak** — tăng khi 1 Booking chuyển `completed` trong ngày đó, KHÔNG bắt buộc đăng Journal mới tính. Logic chính xác cần port từ mock: lần đầu/đứt chuỗi → reset về 1; booking completed hôm qua đã có streak → +1 hôm nay; đã tính trong cùng ngày rồi → giữ nguyên (không cộng trùng nếu 1 ngày completed nhiều booking). Badge tự gắn khi đạt mốc (`badge_first_session`, `badge_streak_3`, `badge_streak_7`).
7. **Service:** chặn xoá Service cuối cùng của 1 Coach (luôn phải còn ≥1).

---

## 5. Màn hình theo từng app — mock hiện tại vs. việc backend cần làm

### User app

| Màn hình (file) | Mock hiện tại | Backend cần làm |
|---|---|---|
| `MockPhoneAuthScreen` | OTP giả lập, không gọi Firebase Auth thật (bypass tạm vì lỗi `permission-denied` từ code Firestore cũ không liên quan) | Trỏ lại `PhoneAuthScreen` thật (đã có sẵn, đã verify hoạt động ở Checkpoint 2) — xử lý dứt điểm nguồn gây lỗi permission cũ trước khi bật lại |
| `UserProfileSetupScreen` | Tạo `UserProfile` local, không persist | Ghi Firestore thật sau OTP thành công |
| `PilotMapScreen` (Map/Browse) | Marker Coach tĩnh từ seed, không realtime | Query Coach theo geohash + `isAvailableNow = true`, listener realtime, xếp hạng theo mục 4.3 |
| `coach_detail_screen.dart` | Header → card Giới thiệu (`Coach.bio`) → tab Dịch vụ/Gói → card đánh giá % sao → bình luận → Tiếp tục (**F1, đang chờ Cursor build**) | Đọc `Coach`, `Service`, `Package` thật theo `coachId`; card đánh giá tính từ collection `Review` thật (xem mục 3, không cần bảng review mock riêng) |
| `booking_summary_screen.dart` | Card Địa chỉ + nút Trao đổi Coach → thanh toán (tiền mặt/Gói) → card Mã giảm giá (UI only) → hoá đơn → Đặt lịch (**F2, đang chờ Cursor build**) | Tạo `Booking` thật với đầy đủ field mục 3; mã giảm giá CHƯA cần logic thật (xem mục 7 — voucher để sau) |
| `BookingPendingScreen` ("Theo dõi Booking") | Auto-advance mock bằng `Timer` 3 giây | Nghe Firestore realtime đúng field `status`/các mốc timestamp; bỏ hẳn timer giả |
| `user_booking_history_screen.dart` | Đọc từ `MockUserSession.bookings` | Query Firestore theo `userId`, mới nhất trước |
| `user_chat_screen.dart` | 2 chế độ: chat theo `bookingId` (từ `confirmed` trở đi) + chat theo `coachId` (pre-booking, MỚI ở F2) | Firestore rules: đọc/ghi nếu `auth.uid == booking.userId/coachId` (theo booking) hoặc `auth.uid` khớp 1 trong 2 phía `CoachInquiryThread` |
| `my_journal_screen.dart`, `community_feed_screen.dart` | Grid ảnh (widget `JournalPhotoGrid` dùng chung), đọc mock seed | Query `JournalPost` theo `privacy`/`userId` tương ứng |
| `journal_post_detail_screen.dart` | Like/comment/report local | Ghi Firestore, cập nhật `likeUserIds`/`commentCount` |
| `create_journal_post_screen.dart` | Ảnh bắt buộc (≥1), caption tuỳ chọn ≤100 ký tự | Upload ảnh lên Storage thật, tạo `JournalPost`, trigger tính lại Streak/Badge |

Đã **bỏ hẳn** (theo revert 2026-09-02): `user_wallet_screen.dart`, mọi UI/logic liên quan ví hệ thống — không cần backend đụng tới.

### Coach app

| Màn hình (file) | Mock hiện tại | Backend cần làm |
|---|---|---|
| Đăng nhập | Phone OTP thật (đã dùng đúng hạ tầng Auth) | Giữ nguyên, không đổi |
| `CoachHomeScreen` (dashboard) | Toggle rảnh tay + khung giờ, vị trí xoay tay giữa vài điểm mẫu | Ghi `Coach.isAvailableNow`/`lat`/`lng`/`availableFrom`/`availableUntil` thật, có auto-override theo mục 4.2 |
| Chi tiết Booking request | Xác nhận/Từ chối cập nhật mock local | Cập nhật `Booking.status` thật qua Firestore transaction |
| Active Booking screen | Chip trạng thái, "Bắt đầu"/"Hoàn thành", báo khách không đến | Ghi `coachStartedAt`/`coachMarkedDoneAt`/`cancelReason` thật |
| Chat Coach | Tin nhắn local | Cùng `Booking/messages` collection với phía User |
| `coach_services_screen.dart` | 2 tab Dịch vụ/Gói (khôi phục A6-sửa-2, **đang chờ Cursor build**), validate ≥1 Dịch vụ | CRUD `Service`/`Package` thật theo `coachId`, enforce validate ≥1 Service ở server rule luôn (không chỉ chặn ở UI) |
| `coach_student_journal_screen.dart` | Đọc-only, seed riêng `MockCoachSession`, grid ảnh | Query `JournalPost` theo `privacy in [coachOnly, public]` VÀ liên quan buổi tập Coach đó dạy |

### Admin tool (chưa build — kiến trúc đã chốt)

- **Flutter Web**, project độc lập `admin_web/` trong repo `psgy`, không gộp package với app mobile.
- **C1** Danh sách Coach chờ duyệt (`approvalStatus = pending`) → Duyệt/Từ chối.
- **C2** Danh sách Support Ticket → xem, trả lời (mock trả lời là đủ ở bản tham khảo, backend thật cân nhắc sau).
- **C3** Đặt tên "PSGymer Admin".
- **C4** Bản đồ tối giản gym thị trường (`market`) vs gym trong hệ thống (`inSystem`) — dữ liệu gym thị trường **thuần mock**, chưa nối nguồn thật (Google Places API hoặc tương đương — việc đội dev khi cần).
- **C5** Toggle `Coach.isPriority` — ảnh hưởng thứ tự hiển thị User app. **Giới hạn đã biết:** bản tham khảo demo 3 app tách rời không backend chung nên chưa test được đúng luồng real-time xuyên app — backend thật nối `isPriority` qua Firestore là đủ, hành vi sort đã đúng thiết kế ở mục 4.3.
- ⚠️ **Lưu ý quan trọng:** `PSgy-Project-Brief.md` mục 10 có nhắc Admin cần "quản lý danh mục Package hệ thống bán" — mục này **đã lỗi thời** sau khi Package quay về mô hình do Coach tự tạo (mục 10b) — Admin **không cần** CRUD Package nữa, bỏ qua chi tiết đó.

---

## 6. Hạ tầng cần setup mới

**Xác nhận qua `pubspec.yaml` thật (inventory Cursor):** toàn bộ package Firebase cần dùng **đã có sẵn trong dependency** — `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`, `firebase_messaging`, `firebase_crashlytics`, `firebase_performance` (kế thừa từ ParkingLink lúc clone). Việc còn lại KHÔNG phải cài thêm package, mà là: (1) tạo Firebase project PSgy mới + kết nối `GoogleService-Info.plist`/`google-services.json` đúng project mới, (2) viết code thật gọi các package này (hiện `pilot_demo` chỉ dùng trực tiếp `image_picker`, `google_maps_flutter`, `intl` — chưa gọi `cloud_firestore`/`firebase_auth` ở tầng mock).

- **Firebase project mới** (Firestore, Auth, Storage, Functions, Hosting cho Admin Web sau này) — độc lập hoàn toàn khỏi Firebase ParkingLink.
- **Firestore rules** theo đúng Golden Rule pattern đã dùng ở ParkingLink (local file = nguồn thật, deploy qua echo trick) — ví dụ rule Chat: `allow read/write if auth.uid == booking.userId || auth.uid == booking.coachId` (Coach có Auth thật nên dùng rules chuẩn, không cần Cloud Function bypass).
- **Cloud Functions** cần thêm mới (KHÔNG có trong ParkingLink): timeout tự động cho `pending→cancelled` (~15 phút) và `awaitingUserConfirmation→completed` (10 phút); trigger cập nhật `Coach.ratingAvg/ratingCount` khi có Review mới; trigger tính lại Streak khi Booking chuyển `completed`.
- **Push notification (FCM)** — CHƯA có trong bản mock, cần cho: booking mới (Coach), Coach xác nhận/từ chối (User), tin nhắn chat mới, nhắc User xác nhận hoàn thành trước khi hết 10 phút.
- **Storage** cho ảnh: avatar Coach/User, ảnh Journal post (hiện là asset mock/placeholder trong bản demo).
- **Kích hoạt lại Phone Auth thật cho User app** — hiện đang bypass bằng `MockPhoneAuthScreen` vì lỗi `permission-denied` từ code cũ (đọc `users/{uid}` kiểu ParkingLink, không thuộc phạm vi `pilot_demo`) khi chạy standalone với tài khoản Auth cũ còn sót trên máy test. Cần dọn/thay hẳn code đọc profile cũ đó bằng luồng `UserProfile` thật (mục 3) trước khi bật lại `PhoneAuthScreen` thật.
- **Live tracking vị trí Coach** (khi đang di chuyển đến) — khả thi kỹ thuật, dùng lại field `Coach.lat/lng` đã có, chỉ đổi tần suất cập nhật lúc `status = confirmed`. Bắt đầu ở mức "foreground only, cập nhật thưa (15-30s hoặc di chuyển >100m)" — background tracking liên tục kiểu Uber để sau khi có traffic thật đánh giá đáng đầu tư hay không (tốn quyền vị trí nền iOS + chi phí Firestore write + pin).

---

## 7. Ngoài phạm vi bản tham khảo này (chưa cần backend lo ngay)

- **Admin tool** — kiến trúc đã chốt (mục 5, phần Admin) nhưng **chưa có 1 dòng code nào**, làm sau khi 2 app User/Coach ổn định.
- **Voucher/mã giảm giá thật** — chốt để sau (mục 8c brief), không thuộc bản tham khảo. Card "Mã giảm giá" ở `booking_summary_screen.dart` (F2) hiện **chỉ là UI**, bấm Áp dụng không trừ tiền thật. Khi làm thật, voucher gắn campaign cụ thể (không phải mã tự phát hành đại trà), cần thêm field `voucherId`/`discountAmount` trên `Booking`.
- **Backlog tinh chỉnh UI (mục E trong checklist)** — tạm dừng theo quyết định Ruka, không chặn tiến độ: tông màu Coach app chưa rebuild theo seed mới, dark mode bản đồ Coach app chưa test, mở rộng bottom bar thành tab cố định (E6 mở rộng), style card bỏ viền (E7), màu tag/sao/tab chính xác theo hex Ruka cho (E8). Có thể quay lại sau nếu cần, không ảnh hưởng chức năng.
- **F1/F2** (Coach Detail mở rộng: Giới thiệu/đánh giá/bình luận; Booking summary mở rộng: Địa chỉ/Trao đổi Coach/Mã giảm giá) — **vừa giao Cursor 2026-09-04, đang chờ build xong** — xem `PSgy-Reference-Build-Checklist.md` mục F để cập nhật trạng thái mới nhất trước khi backend team bắt tay vào 2 màn này.
- **D2-sửa/D4-sửa** (ảnh bắt buộc trong Journal, feed dạng grid) — code đã xong, đang chờ Ruka xác nhận lần cuối trên thiết bị thật (chỉ là bước duyệt hình ảnh, không phải việc cần backend).

---

## 8. Tóm tắt trạng thái hiện tại (chi tiết đầy đủ xem checklist)

- **Section A (Coach app cốt lõi)** — ✅ Hoàn thành.
- **Section B (User app mở rộng — hồ sơ, Gói/Booking, Chat, trạng thái, lịch sử)** — ✅ Hoàn thành, nhưng phần Gói/Package đã qua **2 lần đảo ngược mô hình** (xem mục 3 domain model + mục 10b brief) — dùng đúng bản mới nhất (Coach tự tạo Gói riêng), KHÔNG dùng bản ví hệ thống mô tả ở brief mục 10a.
- **Section D (Nhật ký/Streak/Badge)** — ✅ Hoàn thành, D2-sửa/D4-sửa đã code xong chờ duyệt ảnh cuối.
- **Section E (UI/UX Material 3, theme, bản đồ tối giản)** — Tạm dừng ở mức "đủ dùng demo", vài mục còn `[ ]` là backlog tinh chỉnh, không chặn.
- **Section C (Admin tool)** — Chưa bắt đầu, kiến trúc đã chốt.
- **"Đảo ngược Package lần 2" (A6-sửa-2/B2-sửa-2/B3-sửa-2/E6-sửa)** — Đang chờ Cursor build (giao 2026-09-04).
- **Section F (Coach Detail + Booking summary mở rộng)** — Vừa giao Cursor 2026-09-04, chưa có code.

---

## 9. Tài liệu tham khảo

- `PSgy-Project-Brief.md` — bối cảnh business đầy đủ + mọi quyết định kiến trúc (kể cả lịch sử đảo ngược Package 2 lần, mục 10/10a/10b).
- `PSgy-Reference-Build-Checklist.md` — nhật ký build chi tiết từng tính năng, tick trạng thái, ngày xác nhận.
- `PSgy-Clone-Checklist.md` — quy trình clone kỹ thuật ban đầu (bundle ID, icon, Phone Auth iOS setup từng bước) — tham khảo khi cần hiểu lại setup Firebase/iOS/Android ban đầu.
- `PSgy-Codebase-Inventory.md` — Cursor xuất trực tiếp từ code thật (2026-09-04): cây thư mục, đầy đủ field/method thật của mọi model + `MockUserSession`/`MockCoachSession`, bảng screen↔method, `pubspec.yaml`, TODO còn sót. **Nguồn đúng 100% theo code** — nếu tài liệu này lệch đâu đó, tin theo inventory.

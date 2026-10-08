# 01 — Màn hình

Copy tiếng Việt lấy nguyên văn từ code (tag `245437c`). Overlay ghi ngay dưới màn cha.

---

## U01 · Splash · `lib/features/common/presentation/screens/splash_screen.dart` · User+Coach

**Vào từ đâu:** mở app (`AppRootScreen` stage splash).

**Bố cục:** `HeaderLogo` (Semantics `gymPS` / `gymPS coach`) · `Text` `FlavorConfig.appName` · `Tìm gym + đặt lịch Coach` · (non-prod) chip môi trường · (non-prod) `Giữ logo để mở Debug Menu`.

**Dữ liệu:** `appName`, `AppConfig.tagline`.

**Hành động:** ~2200ms → consent hoặc home. Long-press logo → Debug Menu (dev).

**Ghi chú:** animation 1400ms. User nền `#F8FAFC`; Coach canvas sheet.

---

## U02 · Quyền riêng tư & Dữ liệu · `privacy_consent_screen.dart` · User+Coach (chỉ production chưa consent)

**Vào từ đâu:** U01 khi `isProduction && !privacyConsentAccepted`.

**Bố cục:** headline `Quyền riêng tư & Dữ liệu` · `PSgy sử dụng vị trí để giúp bạn tìm gym và Coach gần bạn. Chúng tôi không bán dữ liệu cá nhân của bạn.` · hàng `Vị trí` / `Hiển thị bãi xe gần bạn trên bản đồ` · `Dữ liệu bãi xe` / `Đồng bộ tình trạng chỗ trống và bãi khảo sát` · `Chẩn đoán` / `Giúp cải thiện ổn định app (Crashlytics)` · `Chính sách` · `Điều khoản` · CTA `Đồng ý và tiếp tục` · `Phiên bản 1.0.0+1`.

**Hành động:** Chính sách / Điều khoản → màn URL (có thể trống). Đồng ý → home.

**Ghi chú:** copy “bãi xe” sót ParkingLink.

---

## U03 · ModeSwitcher (dev) · `app_root_screen.dart` · cả 2

**Vào từ đâu:** `AppConfig.showDevModeSwitcher` (development).

**Bố cục:** AppBar `HeaderLogo` + `TextButton.icon` `Chuyển sang Coach` / `Chuyển sang User`. Body: User `_UserPilotGate` hoặc `CoachHomeScreen`.

**Hành động:** đổi `AppModeController` — không persist.

---

## U04 · Xác thực số điện thoại · `mock_phone_auth_screen.dart` · User

**Vào từ đâu:** U03/flavor User khi chưa OTP, chưa profile.

**Bố cục SĐT:** `Nhập số điện thoại để tiếp tục` · hint `09x xxx xxxx` · `Gửi mã OTP`.  
**OTP:** `Mã OTP đã gửi đến +84…` · hint `000000` · `Xác nhận` · `Gửi lại sau N giây` / `Gửi lại OTP`.

**SnackBar:** `Mã demo: 123456` · `Vui lòng nhập số điện thoại hợp lệ` · `Mã OTP phải có 6 chữ số`.

**Hành động:** OTP 6 số bất kỳ → U05.

---

## U05 · Tạo hồ sơ · `user_profile_setup_screen.dart` · User

**Vào từ đâu:** OTP xong, `profile == null`.

**Bố cục:** CircleAvatar (Icons.person) · `Chọn ảnh` · label `Tên của bạn` hint `Ví dụ: Nguyễn Minh Anh` · `Tiếp tục`. SnackBar `Vui lòng nhập tên`.

**Hành động:** `createProfile` → U06. `automaticallyImplyLeading: false`.

---

## U06 · Main shell · `main_shell_screen.dart` · User

**Vào từ đâu:** đã có profile; hoặc U11 `Về trang chủ`.

**Bố cục:** IndexedStack 4 tab: U07 Bản đồ · U14 Nhật ký · U15 Cộng đồng · U13 Lịch sử.  
Bottom: `Bản đồ` · `Nhật ký` · (trống) · `Cộng đồng` · `Lịch sử`. Giữa: vòng 60px `videocam_outlined` + `PT AI`.

**Hành động:** đổi tab giữ state. PT AI → U19 (push, không phải tab).

---

## U07 · Bản đồ · `pilot_map_screen.dart` · User

**Vào từ đâu:** U06 tab 0. Không AppBar.

**Bố cục:** GoogleMap (10.7769, 106.7009 zoom 12.2) · chip `Coach` · `Phòng gym` · (layer gym) legend `Hệ thống — đối tác PSgy` / `Thu thập — chỉ tham khảo` · DraggableScrollableSheet 0.22–0.78 init 0.38: title `Coach gần bạn` | `Phòng gym`.

Card Coach: avatar · name · rating + `X.X km` · AppTag `nextSlotLabel` highlight.  
Card Gym: icon tạ · name · address · AppTag `hệ thống`|`thu thập` · `Chỉ đường`.

**Dữ liệu:** `mockCoaches` (6) · `mockGyms` (10).

**Hành động:** Coach → U09. Gym marker → **U07a sheet** cùng card + Chỉ đường (URL Google Maps). Fail: `Không mở được Google Maps.`

---

## U08 · Coach gần bạn (list) · `pilot_list_screen.dart` · User (web fallback)

**Vào từ đâu:** comment: WEB thay map. Mobile không dùng.

**Bố cục:** list card avatar · name · rating · tag slot · chevron. Tap → U09.

---

## U09 · `{coach.name}` · `coach_detail_screen.dart` · User

**Vào từ đâu:** U07/U08.

**Bố cục trên→dưới:**
1. AppBar title name, back tooltip `Quay lại`
2. Slideshow 240px + dots `i/n`
3. headline name
4. `Icons.star` `{avg} · {count} đánh giá  ·  {years} năm kinh nghiệm  ·  {totalBookings} lượt booking`
5. `Về tôi` + bio
6. `Mục tiêu` chips colored
7. `Đối tượng` chips colored
8. `Hình thức` chips xám
9. `Lịch trống` 7 cột `T2`…`CN` + slot `HH:mm–HH:mm` hoặc `—`
10. `Chọn dịch vụ` tab `Dịch vụ` | `Gói`  
    Dịch vụ: Radio name · `{priceLabel} · {duration} phút` · promo tag  
    Gói: tag name · optional `Tiết kiệm N%` · `{n} buổi · {price}` · description · `Mua`  
    Empty gói: `Coach này chưa có gói.`  
    `Gói đã mua`: `{remainingLabel}` + `Mua ngày dd/MM/yyyy`
11. `Đã bao gồm chi phí phòng gym` | `Chưa bao gồm chi phí phòng gym` (+ membershipFeeLabel nếu có)
12. `Địa điểm tập` tag type · name · address
13. `Kết quả học viên` before/after · studentLabel · summary · `Xem chi tiết` → U18
14. `Certification` chips → **U09b** fullscreen InteractiveViewer
15. `Đánh giá` `{avg}/5 · N đánh giá` bars `5★`…`1★` · empty `Chưa có đánh giá.`
16. `Bình luận khách hàng` reviewer · date · sao · comment
17. `Chính sách booking/cancellation` + policy
18. Sticky `Chọn HLV` → U10 (cần chọn dịch vụ)

**U09a dialog:** title `Xác nhận mua` · `{name}\n{n} buổi · {price}` · `Hủy` / `Xác nhận mua` → SnackBar `Đã mua {name}`.

---

## U10 · Xác nhận đặt lịch · `booking_summary_screen.dart` · User

**Vào từ đâu:** U09 `Chọn HLV`.

**Bố cục:** Card `Địa chỉ` hint `Nhập địa chỉ muốn tập` · `Trao đổi với Coach` → U12 inquiry.  
(Nếu có gói còn buổi) `Thanh toán`: `Tiền mặt trực tiếp với Coach` · `Dùng gói {name} ({remainingLabel})`.  
Card `Mã giảm giá` hint `Nhập mã` · `Áp dụng` (chỉ unfocus).  
Card `Hóa đơn`: Coach / Dịch vụ / Khung giờ / Địa điểm `Coach đến chỗ bạn` / Tổng tiền hoặc `Trừ 1 buổi gói`.  
Banner cash: `Thanh toán tiền mặt trực tiếp với Coach`. Package: `Thanh toán bằng gói {name} — trừ 1 buổi (còn N buổi)`.  
CTA `Đặt lịch ngay` → U11.

**Ghi chú:** địa chỉ + mã **không** lưu booking.

---

## U11 · Theo dõi Booking / Chi tiết Booking · `booking_pending_screen.dart` · User

**Vào từ đâu:** U10; U13.

**Bố cục:** card coach · dịch vụ · giá · giờ · `Coach đến chỗ bạn` · paymentSummary.  
`Tiến trình`: pending `Đang chờ Coach xác nhận...` · mốc `Coach xác nhận` · `Coach bắt đầu` · `Coach hoàn thành` · `Bạn xác nhận`.  
`Chat với Coach` (khi trackable).  
awaiting: sao 1–5 · `Bình luận` hint `Buổi tập thế nào?` · `Xác nhận đã nhận dịch vụ`.  
completed: `Hoàn thành buổi tập` · `📸 Chia sẻ buổi tập hôm nay` · `Về trang chủ`.  
readOnly: `Lý do hủy: …` · `Đánh giá của bạn`. Title readOnly = `Chi tiết Booking`.

**Trạng thái:** pending / confirmed / inProgress / awaitingUserConfirmation / completed / cancelled. Auto-advance 3s DEMO ONLY.

---

## U12 · Chat · `user_chat_screen.dart` · User

**Vào từ đâu:** U10 inquiry; U11 booking.

**Bố cục:** AppBar avatar + coachName; inquiry subtitle `Trao đổi trước khi đặt lịch`. Bubble + `sentAtLabel`. Hint `Nhắn tin cho Coach...`.

---

## U13 · Lịch sử booking · `user_booking_history_screen.dart` · User

**Vào từ đâu:** U06 tab.

**Bố cục:** empty `Chưa có booking nào.` Card: avatar · coachName · chip statusLabel · service · giờ · `Thanh toán: Tiền mặt|Gói`.

statusLabel: `Chờ xác nhận` · `Đã xác nhận` · `Đang tập` · `Chờ khách xác nhận` · `Hoàn thành` · `Đã hủy`.

---

## U14 · Nhật ký của tôi · `my_journal_screen.dart` · User

**Vào từ đâu:** U06 tab.

**Bố cục:** `🔥 {N} ngày liên tiếp` | `🔥 Chưa có chuỗi ngày tập` · hàng badge · grid 3 cột. Empty `Chưa có bài nhật ký. Hoàn thành buổi tập rồi chia sẻ nhé.`

**U14a dialog badge:** name + description + `Đóng`.  
`Buổi tập đầu tiên` / `Hoàn thành buổi tập đầu tiên trên PSgy.`  
`Streak 3 ngày` / `Tập 3 ngày liên tiếp.`  
`Streak 7 ngày` / `Tập 7 ngày liên tiếp.`

Tap ô → U16.

---

## U15 · Cộng đồng PSgy · `community_feed_screen.dart` · User

Grid bài `public`. Empty `Chưa có bài công khai.` Tap → U16.

---

## U16 · Bài viết · `journal_post_detail_screen.dart` · User (Coach đọc-only)

**Vào từ đâu:** U14/U15; C07 readOnly.

**Bố cục:** AppBar `Báo cáo` | `Đã báo cáo` · card (tác giả, giờ, tag dịch vụ, coach · phút, caption, ảnh, số like/comment) · `Thả tim`/`Đã thích` · `Bình luận` · hint `Viết bình luận...`. Empty comment `Chưa có bình luận.` Missing `Không tìm thấy bài viết.`  
SnackBar `Đã ghi nhận báo cáo`.  
Giờ: `Vừa xong` · `N phút trước` · `N giờ trước` · `N ngày trước` · `dd/MM HH:mm`.  
readOnly: ẩn social.

---

## U17 · Chia sẻ buổi tập · `create_journal_post_screen.dart` · User

**Vào từ đâu:** U11 completed.

**Bố cục:** card dịch vụ · coach · `{n} phút` · `Ảnh buổi tập` · `Bắt buộc · tối thiểu 1 ảnh` · `Thêm ảnh`/`Đổi ảnh` · `Cảm nhận (tuỳ chọn)` hint `Buổi tập hôm nay thế nào?` · `Còn N ký tự` (max 100) · `Ai xem được`: `Riêng tư` · `Chỉ PT` · `Công khai` (mặc định Riêng tư) · `Đăng`.

SnackBar: `Vui lòng thêm ít nhất 1 ảnh` · `Đã đăng nhật ký buổi tập`.

---

## U18 · `{studentLabel}` · `student_result_detail_screen.dart` · User

`Trước` / `Sau` · `Tóm tắt` · `Nhật ký tiến độ` dateLabel + note.

---

## U19 · PT AI · `pt_ai/pt_ai_intro_screen.dart` · User

Banner `AI đồng hành · Camera theo dõi · Tư thế chuẩn`.  
Title `PT AI — Tập cùng AI, mọi lúc mọi nơi`.  
Body: `Không cần đặt lịch, không cần chờ Coach rảnh — chỉ cần điện thoại và một góc nhỏ đủ đứng tập. PT AI đồng hành cùng bạn qua camera, giống như một cuộc gọi video: AI sẽ theo dõi tư thế của bạn trong thời gian thực và nhắc bạn chỉnh sửa ngay khi cần, để mỗi động tác căn bản đều đúng kỹ thuật và an toàn. Phù hợp cho buổi tập nhẹ tại nhà, khởi động trước khi đến gym, hoặc đơn giản là muốn tập ngay mà không phải chờ ai.`  
`Bắt đầu` → U20.

---

## U20 · Chọn bài tập · `pt_ai_picker_screen.dart` · User

Checkbox card: ảnh · name · description · tag `{n} giây`. CTA `Bắt đầu tập` / `Bắt đầu tập (N)`. SnackBar `Chọn ít nhất 1 bài tập`. Default chọn bài đầu.

Tên bài: `Squat` · `Plank` · `Lunge (Chùng chân)` · `Hít đất (Push-up)` · `Gập bụng (Crunch)` · `Đứng tấn (Wall sit)`.

---

## U21 · (tên bài) / Nghỉ · `pt_ai_session_screen.dart` · User

Fullscreen camera. Close tooltip `Dừng`. `{i}/{total}` · MM:SS · bubble cue. Fallback `Đang mở camera trước…` / `Camera chưa sẵn sàng — AI vẫn hướng dẫn`. Rest: `Nghỉ — tiếp theo: {name}`.

**U21a:** `Dừng buổi tập?` · `Tiến trình bài tập hiện tại sẽ không được lưu.` · `Tiếp tục tập` / `Dừng`.

Cues: `04_MOCK_DATA/pt_ai_exercises.json`. Không pose detection.

---

## U22 · Hoàn thành · `pt_ai_complete_screen.dart` · User

`Tuyệt vời! Bạn vừa hoàn thành buổi tập cùng PT AI.` · `Số bài đã tập` · `Tổng thời gian` (`N giây` / `N phút` / `N phút N giây`) · `Xong` → U06.

---

## C01 · gymPS coach · `coach/coach_home_screen.dart` · Coach

**Vào từ đâu:** flavor Coach / U03.

**Bố cục:** AppBar logo (dev: title null, logo ở U03) actions tooltip `Chỉnh sửa hồ sơ` · `Nhật ký học viên` · `Dịch vụ`.  
Avatar + **Nguyễn Văn Long** · `4.8  ·  126 đánh giá` · `Chỉnh sửa hồ sơ`.  
Card: `Đang rảnh` · `Khung giờ 17:00 - 20:00` · `Vị trí hiện tại` · `Cập nhật vị trí`.  
`Booking đang diễn ra` (nếu có) · `Booking mới cần xác nhận` · empty `Không có yêu cầu mới.`

Card booking: initials · userName · `{service} · {giá}` · giờ · chip status.

**Hành động:** edit → C06; journal → C07; tạ → C05; switch rảnh; vị trí cycle Q2→Q1→Q7→Thủ Đức; active → C02; pending → C03.

---

## C02 · Booking đang diễn ra · `active_booking_screen.dart` · Coach

Chip status · userName · dịch vụ · giá · giờ · địa điểm · optional `Lý do hủy:` · `Vào Chat` → C04.  
confirmed: `Bắt đầu buổi tập` · `Báo cáo khách không đến`. inProgress: `Hoàn thành dịch vụ`. awaiting: `Đã gửi yêu cầu xác nhận cho khách.` Missing: `Không tìm thấy booking.`

**C02a:** `Báo cáo khách không đến` · `Lý do ngắn` hint `Ví dụ: Khách không nghe máy` · `Hủy`/`Gửi` (trống → `Khách không đến`) → cancelled + pop.

---

## C03 · Yêu cầu đặt lịch · `booking_request_detail_screen.dart` · Coach

Rows `Dịch vụ` / `Giá` / `Giờ` / `Địa điểm` / `Trạng thái`. Footer pending: `Từ chối` | `Xác nhận`. Missing title `Chi tiết booking`.

---

## C04 · `{userName}` · `coach_chat_screen.dart` · Coach

Hint `Nhắn tin cho khách...`. Seed xem `04_MOCK_DATA/coach_session_seed.json`.

---

## C05 · Dịch vụ của bạn · `coach_services_screen.dart` · Coach

Tab `Dịch vụ` | `Gói`. Card dịch vụ `{name}` · `{giá} · {n} phút` menu `Sửa`/`Xóa`. Gói: `{n} buổi · giá` + mô tả. FAB `+`.

Dialog dịch vụ: `Tên` · `Giá (VND)` · `Thời lượng (phút)` · `Hủy`/`Lưu`.  
Dialog gói: `Tên` · `Số buổi` · `Giá gói (VND)` · `Mô tả`.  
Xóa: `Xóa dịch vụ`/`Xóa gói` · `Xóa mục này khỏi danh sách demo?` · `Hủy`/`Xóa`.  
SnackBar: `Phải giữ ít nhất 1 dịch vụ để khách tập thử 1 buổi.`

---

## C06 · Chỉnh sửa hồ sơ · `coach_profile_edit_screen.dart` · Coach

Name + `4.8  ·  126 đánh giá · 8 năm KN`. `Đánh giá và số booking do hệ thống tính — không chỉnh tay.`  
`Về tôi` hint `Giới thiệu kinh nghiệm, cách kèm, thành tựu…`  
`Mục tiêu` `Tăng cơ` `Giảm mỡ` `Tăng sức bền` `Phục hồi sau chấn thương`  
`Đối tượng` `Nam` `Nữ` `VĐV` `Người mới bắt đầu` `Phục hồi chấn thương`  
`Hình thức` `1-1` `Online` `Nhóm 1-2`  
`Lịch trống tuần` T2–CN · ` · hôm nay` · `Giờ bắt đầu`/`Giờ kết thúc` · `Giờ kết thúc phải sau giờ bắt đầu.`  
`Địa điểm tập` `Thêm` empty `Chưa có địa điểm.` subtitle `{address}\n{type}`  
`Chính sách huỷ` hint `Ví dụ: Huỷ miễn phí trước 2 giờ…`  
`Certification` `Thêm` empty `Chưa có chứng chỉ.`  
`Phí phòng gym & membership` switch `Có bao gồm phí phòng gym` · `Giá membership` hint `Để trống = ẩn dòng này`  
`Lưu` → `Đã lưu hồ sơ trong phiên demo.`

**Ghi chú:** Đợt 2 chưa: slideshow 5 ảnh, kết quả học viên. Không sync U09.

---

## C07 · Nhật ký học viên · `coach_student_journal_screen.dart` · Coach

Grid. Empty `Chưa có bài nhật ký.` Tap → U16 readOnly. Seed Trần Minh Anh / Lê Thị Hương — không phải `MockUserSession`.

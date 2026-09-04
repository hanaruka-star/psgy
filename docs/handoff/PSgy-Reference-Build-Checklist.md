# PSgy — Checklist Bản Tham Khảo (bàn giao đội dev)

> Bối cảnh: Pilot rút gọn 2026-08-22 đã được chủ đầu tư duyệt. Giai đoạn này KHÔNG viết code production — ra bản tham khảo hoạt động thật (đúng luồng, đúng UI, dữ liệu mock) để đội dev có kinh nghiệm build tiếp phần data/backend thật. Chi tiết quyết định đầy đủ: xem mục 10, `PSgy-Project-Brief.md`.
>
> **Ưu tiên đã chốt (2026-08-23):** Coach app trước (hiện đang TRỐNG hoàn toàn, chỉ còn màn "Staff Login" cũ của ParkingLink, không dùng được). Tên hiển thị: **PSGymer User / PSGymer Coach / PSGymer Admin**. Admin tool làm sau, đơn giản, đề xuất Flutter Web.
>
> Vai trò giữ nguyên: Claude (Tech Lead, không viết code) hướng dẫn Cursor (Implementation) từng bước, Ruka (PO) xác nhận.

---

## A. Coach app (ưu tiên 1 — đang trống hoàn toàn) — ✅ HOÀN THÀNH (2026-08-23), đã commit & push `faf0cae` (13 files, +1602, `7d482a0..faf0cae` trên `main`)

Xây mới hoàn toàn dưới `lib/features/pilot_demo/` (mở rộng cùng tinh thần mock-data đã dùng cho User, KHÔNG đụng code production cũ, KHÔNG cần Firestore thật).

- [x] **A1. Mock data cho góc nhìn Coach** — `models/mock_coach_profile.dart`, `models/mock_booking_request.dart`, `models/mock_message.dart`, `models/mock_package.dart`, `data/mock_coach_session.dart` (`MockCoachSession` ChangeNotifier, không persist). Seed: Coach **Nguyễn Văn Long** (`coach_01`, trùng với bên User cho nhất quán), 3 booking đủ trạng thái (Trần Minh Anh=pending, Lê Thị Hương=confirmed, Phạm Quốc Bảo=inProgress).
- [x] **A2. Coach Home (dashboard)** — Switch "Đang rảnh" + khung `17:00-20:00`, vị trí + nút "Cập nhật vị trí" (xoay Q2→Q1→Q7→Thủ Đức), card booking đang diễn ra, list pending.
- [x] **A3. Chi tiết Booking request** — Xác nhận→`confirmed` / Từ chối→`cancelled`, về Home.
- [x] **A4. Active Booking screen** — chip trạng thái, confirmed→"Bắt đầu buổi tập", inProgress→"Hoàn thành dịch vụ"(`awaitingUserConfirmation`), "Báo cáo khách không đến" chỉ khi confirmed, link Chat.
- [x] **A5. Chat screen** — bubble phải=coach/trái=user, gửi tin nhắn local.
- [x] **A6. Quản lý Dịch vụ + Gói dịch vụ** — AppBar icon tạ, 2 tab, menu 3 chấm sửa/xoá, FAB `+` theo tab. ⚠️ **Tab "Gói dịch vụ" built sai mô hình 2026-08-23 (Coach tự tạo gói riêng), phải bỏ theo quyết định sửa lại 2026-08-25 — xem A6-sửa ở cuối file.** Tab "Dịch vụ" (giá riêng từng Coach) vẫn đúng, giữ nguyên.
- [x] **A7. Wiring entry point flavor Coach** — Cursor làm luôn cùng lúc, flavor Coach nay mở thẳng `CoachHomeScreen` (TEMP, cùng pattern User→`PilotMapScreen`).
- [x] **A8. Đổi tên hiển thị Coach app** → "PSGymer Coach" (hiện đang "PSgy Coach" cũ) — cùng cách đã làm cho User (`APP_NAME` trong `project.pbxproj`, xem Checkpoint 2 trong `PSgy-Clone-Checklist.md` để nhớ đúng quy trình sed an toàn). **2026-08-23: xác nhận — tên app trên Home Screen (icon, `CFBundleDisplayName`/`APP_NAME`) đã đúng "PSGymer Coach". Còn sót 1 chỗ text cứng trong headline/logo trên màn Coach Home vẫn ghi "PSgy Coach (..." — đây là text hardcode trong UI (không phải `APP_NAME`), KHÔNG ảnh hưởng demo, để lại cho đội dev sửa sau (Ruka xác nhận không quan trọng). Chốt A8 done.**
- [x] **A9. Test trên thiết bị** — build Release, verify chạy độc lập không cần dây (bài học từ pilot: Debug build cần debugger mới chạy standalone). **2026-08-23: xác nhận qua ảnh chụp — app Coach chạy độc lập trên máy (không dây), toàn bộ luồng hoạt động đúng: dashboard, cập nhật vị trí (Q2→Q1), chi tiết booking, chat, "Bắt đầu buổi tập"→"Chờ khách xác nhận".**

---

## B. Mở rộng User app

- [x] **B1. Tạo tài khoản/hồ sơ sau OTP** — màn nhập tên + ảnh (`UserProfile`, mock lưu local). **2026-08-23: gắn xong.** Luồng: `PhoneAuthScreen` verifyOtp (Firebase thật, không đổi) → `_UserPilotGate` trong `app_root_screen.dart` kiểm tra `MockUserSession.profile == null` → nếu chưa có thì vào `UserProfileSetupScreen` (tên bắt buộc + chọn ảnh qua `image_picker` có sẵn) → `MockUserSession.createProfile` → `PilotMapScreen`. Session không persist qua restart app (đúng tinh thần mock trong-phiên như Coach). Không đụng `UserProfileNotifier.verifyOtp`/luồng check-in cũ. `dart analyze` sạch trên file mới; 21 lỗi cũ `firestore_seed/` không liên quan.
- [x] **B2. Xem Gói (ví nạp trước) hệ thống + mua gói** — sửa lại đúng mô hình 2026-08-25 (xem mục "Sửa lại quyết định Package" ở cuối file). `MockPackage` bỏ `coachId`, catalog `mockSystemPackages` (nội dung cũ `pkg_10`/`pkg_20`, không gắn Coach nào). Thêm `MockWalletPackage` + `MockUserSession.wallets`; `purchasePackage(packageId)` tạo ví với `remainingBalanceVnd = totalPriceVnd`. `coach_detail_screen.dart` quay lại chỉ còn Dịch vụ + Tiếp tục (bỏ tab Gói theo Coach). Màn mới `user_wallet_screen.dart` ("Ví của tôi") — danh mục hệ thống + Mua, danh sách ví đã mua (còn lại X/Y đ, ngày mua). Điểm vào: icon ví trên `PilotMapScreen` cạnh tiêu đề "Coach gần bạn" (User pilot không có màn hồ sơ/menu riêng nên đây là vị trí hợp lý). `dart analyze` sạch.
- [x] **B3. Đặt lịch hỗ trợ trả bằng ví gói đã mua** — `booking_summary_screen.dart` thêm lựa chọn `paymentMethod = package`. **2026-08-25: xong, đúng mô hình ví hệ thống.** Radio Tiền mặt (mặc định) + 1 radio mỗi ví còn dư (ví số dư cao nhất trước); nếu ví thiếu tiền hiện thêm lựa chọn "Trả thêm Y đ" / "Đổi sang tiền mặt". Đặt lịch ngay: đủ ví → trừ đúng giá dịch vụ, thiếu+trả thêm → trừ hết ví + ghi `topUpAmountVnd`, tiền mặt → không trừ ví. Thêm `paymentMethod`/`topUpAmountVnd` vào `MockBookingRequest`. **Tiện thể phát hiện + sửa luôn lỗ hổng cũ:** trước đó "Đặt lịch ngay" KHÔNG lưu lại booking phía User — đã thêm `MockUserSession.placeBooking` để lưu, sẽ tái dùng cho B6 (lịch sử booking). `dart analyze` sạch.
- [x] **B4. Chat với Coach trong Booking** (mock, đối xứng với A5 bên Coach). **2026-08-25: xong.** `user_chat_screen.dart` (phải = User, trái = Coach — đối xứng đúng chiều với A5), tin nhắn lưu trong `MockUserSession`, hiện được từ mốc `confirmed` trở đi. Lưu ý: User/Coach là 2 phiên mock độc lập không sync — chat này minh hoạ UI, chưa nhắn qua lại thật giữa 2 app.
- [x] **B5. Trạng thái Booking đủ 3 mốc** — cập nhật `booking_pending_screen.dart` (hoặc màn theo dõi mới) hiện rõ: Coach xác nhận → Coach bắt đầu → Coach hoàn thành → User xác nhận + đánh giá. **2026-08-25: xong.** Đổi `booking_pending_screen.dart` thành màn "Theo dõi Booking" — timeline 4 mốc, auto-advance mỗi 3s (comment rõ DEMO ONLY, bản thật cần Firestore realtime — việc đội dev). Mốc chờ khách: sao 1-5 + bình luận + "Xác nhận đã nhận dịch vụ" → `completed`. `MockBookingRequest.status` đã có đủ state machine từ B3. `dart analyze` sạch.
- [x] **B6. Danh sách lịch sử Booking**. **2026-08-25: xong.** `user_booking_history_screen.dart` đọc `MockUserSession.bookings.reversed` (mới nhất trước) — card: tên Coach, dịch vụ, giờ hẹn, chip trạng thái, phương thức thanh toán. Tap: booking đang chạy (pending/confirmed/inProgress/awaitingUserConfirmation) → vào lại `BookingPendingScreen` tiếp tục auto-advance từ status hiện tại (không rewind); booking xong/huỷ → cùng màn với `readOnly: true` (đọc-only, không chat/confirm/auto-advance). Tiện thể phát hiện + sửa: `MockBookingRequest` trước đó thiếu `coachId`/`coachName` (cần cho hiển thị lịch sử) — đã bổ sung, `BookingSummaryScreen` truyền vào lúc đặt lịch. Điểm vào: icon lịch sử cạnh icon ví trên `PilotMapScreen` (title | lịch sử | ví). `flutter analyze lib/features/pilot_demo`: sạch.
- [x] **B7. Đổi tên hiển thị** → "PSGymer User" (hiện đang "PSGymer" — thêm đúng 1 chữ "User"). **2026-08-25: xong.** Sed xác nhận đúng 3 dòng đổi (Profile/Debug-user/Release-user), Coach không đổi; `.app` kiểm tra `CFBundleDisplayName = PSGymer User`, `CFBundleIdentifier = com.psgy.user`. Xác nhận cuối bằng thực tế sử dụng: Ruka chạy standalone (không dây) trọn vẹn cả chuỗi Ví → Mua gói → Đặt lịch (ví) → Theo dõi Booking → Chat → Hoàn thành mà không cần cắm dây lại — app rõ ràng đang chạy độc lập đúng bundle đã đổi tên.
- **⚠️ Sự cố phát sinh + đã sửa trong lúc test B7 (2026-08-25):** app treo ở màn "khiên cam" (`PermissionException`/Firestore `permission-denied` từ code `UserProfileNotifier` cũ đọc `users/{uid}`, không thuộc `pilot_demo`) khi launch standalone với tài khoản Auth cũ còn sót trên máy. **Quyết định:** thay vì sửa rules/luồng Auth thật, đổi hẳn màn đăng nhập pilot User sang **OTP GIẢ LẬP** (`MockPhoneAuthScreen`, không gọi Firebase Auth/Firestore) — vì mục tiêu giai đoạn này là đúng luồng/UI, không phải chứng minh backend thật (Phone Auth thật đã verify xong ở Checkpoint 2, giữ nguyên code không xoá). Xem chi tiết quyết định trong `PSgy-Project-Brief.md` mục 10. `_UserPilotGate` trỏ `MockPhoneAuthScreen`; `PhoneAuthScreen` thật không đụng. `flutter analyze` sạch.

**Section B — HOÀN THÀNH (2026-08-25).** Đã commit & push cùng đợt sửa Package/A6-sửa/B2-sửa: `c85dc72` (24 files, +1956/−462, `faf0cae..c85dc72` trên `main`).

---

## D. Nhật ký tiến trình (Progress + Social) + Streak/Badge — ưu tiên MỚI, trước Admin (chốt 2026-08-25)

Chi tiết quyết định đầy đủ: `PSgy-Project-Brief.md` mục 11. Giữ tinh thần mock/`pilot_demo` như các phần trước.

- [x] **D1. Domain model + mock data** — `JournalPost`, `JournalComment`, `UserStreak`, `Badge`/`UserBadge`. Seed vài bài viết mẫu từ 2-3 User mock khác (để feed công khai không trống) + vài badge mẫu. **2026-08-25: xong.** Model trong `mock_journal_post.dart`/`mock_journal_comment.dart`/`mock_user_streak.dart`/`mock_badge.dart` (catalog `mockBadges`: `badge_first_session`/`badge_streak_3`/`badge_streak_7`). Seed 3 User mẫu (Phạm Minh Khoa, Ngô Thanh Hà, Đặng Quốc Việt — `sample_user_01..03`) + 4 bài `public` (kèm like/comment mẫu) trong `mock_journal_seed.dart`. Gắn vào `MockUserSession` (`journalPosts`/`journalComments`/`userStreak`/`userBadges`) theo đúng pattern `wallets`/`bookings`. `userStreak` khởi tạo rỗng đến khi `createProfile` gán id. `flutter analyze` sạch.
- [x] **D2. Nút "📸 Chia sẻ buổi tập hôm nay"** ở mốc `completed` trong màn "Theo dõi Booking" (B5) → màn tạo bài viết (pre-fill buổi/Coach/thời lượng, viết cảm nhận + chọn ảnh mock, chọn 1 trong 3 mức riêng tư: Riêng tư/Chỉ PT/Công khai). **2026-08-25: xong**, gộp cùng D7. `create_journal_post_screen.dart`: đọc-only buổi/Coach/phút, caption bắt buộc, ảnh tuỳ chọn, mặc định "Riêng tư". Footer màn completed: nút Chia sẻ (tuỳ chọn) + Về trang chủ.
- [ ] **D2-sửa. Đảo ngược bắt buộc: ảnh chính, text phụ** (chốt 2026-08-31 — Ruka muốn feed lấy hình làm chính, hạn chế chữ). `create_journal_post_screen.dart`:
  - **Ảnh: bắt buộc** (tối thiểu 1 ảnh — không có ảnh thì nút Đăng bị disable/báo lỗi). Trước đó ảnh tuỳ chọn — đảo ngược lại.
  - **Caption: tuỳ chọn, giới hạn ngắn** (đề xuất ~100 ký tự, hiện đếm ký tự còn lại) — trước đó caption bắt buộc không giới hạn, bỏ bắt buộc.
  - Các phần khác giữ nguyên (đọc-only buổi/Coach/phút, 3 mức riêng tư, mặc định "Riêng tư").
  - **2026-08-31: Cursor báo code xong.** Ảnh đứng trước, bắt buộc tối thiểu 1 — nút Đăng disable khi chưa chọn, bấm khi thiếu ảnh hiện snackbar "Vui lòng thêm ít nhất 1 ảnh". Caption tuỳ chọn, tối đa 100 ký tự, counter "Còn N ký tự". `flutter analyze` sạch. **Ảnh xác nhận là chụp từ widget test (không phải máy thật) nên chữ hiện dạng block do font Inter không bundle trong môi trường test** — Cursor xác nhận trên máy thật sẽ lên đúng Inter. Chờ Ruka build lên máy X xem lại 1 lần cho chắc trước khi tick hẳn.
- [x] **D3. Màn "Nhật ký của tôi"** — timeline cá nhân, toàn bộ bài (kể cả riêng tư). **2026-08-25: xong.** `my_journal_screen.dart` — mọi privacy của User login, mới nhất trước, hiện streak + hàng badge đã đạt (chạm xem tên/mô tả).
- [x] **D4. Màn "Cộng đồng PSgy"** — feed công khai (chỉ bài `public`, từ mọi User mock). **2026-08-25: xong.** `community_feed_screen.dart`.
- [ ] **D4-sửa. Đổi bố cục feed sang dạng lưới ảnh (grid)** (chốt 2026-08-31, áp dụng cả `my_journal_screen.dart` VÀ `community_feed_screen.dart` — không chỉ 1 màn). Đổi từ list card hiện tại (ảnh nhỏ + text nổi bật) sang **grid vuông nhiều ảnh/hàng** (kiểu trang cá nhân Instagram) — mỗi ô chỉ hiện thumbnail ảnh, KHÔNG hiện caption/tên Coach trực tiếp trên grid. Bấm vào 1 ô → mở `journal_post_detail_screen.dart` (đã có sẵn từ D5) xem đủ caption/buổi tập/Coach/like/comment.
  - Streak + hàng badge trên `my_journal_screen.dart` (D3/D8) giữ nguyên vị trí (header phía trên grid), không đụng.
  - Bài không có ảnh (nếu còn sót từ trước D2-sửa, dữ liệu mock cũ) → hiện placeholder hoặc ẩn khỏi grid, Cursor tự quyết cách nào gọn hơn.
  - **Tiện thể rà lại seed data D1** (`mock_journal_seed.dart`, 4 bài mẫu công khai) — gán thêm ảnh mock cho từng bài nếu đang thiếu, để grid demo không bị lỗ hổng/trống ô khi Ruka xem thử Cộng đồng.
  - **2026-08-31: mở rộng thêm — đồng bộ luôn `coach_student_journal_screen.dart` (D9, bên Coach app) sang cùng bố cục grid**, không giữ dạng list riêng. Bấm vào ô → vẫn mở đúng chi tiết bài (đọc-only như D9 đã quy định), chỉ đổi cách hiển thị danh sách từ list sang grid cho nhất quán 3 màn (Nhật ký/Cộng đồng/Nhật ký học viên).
  - **2026-08-31: Cursor báo code xong cả 3 màn**, dùng chung 1 widget `JournalPhotoGrid` (3 cột, ô vuông, chỉ thumbnail, bài không ảnh tự ẩn khỏi grid) — đúng tinh thần "1 chỗ dùng chung" như các phần theme trước. Nhật ký của tôi: streak+badge vẫn trên header, bấm ô → chi tiết đầy đủ. Cộng đồng: bấm ô → chi tiết có like/comment như cũ. Nhật ký học viên (Coach): bấm ô → chi tiết đọc-only, không like/comment/báo cáo (đúng D9). Đã bổ sung ảnh mock cho toàn bộ 4 bài seed D1 + 2 bài seed Coach (`assets/images/journal/seed_0N.jpg`). `flutter analyze` sạch. **Ảnh xác nhận từ widget test, chữ hiện block do thiếu font Inter trong môi trường test — chờ Ruka mở trên máy thật (User: tab Nhật ký/Cộng đồng; Coach: Nhật ký học viên) bấm thử 1 ô để xác nhận mở đúng màn chi tiết rồi mới tick.**
- [x] **D5. Chi tiết bài viết** — thả tim (like) + bình luận (mock, local). **2026-08-25: xong.** `journal_post_detail_screen.dart` + `MockUserSession.toggleJournalLike`/`addJournalComment`.
- [x] **D6. Nút Báo cáo** trên mỗi bài — mock, chỉ đổi cờ `reported`/SnackBar xác nhận, không cần hệ thống kiểm duyệt thật. **2026-08-25: xong.** `reportJournalPost` — không ẩn bài, chỉ demo khái niệm.
- **Điểm vào:** 2 icon riêng trên `PilotMapScreen`, thứ tự Nhật ký (`auto_stories`) → Cộng đồng (`groups`) → Lịch sử → Ví, mỗi màn AppBar riêng (không gộp hub/tab).
- [x] **D7. Streak** — tính theo Booking `completed` trong ngày (KHÔNG bắt buộc đăng bài). **2026-08-25: logic xong** (gộp cùng D2, trong `updateBookingStatus`): lần đầu/đứt chuỗi → reset 1; hôm qua → +1; cùng ngày → giữ nguyên (không cộng trùng); cập nhật `longestStreak`. Badge `badge_first_session`/`badge_streak_3`/`badge_streak_7` gắn tự động khi đạt mốc. **Còn thiếu:** hiển thị streak nổi bật trên UI (đề xuất cạnh icon Nhật ký ở D3/D4) — làm cùng lúc dựng màn Nhật ký.
- [x] **D8. Badge** — vài mẫu ("Buổi tập đầu tiên", "Streak 3 ngày", "Streak 7 ngày"), hiện huy hiệu đã đạt trên màn Nhật ký. **2026-08-25: xong** (gộp cùng D3) — hàng badge trên `my_journal_screen.dart`.
- [x] **D9. Coach app — xem nhật ký học viên** mình phụ trách (bài `coachOnly` + `public` liên quan đến buổi Coach đó dạy) — đối xứng phía Coach. **2026-08-25: xong.** Xác nhận `MockCoachSession` hoàn toàn độc lập `MockUserSession` (2 cụm mock riêng, đúng giới hạn đã biết từ A5/B4). Seed riêng 2 bài mẫu (`studentJournalPosts`) trong `MockCoachSession`, comment rõ đây là mock minh hoạ UI, bản thật cần Firestore sync xuyên 2 app. `coach_student_journal_screen.dart` đọc-only, điểm vào icon `auto_stories` trên AppBar `CoachHomeScreen`.
- [x] **D10. Test standalone Release** trên máy — build lại, rút dây, chạy thử toàn bộ luồng D2-D9 (hoàn thành buổi → chia sẻ nhật ký → xem Nhật ký/Cộng đồng/streak/badge → Coach xem nhật ký học viên). **2026-08-25: Ruka xác nhận "hoạt động khá ổn" trên cả 2 app, standalone.**

**Section D — HOÀN THÀNH (2026-08-25).**

---

## E. UI/UX — Material 3, theme sáng/tối, bản đồ tối giản (chốt 2026-08-25)

Chi tiết đầy đủ: `PSgy-Project-Brief.md` mục 12. Áp dụng cho CẢ 2 app (User + Coach) để nhất quán khi bàn giao.

- [x] **E1. Thiết lập ColorScheme Material 3** (`ColorScheme.fromSeed`, seed teal `#00897B`) cho cả light + dark, `useMaterial3: true`. **2026-08-25: xong.** Sửa đúng 1 chỗ `lib/core/theme/app_theme.dart` (`AppTheme.light`/`AppTheme.dark`) — User và Coach dùng chung 1 `lib/main.dart`/`MaterialApp` (không tách `main_user.dart`/`main_coach.dart`), nên áp dụng tự động cho cả 2 flavor. `flutter analyze` sạch.
- [ ] **E1-sửa. Đổi hẳn seed color, bỏ teal** (chốt 2026-08-29, MỞ LẠI quyết định seed teal `#00897B` đã "chốt không còn TREO" 2026-08-25 — Ruka đổi ý sau khi xem 2 ảnh app mẫu). Ruka gửi 2 ảnh: 1 app light màu (nền trắng/xanh nhạt, tile giờ ăn active màu xanh dương sáng) + 1 app dark màu (nền navy đậm, nút play tím-indigo) — đo pixel thật từ ảnh: light accent ≈ `#00A0E0`, dark accent ≈ `#9290FA`. 2 hệ màu KHÁC hue nhau rõ (xanh dương ở light, tím-indigo ở dark), không phải cùng 1 tông nhạt/đậm mà 1 seed chung sinh ra được — Ruka xác nhận muốn **primary riêng cho mỗi mode**, không ép 1 seed chung.
  - **Kỹ thuật đề xuất (sạch hơn cách override tay `primary`/`onPrimary`/`primaryContainer` riêng lẻ):** vì `AppTheme.light`/`AppTheme.dark` đã là 2 hàm tách riêng sẵn (từ E1), chỉ cần đổi `seedColor` truyền vào `ColorScheme.fromSeed` khác nhau cho mỗi hàm — `AppTheme.light`: `seedColor: Color(0xFF00A0E0), brightness: Brightness.light`; `AppTheme.dark`: `seedColor: Color(0xFF9290FA), brightness: Brightness.dark`. Vẫn dùng `fromSeed` (giữ nguyên lý do chọn ban đầu: tự sinh `primaryContainer`/`onPrimary`/contrast chuẩn accessibility, không cần Cursor tự kiểm tương phản tay) — chỉ khác 2 mode không còn chung 1 seed như trước.
  - **Lưu ý:** `fromSeed` map hue/chroma của seed vào tone chuẩn M3 (thường tone ~40 cho `primary` ở light, ~80 ở dark) — màu `primary` sinh ra có thể KHÔNG trùng pixel-perfect với mã hex đo được (đặc biệt `#00A0E0` vốn đã khá sáng, ép về tone 40 có thể ra xanh trầm hơn ảnh mẫu). Đây là hành vi đúng của `fromSeed`, không phải lỗi — nếu lên máy thấy lệch tông rõ so với ảnh mẫu, chỉnh lại `seedColor` (thử tăng chroma/đổi hue nhẹ) cho tới khi ưng, không cần match tuyệt đối hex gốc.
  - **Cascade cần làm theo:** marker Coach trên bản đồ (E3) vẽ theo `colorScheme.primary` nên sẽ tự đổi màu theo — cần Ruka xem lại ảnh Light/Dark bản đồ mới, KHÔNG còn tự động đúng "màu teal" như E3 đã chốt. Mọi chỗ đang gọi thẳng field `primary`/`primaryContainer` (chip, button, sao, timeline... từ E4) sẽ tự đổi theo, không cần sửa code thêm — chỉ cần build lại + xem mắt.
  - **2026-08-30: code xong + build Release User xác nhận qua ảnh** — seed mới lên đúng (marker, chip "Rảnh...", nút "Mua" đều đổi tông xanh dương mới, không còn teal). ⚠️ Đúng như lưu ý — tông sinh ra từ `fromSeed` trầm/đậm hơn khá nhiều so với `#00A0E0` (xanh sáng) trong ảnh mẫu gốc (mapping về tone chuẩn M3, không phải lỗi) — **Ruka cần xác nhận tông trầm này có ưng chưa hay muốn tăng chroma/đổi seed để lên sáng/nổi hơn**. **Coach flavor CHƯA build lại** — bản Coach trong ảnh vẫn đang chạy code cũ (teal), do lần build đó Coach được đóng gói trước khi đổi seed, không phải do code thiếu — cần rebuild+cài lại riêng cho Coach để lên cùng tông.
- [ ] **E3 (mở lại theo E1-sửa). Style bản đồ tối giản** — áp JSON style Google Maps (light + dark) đã soạn sẵn, ẩn hết POI/transit, chỉ giữ tên đường + phường/quận, marker Coach theo `colorScheme.primary` (không còn cố định "teal" — theo màu mới từ E1-sửa). **2026-08-28: đã chốt xong với teal, nay cần Ruka xem lại ảnh Light/Dark bản đồ sau khi đổi seed E1-sửa** (marker tự đổi màu theo code cũ, không cần sửa thêm, chỉ cần xác nhận lại bằng mắt). **2026-08-30: đã lên ảnh (Light, User app) — marker đổi đúng theo seed mới, còn Dark + Coach app chưa có ảnh để xác nhận.**
- [x] **E3b. Font chữ + bo góc + độ mượt của shape** (chốt hướng 2026-08-28). Ruka gửi 2 ảnh mẫu tham khảo (1 app tài chính dark-mode dạng card, 1 widget lịch iOS lock screen) — chỉ lấy 3 điểm: font chữ, bán kính bo góc, độ mượt góc bo. Light/Dark giữ nguyên theo hệ thống (E2). **2026-08-28: Cursor báo xong**, làm đúng kiểu "1 lớp theme, không sửa từng màn":
  - **Font:** `google_fonts` + **Inter** — `GoogleFonts.interTextTheme(...)` + `fontFamily` trong `AppTheme`. ColorScheme E2 giữ nguyên.
  - **Radius token (`AppSpacing`):** `radiusSm` 12 (chip/input) · `radiusMd` 16 (button) · `radiusLg` 24 (card/dialog) · `radiusXl` 28 (bottom sheet).
  - **Corner smoothing:** `figma_squircle` — `SmoothRectangleBorder`, `cornerSmoothing: 0.8`, gói qua `AppShapes`, gắn Card/Button/FAB/Chip/Dialog/SnackBar/bottom sheet. Input vẫn `OutlineInputBorder` (API Flutter không nhận `ShapeBorder` cho input). `flutter analyze lib/core`: sạch.
  - **⚠️ Còn sót (chuyển tiếp sang E4):** màn nào tự vẽ `RoundedRectangleBorder` tay (vd bottom sheet trên Map) CHƯA đổi — chỉ widget nào lấy shape từ theme mới tự động lên `AppShapes`. E4 rà màn hình cần tiện thể đổi các chỗ vẽ tay này sang theme/`AppShapes` luôn, không chỉ đổi màu.
- [x] **E4. Rà lại các màn hình chính** (Map, Coach detail, Booking summary/theo dõi, Ví, Lịch sử, Nhật ký, Cộng đồng, Coach Home, Chat) theo ColorScheme mới — thay các màu cứng (hex trực tiếp trong code) bằng token theme, VÀ thay các `RoundedRectangleBorder` vẽ tay còn sót (xem note E3b, vd bottom sheet trên Map) bằng `AppShapes`/token theme. **2026-08-29: Cursor báo xong toàn bộ danh sách ưu tiên**, grep xác nhận trước khi sửa: trong `pilot_demo` không còn hex cứng, chỉ còn `AppColors.*`/`Colors.white` (ở chat) + `RoundedRectangleBorder` tay trên sheet Map — cả 2 đã dọn.
  - Thêm `AppStatusColors` (cặp light/dark riêng, không hardcode 1 hex chung 2 mode) + `bookingStatusPair` cho chip trạng thái Booking; badge streak 3/7 dùng `warning`/`success`.
  - Map + sheet "Coach gần bạn": `AppShapes.sheetTop()` + ColorScheme. Coach detail/summary/pending: ColorScheme + status pair, sao đánh giá = `warningFg`, timeline = `primary`. Ví: đã sạch sẵn từ trước. Lịch sử: chip qua `bookingStatusPair`. Nhật ký/Cộng đồng/chi tiết bài/tạo bài: ColorScheme, tim đã like = `primary`. Coach Home/Active booking/Nhật ký học viên: ColorScheme + status pair. Chat User + Coach: bubble `primaryContainer`/`surfaceContainerHigh` + `AppShapes`.
  - Tiện thể dọn thêm ngoài danh sách gốc: màn tạo hồ sơ (profile setup) + màn danh sách web (đều đang dùng `AppColors`).
  - `flutter analyze lib/features/pilot_demo lib/core/theme/app_status_colors.dart`: sạch. Logic không đổi (chỉ màu + shape).
- [ ] **E5. Test cả 2 mode sáng/tối trên máy**, standalone Release như các phần trước. **Thứ tự: chạy SAU khi E1-sửa (đổi seed color) xong** — test với bảng màu mới, không phải teal cũ. Chụp lại Map/Ví/Theo dõi Booking/Chat ở cả 2 mode gửi Ruka xác nhận trước khi tick.
- [ ] **E6. Icon điều hướng (Nhật ký/Cộng đồng/Lịch sử/Ví) chuyển xuống bottom bar cố định, đè lên bottom sheet** (chốt 2026-08-29). Hiện trạng: 4 icon này (Nhật ký `auto_stories`, Cộng đồng `groups`, Lịch sử, Ví — đã có từ B2/B6/D) đang nằm trong hàng cạnh tiêu đề "Coach gần bạn" ở đầu bottom sheet trên `PilotMapScreen`. Yêu cầu: đưa xuống 1 **bottom bar cố định** (không cuộn theo sheet), **đè/nổi phía trên bottom sheet đang kéo lên/xuống** — kéo sheet lên cao vẫn không che bar.
  - **Đề xuất kỹ thuật:** dùng `Scaffold.bottomNavigationBar` (không tự dựng `Stack`/`Positioned` tay) — tự động nổi cố định trên mọi `body`, kể cả `DraggableScrollableSheet`. Có thể dùng `NavigationBar` (Material 3) hoặc `BottomAppBar`, Cursor chọn cái hợp bố cục hơn — miễn lấy màu/shape từ theme hiện có (`colorScheme.surface`...), không hardcode, tránh phá vỡ E4 vừa dọn.
  - Giữ nguyên hành vi điều hướng của từng icon (mở đúng màn cũ) — chỉ đổi vị trí hiển thị, không đổi logic.
  - Sau khi bỏ hàng icon khỏi header sheet, rà lại khoảng cách/padding quanh tiêu đề "Coach gần bạn" cho gọn (tránh dư khoảng trống do bỏ icon).
  - Test kéo sheet lên hết cỡ / xuống thấp nhất — xác nhận bar mới luôn nổi trên, không bị đá layout với handle kéo của sheet.
  - Test cả Light/Dark trên bar mới (làm cùng đợt E5, dùng bảng màu mới từ E1-sửa).
  - **Phạm vi:** chỉ `PilotMapScreen` (User app) — 4 icon này vốn chỉ có ở đây, Coach app không có tương ứng, không cần đụng.
  - **2026-08-30: lên ảnh — bar 4 icon (Nhật ký/Cộng đồng/Lịch sử/Ví) đã nằm cố định đáy màn Map, tách khỏi header sheet, đúng hướng yêu cầu.** Chưa có ảnh xác nhận việc kéo sheet lên hết cỡ có bị che/đá layout với bar không — cần Cursor xác nhận thêm hoặc Ruka tự kéo thử trên máy.
  - **⚠️ Mở rộng E6 (chốt 2026-08-30):** hiện tại 4 icon vẫn `Navigator.push` sang màn riêng (có AppBar + nút back góc trên) — Ruka muốn bottom bar **luôn cố định khi đã chuyển tab**, không cần bấm back mới quay lại/đổi tab khác, chuyển nhanh như tab thật. Nghĩa là Map + Nhật ký + Cộng đồng + Lịch sử + Ví phải thành **5 tab anh em dùng chung 1 bottom bar**, không phải push/pop từng màn.
    - Đề xuất kỹ thuật: 1 shell screen mới (vd `MainShellScreen`) chứa `IndexedStack` 5 widget (`PilotMapScreen`, `MyJournalScreen`, `CommunityFeedScreen`, `UserBookingHistoryScreen`, `UserWalletScreen`) + `Scaffold.bottomNavigationBar` dùng chung, đổi tab qua `setState`/`currentIndex`, KHÔNG `Navigator.push`. `IndexedStack` giữ nguyên state từng tab khi chuyển qua lại (không mất vị trí cuộn).
    - 4 màn con khi nhúng vào shell không tự có `Scaffold`/AppBar back nữa (bỏ nút back, vì không còn là push) — đổi entry point: nơi đang mở `PilotMapScreen()` trực tiếp (`app_root_screen.dart`) đổi sang mở `MainShellScreen()`.
    - Các luồng "đào sâu" từ trong từng tab (vd tap Coach → Coach detail, tap bài viết → chi tiết bài, tap booking → theo dõi booking) VẪN `Navigator.push` bình thường (có back) — chỉ 5 màn gốc là tab, không đổi cách các màn con-của-con hoạt động.
- [ ] **E7. Card: bỏ viền, đổi nền theo % sáng/tối, radius nhỏ lại 15-20px** (chốt 2026-08-30, sau khi Ruka xem ảnh Dark + xác nhận tông màu E1-sửa ổn). Áp toàn bộ `Card`/card-like container trong app (Map sheet, Coach gần bạn, Ví, Lịch sử, Nhật ký, Cộng đồng...), 1 chỗ trong theme, không sửa từng màn:
  - **Bỏ viền:** hiện `CardTheme`/từng nơi đang có `side: BorderSide(color: outlineVariant...)` (viền mảnh, theo hướng dẫn cũ ở E4) — bỏ hẳn `side`, dựa vào chênh nền để tách card khỏi background, không dùng viền nữa.
  - **Nền card lệch tông so với nền chính** (thay border): light mode = nền chính (`colorScheme.surface`) đậm hơn ~10%; dark mode = nền chính sáng hơn ~15%. Đề xuất tính bằng blend thay vì mượn thẳng `surfaceContainer*` có sẵn của M3 (tông container chuẩn M3 có thể không đúng % yêu cầu) — vd trong `AppTheme`:
    ```dart
    // light
    cardColor: Color.alphaBlend(Colors.black.withOpacity(0.10), colorScheme.surface)
    // dark
    cardColor: Color.alphaBlend(Colors.white.withOpacity(0.15), colorScheme.surface)
    ```
    Gán qua `CardTheme.color` (và bất kỳ nơi nào tự vẽ nền card bằng `Container` thay vì `Card`, đổi cùng 1 màu này cho nhất quán) — 1 định nghĩa dùng chung, không hardcode lại ở từng màn.
  - **Radius:** card hiện dùng `AppSpacing.radiusLg` (24, dùng chung với dialog) — tách riêng, đổi card sang dùng `AppSpacing.radiusMd` (16, đã có sẵn, nằm đúng khoảng 15-20px Ruka muốn) thay vì tạo token mới. Dialog vẫn giữ `radiusLg` (24), không đổi.
  - Test lại cả Light/Dark sau khi đổi — card giờ phải phân biệt được với nền chính chỉ bằng độ đậm/nhạt, không còn viền, góc bo nhỏ/gọn hơn trước.
- [ ] **E8. Màu chính xác cho tag/highlight/sao/tab active** (chốt 2026-08-31). Ruka cho hex cụ thể (đo/chọn tay, KHÔNG qua `fromSeed`) cho vài chỗ — áp Light như sau, Dark tự suy ra tương ứng (Ruka đồng ý để Cursor tự tính, gửi ảnh duyệt lại):
  | Thành phần | Light | Dark (suy ra, giữ đúng hue, tăng độ sáng cho đủ tương phản) |
  |---|---|---|
  | Nền tag (chip "Rảnh...", tag bài Cộng đồng, tag gói trong Ví) | `#EFF3FA` | `Color.alphaBlend(Colors.white.withOpacity(0.12), colorScheme.surface)` — dùng lại cơ chế blend như nền Card ở E7, không bịa hex riêng |
  | Chữ/highlight "Rảnh 18:00..." + ngôi sao đánh giá | `#346B34` | `#7BC17B` |
  | Tab active (bottom bar, sau khi lên tab cố định ở E6) | `#275F95` | `#7BAEE0` |
  - **Ngôi sao đánh giá:** đổi luôn sang **dạng phẳng, không đổ bóng/gradient/radial** (hiện có thể đang dùng icon Material mặc định có sẵn shading) — dùng `Icons.star`/`Icons.star_outline` tô phẳng 1 màu theo bảng trên, không thêm `BoxShadow`/`RadialGradient`.
  - **Tim đã thả (like bài Cộng đồng):** màu đỏ chuẩn Material (`Colors.red` hoặc `colorScheme.error` nếu muốn theo theme) khi đã like — không cần đo hex riêng, giữ đơn giản.
  - Định nghĩa các màu này 1 lần trong `AppTheme`/1 file màu riêng (không hardcode lặp lại ở từng màn) — cùng tinh thần `AppStatusColors` đã có từ E4, có thể gộp thẳng vào đó (`AppStatusColors.tagBackground`, `.availableHighlight`, `.tabActive`) thay vì tạo class mới.
  - Lưu ý: đây là màu **hardcode tay**, đứng ngoài `ColorScheme.fromSeed` (khác cách làm ở E1-sửa) — Cursor không cần tự suy luận từ seed, dùng đúng số Ruka cho.
  - Test cả Light/Dark, gửi ảnh Ví/Cộng đồng/Map (bottom tab) xác nhận.
- [ ] **E9. Logo header thay chữ "PSgy (Dev)"** (chốt 2026-09-01). Ruka tự thiết kế xong logo (icon pulse/tạ ghép chữ "PS", có bản "gym...PS" cho User + "gym...PS coach" cho Coach) — logo này **đã có sẵn trong app** (đang hiện thành 1 banner riêng ngay dưới AppBar trên Map/Coach Home, thấy trong ảnh Ruka gửi). Yêu cầu: dùng ĐÚNG logo đang có sẵn đó, chuyển vị trí lên làm title của `AppBar` (thay hẳn chữ "PSgy (Dev)" / "PSgy Coach (D...)"), không phải làm logo mới.
  - Tìm đúng widget/asset logo đang render banner dưới AppBar hiện tại (Cursor tự xác định trong `PilotMapScreen`/`CoachHomeScreen` hoặc shell mới từ E6) — gán làm `AppBar.title`, bỏ `Text("PSgy (Dev)")`/`Text("PSgy Coach (Dev)")` cũ, bỏ luôn banner cũ phía dưới (không lặp lại 2 chỗ).
  - Kích thước vừa chiều cao chuẩn AppBar (không vỡ layout), giữ đúng logo User cho app User, logo Coach cho app Coach.
  - Kiểm tra logo hiển thị ổn cả Light/Dark (nếu logo có màu cố định/nền trong suốt, cần test trên cả 2 nền AppBar sáng/tối).
  - Nút "Chuyển sang Coach"/"Chuyển sang User" ở góc phải AppBar giữ nguyên vị trí, không đụng.
- [ ] **E10. Xoá logo ParkingLink cũ trên màn hình chờ (splash) khi mở app** (chốt 2026-09-01). Ruka phát hiện cả 2 app (User + Coach) khi mở lên còn hiện 1 màn nền xanh với logo ParkingLink cũ trước khi vào app — sót lại từ lúc clone (Clone-Checklist đã đổi icon Home Screen + tên hiển thị, nhưng CHƯA đụng tới splash/launch screen, đây là tài sản riêng khác `app_icon.png`). Yêu cầu: xoá logo cũ đó, không cần thay logo mới (trừ khi Ruka muốn dùng luôn logo mới ở E9 — hỏi lại nếu Cursor thấy hợp lý hơn để trống).
  - Cursor kiểm tra: (a) `ios/Runner/Base.lproj/LaunchScreen.storyboard` (mặc định Flutter/Xcode) có đang tham chiếu ảnh logo ParkingLink không, hoặc (b) dự án có dùng package `flutter_native_splash` không (kiểm tra `pubspec.yaml` + `flutter_native_splash.yaml` nếu có) — sửa đúng chỗ đang thật sự cấu hình splash, không đoán mò.
  - Xoá/gỡ image logo ParkingLink khỏi storyboard hoặc config splash, giữ nguyên màu nền (hoặc đổi màu nền cho khớp `#3B82F6`/theme mới nếu Cursor thấy hợp) — miễn không còn logo cũ.
  - Áp cho CẢ 2 flavor (User + Coach) — kiểm tra xem 2 flavor có dùng chung 1 LaunchScreen hay tách riêng (`ios/Runner/` thường dùng chung 1 storyboard cho mọi flavor trừ khi đã setup riêng từ trước).
  - Build lại Release cả 2 app, rút dây, mở tay từ Home Screen để thấy đúng màn chờ lúc cold-start (khác psplash Flutter's default "flash" trắng — đây là native launch screen, phải test mở thật, không phải hot-reload).

**Mục E — TẠM DỪNG ở đây theo quyết định Ruka (2026-08-31): "về UI tạm thời đã xong", đủ dùng cho bản demo bàn giao.** Các dòng sau vẫn còn `[ ]` (chưa có ảnh xác nhận cuối cùng: E1-sửa tông màu Coach app, E3 Dark+Coach, E6 mở rộng tab cố định, E7 card, E8 màu tag/highlight/tab) — không tự tick, để nguyên làm **backlog tinh chỉnh UI** quay lại sau nếu cần, KHÔNG chặn tiến độ sang mục C. Nếu code các phần này đã chạy được (không lỗi, không crash) thì xem như đủ điều kiện demo dù UI chưa hoàn toàn khớp 100% ảnh mẫu.

---

## C. Admin tool — **TẠM HOÃN, chưa bắt đầu** (chốt 2026-08-31: Ruka muốn để team thảo luận thêm trước khi build, quay lại hoàn thiện 2 app User/Coach trước)

Hướng kỹ thuật đã chốt sẵn cho khi nào quay lại (không cần bàn lại từ đầu):

- [x] **C0. Xác nhận lại hướng xây** — **2026-08-31: Ruka chốt hướng (nhưng CHƯA bắt đầu code).** **Flutter Web**, theo đúng mẫu `parkinglink_monitor_web` (repo cũ, tham khảo cấu trúc/pattern, không copy business logic) — **project Flutter độc lập hoàn toàn** (`pubspec.yaml`/`lib/` riêng), đặt trong thư mục con `admin_web/` ngay trong repo `psgy` hiện có (không gộp chung package với app mobile, để dễ bỏ nếu đổi hướng — không đụng gì tới User/Coach nếu xoá). 3 tính năng chính: (1) bản đồ tối giản xem gym thị trường + gym trong hệ thống, (2) danh sách Coach/PT chờ duyệt, (3) tool đánh dấu ưu tiên Coach (đẩy lên đầu list bên User app, có giới hạn mock xuyên app — xem C5).
- [ ] **C1. Danh sách Coach chờ duyệt** (`approvalStatus = pending`) → Duyệt/Từ chối
- [ ] **C2. Danh sách Support Ticket** từ Coach/User → xem, trả lời (mock)
- [ ] **C3. Đặt tên** → "PSGymer Admin"
- [ ] **C4. Bản đồ tối giản — gym thị trường vs gym trong hệ thống** (chốt 2026-08-31). Domain hiện tại (`pilot_demo`) CHƯA có khái niệm "Gym" (chỉ có `Coach`) — cần model mock mới riêng cho Admin, không đụng model Coach hiện có:
  - Model mới `MockGym` (id, name, vị trí lat/lng, `status`: `inSystem` / `market` — "đã vào hệ thống" / "thị trường, chưa vào"). Seed tay vài điểm quanh HCMC (giống cách seed Coach ở `mock_coaches.dart`), trộn cả 2 trạng thái.
  - Bản đồ dùng lại đúng JSON style tối giản đã có từ E3 (ẩn POI/transit, chỉ giữ tên đường/phường/quận) — Admin không cần soạn style mới. Marker phân biệt 2 trạng thái bằng màu (vd `inSystem` = màu primary, `market` = xám/outline) — Cursor đề xuất, không cần xin ảnh mẫu.
  - **Vì đây là dữ liệu MOCK thuần** (chưa có nguồn thật như Google Places API) — chỉ minh hoạ đúng khái niệm màn hình cho đội dev, không phải danh sách gym thị trường thật. Đội dev thật sẽ tự nối nguồn dữ liệu thật khi build bản production.
- [ ] **C5. Tool đánh dấu Coach ưu tiên** (chốt 2026-08-31 — CÓ ảnh hưởng thứ tự hiển thị User app, không chỉ cờ nội bộ Admin). Thêm field `isPriority` (bool) vào Coach — Admin có công tắc bật/tắt trên danh sách Coach.
  - **⚠️ Giới hạn quan trọng cần Ruka biết trước khi giao Cursor:** giai đoạn này Admin Web / User app / Coach app là **3 app Flutter tách rời, mỗi app 1 phiên mock riêng, KHÔNG có backend thật kết nối xuyên app** (đúng giới hạn đã biết từ đầu dự án — xem `MockUserSession`/`MockCoachSession` độc lập ở A5/B4/D9). Nghĩa là bật cờ ưu tiên bên Admin Web sẽ **KHÔNG** tự động phản ánh sang User app đang chạy trên máy khác/phiên khác — chỉ demo được ĐÚNG HÀNH VI mong muốn (sort logic) trong nội bộ từng app bằng mock data seed sẵn, chưa phải luồng nối thật xuyên 3 app.
  - Cách demo trong giới hạn trên: (a) Admin Web — toggle `isPriority` trên danh sách Coach, cập nhật UI tại chỗ (mock, không persist thật). (b) User app — sửa `mock_coaches.dart`: seed sẵn 1 Coach với `isPriority = true`, sửa logic sort của list "Coach gần bạn" trên `PilotMapScreen`: Coach `isPriority = true` luôn lên đầu (bất kể khoảng cách), phần còn lại vẫn sắp theo khoảng cách như cũ. Đây là việc sửa thêm bên User app (`pilot_demo`), không chỉ riêng Admin.
  - Đội dev thật khi có backend sẽ nối field `isPriority` này qua Firestore thật để Admin bật cờ ảnh hưởng User app real-time — bản tham khảo chỉ cần đúng UI/UX + đúng hành vi sort, không cần nối thật.

---

## ⚠️ Sửa lại quyết định Package (chốt 2026-08-25)

**Bối cảnh:** Lúc build A6 (Coach quản lý "Gói dịch vụ" riêng) và B2 (User xem/mua gói theo từng Coach), hiểu nhầm mô hình. Ruka làm rõ lại: gói là **ví tiền nạp trước do HỆ THỐNG (Admin) bán**, KHÔNG phải Coach tự tạo — đúng tinh thần "phòng gym phi tập trung": User mua gói 1 lần, dùng được với BẤT KỲ Coach nào, không mất tiền nếu đổi Coach/ngừng dùng 1 Coach (khác thẻ hội viên phòng gym franchise tập trung, dễ mất tiền nếu phòng đóng cửa).

**Mô hình đúng:**
- `Package` (loại gói hệ thống bán — vd "Gói 5 buổi", "Gói 10 buổi"): KHÔNG có `coachId`. Giá trị thật là **số dư VND nạp trước** (`totalPriceVnd`), tên "X buổi" chỉ mang tính tiếp thị/tham khảo — không phải đơn vị trừ thật.
- User mua 1 `Package` → tạo ví cá nhân (`remainingBalanceVnd` khởi tạo = `totalPriceVnd`), dùng được với mọi Coach.
- Khi đặt lịch dùng ví: **trừ đúng giá dịch vụ thật của Coach đó** khỏi số dư ví (không phải trừ "1 buổi" cố định) — vì Coach khác nhau giá khác nhau, ví sẽ dư hoặc thiếu tuỳ Coach.
  - Nếu số dư đủ → trừ thẳng, không cần trả thêm.
  - Nếu số dư KHÔNG đủ → cho User chọn: (a) trả thêm phần chênh lệch bằng tiền mặt để đủ đặt dịch vụ, hoặc (b) bỏ dùng ví, trả tiền mặt trực tiếp cho Coach như bình thường.
- Vẫn giữ nguyên phương thức "tiền mặt trực tiếp sau khi xong dịch vụ" (mặc định cũ, không đổi) — 2 phương thức song song: tiền mặt / dùng ví gói.

**Việc cần sửa lại (đã build sai theo mô hình cũ):**
- [x] **A6-sửa. Bỏ tab "Gói dịch vụ" Coach tự tạo** trong `coach_services_screen.dart` — Coach chỉ còn quản lý Dịch vụ lẻ (giá riêng từng Coach, giữ nguyên). Gỡ `MockCoachSession` phần seed gói riêng theo Coach. **2026-08-25: xong.** Bỏ hẳn `TabBar` (chỉ còn 1 tab nên thừa) — màn "Dịch vụ của bạn" giờ là AppBar + list + FAB thêm, xác nhận qua ảnh chụp trên máy. `MockCoachSession` bỏ seed `mockPackagesCoach01` + field/method `packages`/`upsertPackage`/`removePackage`. `MockPackage` model + `mockPackagesCoach01` vẫn giữ ở phía User (`mock_coaches.dart`) để tái dùng cho gói hệ thống (B2-sửa). `dart analyze` sạch.
- [x] **B2-sửa. Nguồn gói đổi thành danh sách hệ thống dùng chung** (không lấy theo `coach_01.packages` nữa) — tạo danh sách `Package` cố định toàn hệ thống, hiển thị + mua ở màn riêng, `MockUserSession.purchasePackage` sửa thành tạo ví thay vì gắn theo `coachId`. **2026-08-30: xác nhận đã xong** (đã làm cùng lúc với B2 gốc ngày 2026-08-25, dòng theo dõi này bị sót chưa tick — không phải việc mới). Cursor đối chiếu code: `MockPackage` chỉ còn `id`/`name`/`sessionCount`/`totalPriceVnd`/`description`/`validityDays`, không còn `coachId`; catalog `mockSystemPackages` dùng chung mọi Coach (comment "shared across every Coach").
- [x] **B3 (làm lại theo mô hình mới).** Đặt lịch dùng ví: trừ đúng giá dịch vụ khỏi `remainingBalanceVnd`; nếu thiếu → cho chọn trả thêm tiền mặt phần chênh lệch hoặc chuyển hẳn sang trả tiền mặt trực tiếp Coach. **2026-08-30: xác nhận đã xong** (cùng đợt B3 gốc 2026-08-25, dòng theo dõi sót chưa tick). Cursor đối chiếu: `placeBooking` nhận `priceVnd: service.priceVnd` (giá dịch vụ thật, không phải "1 buổi" cố định), ví trừ `priceVnd - topUpAmountVnd`; flow ở `booking_summary_screen.dart` (`paymentMethod = wallet`). Khi `shortfall > 0`: có đủ 2 lựa chọn trả thêm tiền mặt phần chênh lệch / đổi hẳn sang tiền mặt trực tiếp.

**Mục "Sửa lại quyết định Package" — HOÀN THÀNH (2026-08-30).** Cả 3 việc A6-sửa/B2-sửa/B3 đều đã tick, không còn việc treo.

- [ ] **B2-content. Đổi catalog gói: 3/5/10 buổi thay vì 10/20 buổi** (chốt 2026-08-30, riêng nội dung số liệu, không đụng lại model/logic đã xong ở B2-sửa/B3). Ruka thấy 2 gói cũ (10 buổi/20 buổi) quá nhiều buổi — đổi `mockSystemPackages` thành 3 gói:
  - **Gói 3 buổi** — 900.000đ (300k/buổi, không giảm) · Hạn dùng 30 ngày · "Phù hợp thử nghiệm, linh hoạt lịch trong 1 tháng."
  - **Gói 5 buổi** — 1.400.000đ (280k/buổi) · Hạn dùng 60 ngày · "Tiết kiệm hơn tập lẻ, linh hoạt lịch trong 2 tháng."
  - **Gói 10 buổi** — 2.500.000đ (250k/buổi, giữ nguyên giá + hạn dùng của gói 10 buổi cũ) · Hạn dùng 90 ngày · "Linh hoạt lịch trong 3 tháng, tiết kiệm so với tập lẻ."
  - Bỏ hẳn gói 20 buổi. Giá tính theo tham khảo dịch vụ Coach ~300k/buổi (Tập cá nhân 60 phút), giảm dần theo số buổi — Ruka đã duyệt mức này.
  - Chỉ sửa dữ liệu seed (`mockSystemPackages` trong `mock_coaches.dart` hoặc nơi đang khai báo) — không đụng `MockUserSession.purchasePackage`/logic trừ ví (đã đúng từ B2-sửa/B3).
  - **2026-08-31: Cursor báo code xong, đúng 3 mức giá/hạn dùng như brief** (3 buổi/900k/30 ngày, 5 buổi/1.4tr/60 ngày, 10 buổi/2.5tr/90 ngày, bỏ gói 20 buổi), logic ví không đụng. Đã build Release User, cài lên máy X. **Chờ Ruka chụp màn "Ví của tôi" (tab Ví) xác nhận hiển thị đúng 3 gói trước khi tick** — lưu ý mock session không persist nên mở app mới ví đã mua sẽ trống, chỉ catalog phía trên hiển thị 3 gói.
  - **⚠️ 2026-09-02: VÔ HIỆU — xem "Đảo ngược quyết định Package LẦN 2" ngay dưới đây.** Toàn bộ hướng ví hệ thống bị bỏ, B2-content không còn ý nghĩa (không còn `mockSystemPackages`/`user_wallet_screen.dart` để chứa 3 gói này nữa).

---

## ⚠️ Đảo ngược quyết định Package — LẦN 2 (chốt 2026-09-02, sau họp team)

**Bối cảnh:** Ruka họp team 2026-09-02, thống nhất quay lại đúng mô hình GỐC trước ngày 2026-08-25 — **huỷ bỏ hướng "ví hệ thống dùng chung mọi Coach"** (B2/B2-sửa/B3/B2-content ở trên), **khôi phục Coach tự tạo Gói riêng** (đúng model A6 gốc, trước khi bị A6-sửa gỡ bỏ). Lý do đổi lại: team quyết định business, không phải lỗi kỹ thuật — Claude không có đủ context lý do cụ thể, chỉ ghi nhận quyết định.

**Mô hình mới (= mô hình gốc, khôi phục lại):**
- Mỗi Coach có 2 loại trong phần "Dịch vụ/Gói" của họ:
  1. **Dịch vụ (lẻ, 1 buổi)** — như hiện tại, Coach tự đặt giá riêng từng dịch vụ (Tập cá nhân, Tập cặp đôi, Tư vấn dinh dưỡng...). **MỚI: bắt buộc Coach luôn có ÍT NHẤT 1 dịch vụ dạng này**, hiển thị Ở ĐẦU danh sách — đảm bảo User luôn có lựa chọn "tập thử 1 buổi" trước khi cân nhắc mua Gói nhiều buổi.
  2. **Gói (nhiều buổi)** — khôi phục lại: Coach tự tạo (tên gói, số buổi, tổng giá) — CHỈ dùng được với ĐÚNG Coach đó tạo ra nó, không dùng chéo Coach khác (khác hẳn ví hệ thống vừa bỏ).
- User mua Gói của 1 Coach cụ thể → có số buổi còn lại RIÊNG cho Coach đó. Đặt lịch dùng Gói → trừ **1 buổi** mỗi lần dùng (không phải trừ theo giá dịch vụ/tiền như bản B3 sửa vừa rồi) — quay lại logic đơn giản gốc.
- **KHÔNG còn khái niệm ví/wallet cross-Coach, không còn `user_wallet_screen.dart`, không còn tab "Ví" trên bottom bar.**

**Việc cần làm (đảo ngược lại các phần đã sửa gần đây):**

- [ ] **A6-sửa-2. Khôi phục tab "Gói" trên `coach_services_screen.dart`** — đưa lại `TabBar` 2 tab (Dịch vụ / Gói), Coach tự thêm/sửa/xoá Gói riêng (tên, số buổi, tổng giá) — đúng UI gốc trước A6-sửa (menu 3 chấm sửa/xoá, FAB `+` theo tab, đã có sẵn pattern cũ, khôi phục lại không phải làm mới từ đầu).
  - **Kèm yêu cầu MỚI:** validate Coach luôn có ≥1 "Dịch vụ" (không được xoá hết, danh sách Dịch vụ trống) — chặn xoá dịch vụ cuối cùng hoặc cảnh báo rõ, để đảm bảo luôn có ít nhất 1 lựa chọn tập thử 1 buổi. Sắp xếp: mục Dịch vụ hiển thị TRÊN mục Gói (thứ tự ưu tiên Dịch vụ trước).
- [ ] **B2-sửa-2. Gỡ bỏ toàn bộ hướng ví hệ thống, khôi phục gói theo Coach**
  - Gỡ `user_wallet_screen.dart`, `MockWalletPackage`, `MockUserSession.wallets`, `mockSystemPackages`, `purchasePackage` kiểu hệ thống.
  - Khôi phục `MockPackage` có lại field `coachId`.
  - Khôi phục `coach_detail_screen.dart` có tab "Gói" hiển thị + mua đúng Gói của Coach đang xem (như bản gốc trước B2-sửa).
  - Gỡ tab "Ví" khỏi bottom bar (xem E6-sửa bên dưới).
- [ ] **B3-sửa-2. Đặt lịch dùng Gói: trừ theo SỐ BUỔI, không theo tiền** — `booking_summary_screen.dart` lựa chọn `paymentMethod = package` trỏ đúng Gói của Coach đang đặt, mỗi lần dùng trừ 1 buổi khỏi số buổi còn lại của đúng gói đó (bỏ hẳn logic trừ theo `priceVnd`/"trả thêm chênh lệch" của B3 bản sửa trước — không còn phù hợp vì gói giờ tính theo SỐ BUỔI cố định do Coach tự đặt, không phải số dư tiền).
- [ ] **E6-sửa. Bỏ tab "Ví" khỏi bottom bar** — bottom bar còn lại 4 tab: Map / Nhật ký / Cộng đồng / Lịch sử. Mua/xem Gói giờ chỉ nằm trong `coach_detail_screen.dart` của từng Coach, không có màn tổng hợp riêng.
- Ghi chú: B2-content (catalog 3/5/10 buổi hệ thống) **coi như bị huỷ theo** — không cần Cursor làm/sửa gì thêm cho nó, đã đánh dấu vô hiệu ở dòng B2-content phía trên.

---

## F. Coach Detail + Xác nhận đặt lịch mở rộng (chốt 2026-09-04)

Yêu cầu Ruka, phía **User app**, không đụng Coach app. Chi tiết đầy đủ trong prompt gửi Cursor `cursor_prompt_coach_detail_booking_v2.md`.

- [ ] **F1. `coach_detail_screen.dart` — thêm thông tin Coach + đánh giá**, đổi thứ tự bố cục: Header → **MỚI** Card "Giới thiệu" (bio do Coach viết: kinh nghiệm/kỹ năng/thành tựu, field mới `bio` trên `MockCoachProfile`) → Chọn dịch vụ (giữ nguyên) → **MỚI** Card đánh giá tổng quan (điểm trung bình + % phân bổ theo sao 5-1) → **MỚI** Danh sách bình luận khách hàng (mới nhất lên đầu) → nút "Tiếp tục".
  - Model mới `MockCoachReview` (`id`/`coachId`/`reviewerName`/`rating`/`comment`/`date`) — **đã chốt: seed mock riêng theo Coach** (không gộp từ rating booking B5), seed 5-8 review đa dạng sao cho `coach_01`.
- [ ] **F2. `booking_summary_screen.dart` — thêm Địa chỉ, Trao đổi Coach, Mã giảm giá**: **MỚI** Card "Địa chỉ" (nhập tay) + nút "Trao đổi với Coach" → **đã chốt: mở thẳng `user_chat_screen.dart` luôn**, nới điều kiện chat (thêm luồng chat riêng theo `coachId`, không cần `bookingId`, tách biệt đơn giản với chat theo booking đã có ở B4, không đổi B4) → Phương thức thanh toán (giữ nguyên, theo B3-sửa-2) → **MỚI** Card "Mã giảm giá" (**đã chốt: chỉ UI, chưa cần logic áp dụng thật**) → Hoá đơn (giữ nguyên) → nút "Đặt lịch" (giữ nguyên).
- Sau khi xong: `flutter analyze lib/features/pilot_demo` sạch, build Release User app, gửi ảnh Coach Detail (Giới thiệu + đánh giá + bình luận), Booking summary (Địa chỉ + nút Trao đổi + Mã giảm giá), và màn Chat mở từ nút Trao đổi (trước khi có booking).

---

## Lưu ý xuyên suốt

- Dữ liệu mock/mẫu là đủ cho TOÀN BỘ giai đoạn này — không cần Firestore rules thật, không cần domain entities thật (đó là việc Checkpoint 3-6 cũ, tạm dừng, đội dev mới sẽ làm lại đúng chuẩn với data thật).
- Vẫn tuân thủ Clean Architecture đã có — đội dev đọc code hiểu được, không viết ẩu.
- Mỗi mục build xong đều chạy `flutter analyze` sạch trước khi qua mục tiếp theo (đúng thói quen đã có).

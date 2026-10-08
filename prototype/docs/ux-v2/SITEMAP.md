PSgy — UX v2.2: Sơ đồ màn hình + luồng (cập nhật 2026-10-08)

v2.2: Ruka xác nhận "Figma chỉ là tham khảo, căn cứ bối cảnh mà thêm cho hợp lý". Claude bổ sung các phần Figma chưa có hoặc chưa đọc được:

Kết thúc buổi tập (2.6b)
Ví PSGymer (2.10)
Đăng nhập / chờ duyệt PT (3.0)
PT Thu nhập (PI1) · PT Tôi (PM1) · Thông báo PT (PN1)
PT huỷ / đổi lịch / không đến (2.6c)

Các phần thêm mới có đánh dấu [Claude bổ sung] để Ruka dễ rà lại.

Nguồn:

Tài liệu UX + Business Model + Discovery của Ruka
Figma soYj2hNZugy8KokT5pxJu3, đã đọc các frame: Map, Discovery, Chat, Profile, PT Profile, Booking, PT Tổng quan, PT Công việc, PT Chat, ghi chú luồng buổi tập
Ảnh tham khảo từng frame nằm trong figma_ref/, mã ảnh ghi trong ngoặc, vd [U01]

File này thay thế danh sách màn U01–U22 / C01–C07 của audit cũ.

Quy tắc khi 2 nguồn khác nhau:

Theo quyết định ghi ở mục 0.
Chỗ chưa có quyết định → bố cục theo Figma, quy tắc nghiệp vụ theo tài liệu chữ.

Màu sắc trong Figma chưa thống nhất (mỗi frame một tông). Bước này chưa làm style, giữ tokens hiện có.

0. Quyết định của Ruka (2026-10-08)

| # | Quyết định |
|---|------------|
| 1 | Bỏ hẳn Nhật ký / Cộng đồng. App không phải mạng xã hội. Streak và thành tích nằm trong Profile User. |
| 2 | Phạm vi: User App + PT Center. Admin làm sau. |
| 3 | Các vị trí kiếm tiền dựng dạng mẫu, bật/tắt bằng cờ monetization. |
| 4 | Gọi "PT". Phía PT là "PT Center". |
| 5 | Thứ tự đặt lịch theo Figma: Gói → Thời gian → Địa điểm → Xác nhận & thanh toán. |
| 6 | Tên app: PSGymer. Ví nền tảng gọi là "Ví PSGymer" (Figma ghi FITMATCH / OnFitness thì đổi hết). Tên đặt trong src/config/brand.ts. |
| 7 | Camera AI = chụp ảnh và phân tích hình thể (theo Figma). Không làm quay/tải video. |
| 8 | Đánh giá: User chấm 3 mức + tag. Trên hồ sơ PT quy đổi ra sao 1–5 giống Figma ("4.8 ★ / 22 đánh giá"). Vẫn giữ thêm "Uy tín x/100". |

1. Nguyên tắc chung

Bottom nav User (luôn hiện ở 5 màn gốc) [U01]: Discovery · Map · Chat · Camera AI · Profile.
Bottom nav PT Center: Tổng quan · Công việc · Chat · Thu nhập · Tôi.
Màn chi tiết (PT Profile, Đặt lịch, Buổi tập, Chat chi tiết) mở toàn màn hình, ẩn bottom nav.
Không hardcode quy tắc nghiệp vụ. Tất cả nằm trong src/config/business.ts, sửa được trong bảng điều khiển (mục 6).
User và PT Center dùng chung dữ liệu. Hành động bên này phải hiện ngay bên kia, kèm thông báo trượt từ trên xuống như push notification.
Nội dung trả tiền (Được tài trợ / Nổi bật / Boost) có nhãn rõ ràng. Boost không đổi rating, review, level hay số liệu thật.
Popup thời điểm (trước buổi tập, đến giờ…) hiện khi mở app hoặc khi đồng hồ giả lập đi tới mốc đó. Đóng popup vẫn xem lại được trong màn Buổi tập.

2. USER APP

2.1 Vào app [U01]

UO1 Splash / loading: logo + thanh tải.
UO2 Đăng nhập: "Tiếp tục với Google" · "Tiếp tục với Apple" (giả lập) · link Điều khoản & Quyền riêng tư. (Figma ghi "Thiếu màn hình LOGIN" → dựng theo tài liệu chữ.)
UO3 Thiết lập nhanh: 1 màn cuộn dọc, có nút "Bỏ qua" ở góc.
Tên · tuổi · giới tính
Mục tiêu (chọn nhiều): Giảm mỡ · Tăng cơ · Cải thiện sức khỏe · Tăng sức bền · Khác
Khu vực
Avatar (chọn từ kho mẫu)
UO4 Quyền vị trí: Cho phép / Để sau.
→ Map + popup "Bạn muốn tìm gì?" [U01]:
2 thẻ ảnh: Tìm PT (Huấn luyện cá nhân, tập cùng chuyên gia) · Tìm Phòng Gym (Phòng tập gần bạn, đa dạng tiện ích).
Chọn thẻ nào → Map mở đúng tab đó.
Bấm X → mặc định tab PT.
Popup chỉ hiện 1 lần với user mới.

User cũ mở app → vào thẳng Discovery.

2.2 Discovery — UD1 (tab 1) [U02]

Bố cục:

Ảnh PT tràn màn hình, nền tối.
Phía trên: chấm báo số ảnh của PT đang xem.
Hai bên: mũi tên trái/phải. Vuốt ngang xem ảnh khác của cùng PT; vuốt dọc sang PT khác.
Góc dưới trái: avatar · tên · dấu xác minh · nhãn "PT" · khoảng cách.
Bên phải: nút ❤ Lưu PT (lưu vào danh sách "Đã lưu" của User — lưu PT, không phải lưu ảnh) · nút ⋮.
Chạm avatar/tên → UP1.

Không có: like · bình luận · chia sẻ · lưu ảnh · follow · số lượt tương tác. (Figma có ghi chú "Chia sẻ post" — theo tài liệu chữ là KHÔNG có.)

Menu ⋮ → sheet: Báo cáo · Không thích PT này · Huỷ.

UR1 Báo cáo — sheet "Báo cáo PT này":

Lý do: Hình ảnh không phù hợp · Thông tin sai sự thật · Có hành vi quấy rối · Lừa đảo / Trục lợi · Giả mạo · Khác (nhập)
Nút: Gửi báo cáo / Huỷ → thông báo cảm ơn

Không thích — popup:

"Không thích PT này?" · "PT này sẽ được ẩn khỏi Discovery. Bạn sẽ ít thấy PT này hơn trong tương lai."
Nút: Ẩn PT này / Huỷ
Sau khi ẩn: thông báo nhỏ kèm nút Hoàn tác. Không báo cho PT.

Thẻ "Được tài trợ" xen kẽ trong feed (cờ monetization).

Thứ tự hiển thị (mô phỏng):

Chia PT theo nhóm khoảng cách: ≤ 3 km, 3–7 km, > 7 km.
Trong mỗi nhóm ưu tiên: PT mới / chưa xem → có ảnh mới → chất lượng → xáo trộn nhẹ.
Công thức chính thức do Bảo đề xuất.
Bảng điều khiển có công tắc "Hiện lý do xếp hạng".

Ảnh hết hạn: ảnh quá media_expire_days (15 ngày) không hiện.

Ghi nhận phiên xem: PT đã hiện / đã xem / bỏ qua / mở hồ sơ / quay lại / không thích / báo cáo — lưu vào store.

2.3 Map — UM1 (tab 2) [U01]

Phần trên:

Tiêu đề "Tìm Gym/PT".
4 tab: All · PT · Gym · Spa.
Chip lọc theo tab:
PT: Bán kính 3 km ▾ · Còn lịch hôm nay · Chuyên môn · nút bộ lọc
Gym: Bán kính 3 km ▾ · Còn chỗ trống · Tiện ích
Spa: Bán kính · Ưu đãi · Dịch vụ

Bản đồ:

Chấm xanh vị trí User + vòng bán kính có nhãn "3 km".
Marker PT là avatar tròn; Gym/Spa là ảnh vuông bo góc.
Cluster = vòng tròn có số. Bấm cluster → hiện callout "Cụm 5 — 5 PT ở gần nhau" + zoom vào.
Vị trí PT là điểm đại diện khu vực, có thêm vòng mờ khu vực hoạt động.
Nút bên phải: về vị trí của tôi · lớp bản đồ · chỉ đường.

Bottom sheet (kéo được):

Tiêu đề: "24 PT quanh bạn ⓘ" · "Sắp xếp: Nổi bật ▾" (Nổi bật / Gần nhất / Đánh giá).
Dải thẻ ngang:
Thẻ PT: ảnh · ❤ · tên · ★ (số đánh giá) · tag chuyên môn · khoảng cách · nhãn "Còn lịch hôm nay" (xanh) hoặc "Kín lịch hôm nay" (đỏ)
Thẻ Gym: ảnh · tên · ★ · khoảng cách · "Đang mở cửa" / "Đóng cửa"
Thẻ Spa: ảnh · dịch vụ · ★ · khoảng cách · ưu đãi
Thẻ "Nổi bật" đứng đầu, có nhãn (cờ monetization).

Bấm marker PT → thẻ chi tiết nổi lên:

Nhãn Nổi bật (nếu có) · ❤ · X
Ảnh · tên · ★ 4.8 (128 đánh giá) · tag · "1,2 km · Hoạt động quanh khu vực này" · "Còn lịch hôm nay"
4 ảnh nhỏ
2 nút: "Xem profile" → UP1 · "Đặt lịch / Nhắn tin" (nút chính)

Màn chi tiết:

UG1 Chi tiết Gym: ảnh · thông tin · tiện ích · giờ mở cửa · gói hội viên · Nhắn tin · Mua gói (thanh toán giả lập, tạo hợp đồng "Gym Membership") · Chỉ đường.
US1 Chi tiết Spa: ảnh · dịch vụ + giá · ưu đãi · giờ mở cửa · Nhắn tin · Chỉ đường.

2.4 PT Profile — UP1 [U05]

Header: ← · tiêu đề · nút Chia sẻ hồ sơ (chia sẻ cả hồ sơ, không phải từng ảnh) · ❤ Lưu · … (Báo cáo / Không thích / Chặn).

Khối đầu:

Ảnh lớn bên trái.
Bên phải: tên · nhãn cấp PT (vd "PT Gold") · "Uy tín 86/100" · "Cách bạn 1,2 km".

Thẻ tóm tắt:

Tag chuyên môn (Giảm mỡ · Tăng cơ · Người mới)
"Từ 350.000đ/buổi"
"Còn lịch hôm nay 18:00"

2 tab: Thông tin · Hình ảnh

Thông tin — các khối có mũi tên ›, bấm mở trang chi tiết:
Phù hợp với ai (gạch đầu dòng)
Gói tập / Dịch vụ: 1 buổi · 5 buổi · 10 buổi, mỗi dòng có giá → bấm 1 gói là vào Đặt lịch, chọn sẵn gói đó
Uy tín & Hoạt động: Đã xác minh danh tính · 48 buổi hoàn thành · 96% đúng lịch
Đánh giá khách hàng: 4.8 ★ / 22 đánh giá → trang review (mỗi review hiện mức + tag)
Kinh nghiệm & Chứng chỉ (bấm chứng chỉ xem ảnh)
Địa điểm tập / Gym liên kết (có bản đồ nhỏ vẽ vòng khu vực)
Giới thiệu ngắn
Kết quả học viên (ảnh trước/sau, cờ studentResults)
Hình ảnh: lưới album → trình xem ảnh.

Thanh dính đáy: "Từ 350.000đ / buổi" · nút chat nhỏ (Nhắn tin) · "Đặt lịch ngay" (nút chính).

Ghi nhận mỗi lần mở/quay lại hồ sơ. Đạt quick_action_revisit (2 lần trong 7 ngày) → bên PT có User này trong "Khách quan tâm".

2.5 Đặt lịch — UB1→UB6 (toàn màn)

UB1 Chọn gói tập [B1]
Đầu trang: avatar PT · ★ · khoảng cách.
2 tab: Gói cá nhân · Gói nhóm.
Danh sách: 1 buổi (giá/buổi) · 5 / 10 / 20 buổi, mỗi gói có nhãn "Tiết kiệm x%".
"Tổng tiền" + nút Tiếp tục.
Nếu User đang có hợp đồng còn buổi với PT này → thêm lựa chọn đầu danh sách: "Dùng gói đang có (còn 5/12 buổi)". Chọn lựa chọn này thì không cần thanh toán.
UB2 Chọn thời gian [B2]
Lịch tháng: chọn ngày bắt đầu. Ngày PT không có lịch trống thì mờ.
Hàng ô giờ trống của ngày đã chọn. Figma chưa vẽ phần này nhưng bắt buộc phải có.
Thời lượng: 60 / 90 / 120 phút.
Lặp lại lịch (tuỳ chọn) — "Tự động đặt các buổi tiếp theo", chọn các thứ trong tuần.
"Số buổi trong gói: 10 buổi ✎" · Tổng tiền · Tiếp tục.
UB3 Chọn địa điểm [B3]
Ô tìm phòng gym.
Phòng gym liên kết — "Miễn phí cho PT", mở sẵn, mỗi gym có ảnh · khoảng cách · quận · nhãn "Liên kết" · nút chọn.
Phòng gym chưa liên kết — "Xem thêm các phòng gym khác", thu gọn mặc định, ghi chú có thể phát sinh phí vào cửa.
Địa điểm khác — Công viên · khu dân cư · địa chỉ của tôi · tuỳ chỉnh (nhập + ghim bản đồ).
UB4 Xác nhận thông tin [B4]
PT · gói · thời gian/buổi · từ ngày / đến ngày · địa điểm (ảnh + tên) · "Lịch cụ thể — Xem chi tiết" (danh sách từng buổi).
Chính sách đổi/huỷ (từ config).
Phương thức thanh toán: mặc định Ví PSGymer (hiện số dư). Bấm › để đổi sang MoMo / ZaloPay / Thẻ ATM-VNPay / Thẻ quốc tế. Ví thiếu tiền → báo + gợi ý nạp hoặc đổi phương thức.
Tổng tiền · nút Thanh toán · dòng "Bằng việc thanh toán, bạn đồng ý với Điều khoản dịch vụ".
UB5 Đang xử lý (vài giây).
UB6 Thanh toán thành công [B5]
Hiệu ứng pháo giấy.
Sửa chữ của Figma (Figma ghi "Lịch tập của bạn đã được xác nhận" — sai với luồng, vì PT chưa xác nhận):

"Thanh toán thành công! Đang chờ PT xác nhận. PT sẽ phản hồi trong vòng 24 giờ — nếu không, bạn được hoàn tiền tự động."

Nút: Xem chi tiết lịch tập · Về trang chủ.
Kết quả: tạo Hợp đồng + các buổi tập ở trạng thái "Chờ PT xác nhận". Profile User hiện khối "Đang tập với PT" có nhãn "Chờ xác nhận".
PT không phản hồi trong pt_response_timeout (24 giờ) → hợp đồng tự huỷ, tiền hoàn về User, cả 2 bên nhận thông báo.

2.6 Buổi tập — USS1 + các popup

| Trạng thái | User thấy |
|------------|-----------|
| Chờ PT xác nhận | Thông tin buổi + "Đang chờ PT xác nhận". Nút: Nhắn PT · Huỷ |
| Scheduled | PT · thời gian · địa điểm. Nút: Đổi giờ · Huỷ · Nhắn PT · Xem địa điểm |
| Trước buổi tập (≤ upcoming_window = 60 phút) | Popup khi mở app: thẻ PT · thời gian · địa điểm · khối Bản đồ riêng · đồng hồ đếm ngược "Còn 45 phút" · khối Nhắc nhở riêng. Nút: Đổi giờ (chỉ khi còn hơn reschedule_before = 60 phút) · Huỷ · Nhắn PT · Xem địa điểm. Bản đồ và nhắc nhở là 2 khối tách biệt. |
| Đến giờ | Popup khi mở app. PT chưa bấm "Tôi đã đến" → "PT đang di chuyển đến điểm tập". PT đã bấm → "Hãy chờ PT xác nhận buổi tập". Không còn nút Đổi giờ. Còn: Nhắn PT · Huỷ (nếu chính sách cho phép). |
| Yêu cầu xác nhận bắt đầu (PT chọn cách gửi yêu cầu) | Popup "PT Minh Anh gửi yêu cầu bắt đầu buổi tập" → nút Xác nhận → Training |
| Training | PT · User · bắt đầu lúc · thời gian đã tập (chạy) · nội dung · ghi chú |
| Kết thúc | PT bấm kết thúc → User xác nhận hoàn thành → UR2 Đánh giá |
| Cancelled / Rescheduled / No-show User / No-show PT / Disputed | Lý do · ai thực hiện · thời điểm. Nút "Báo cáo vấn đề" → Disputed |

UR2 Đánh giá (3 mức + tag):

Không hài lòng: PT không thân thiện · PT đến trễ · Chuyên môn chưa tốt · Không đúng nội dung tập · Giao tiếp chưa tốt
Hài lòng: Đúng giờ · Hướng dẫn rõ · Buổi tập phù hợp · Giao tiếp tốt
Rất hài lòng: Chuyên môn rất tốt · Truyền động lực tốt · Rất tận tâm · Muốn tiếp tục tập · Sẵn sàng giới thiệu

Kèm bình luận không bắt buộc.

Quy đổi ra sao (config rating_star_map): Không hài lòng = 2★ · Hài lòng = 4★ · Rất hài lòng = 5★. Hồ sơ PT hiện trung bình 1 chữ số thập phân.

Uy tín /100 (config trust_score_weights): 40% đánh giá + 30% đúng lịch + 30% tỉ lệ hoàn thành buổi.

URS1 Đổi lịch: chọn giờ mới + lý do → "Chờ PT xác nhận đổi lịch" → PT đồng ý → cập nhật. Lưu lịch cũ · lịch mới · người yêu cầu · thời điểm · lý do.

UCN1 Huỷ: lý do + mức hoàn tiền / phí theo thời gian còn lại → xác nhận → lưu ai huỷ · thời điểm · lý do · hoàn · phạt.

2.6b Kết thúc buổi tập [Claude bổ sung — frame "Buổi tập kết thúc" trong Figma đang trống]

Phía PT — PSE1 Tổng kết buổi tập (mở khi PT bấm "Kết thúc buổi tập"):

Thời lượng thực tế: tự tính, sửa được.
Nội dung đã tập: chọn nhanh nhóm cơ (Ngực · Lưng · Chân · Vai · Tay · Bụng · Cardio · Toàn thân) + ô ghi chú bài tập.
Nhận xét tiến bộ (không bắt buộc): Tốt hơn buổi trước / Như cũ / Cần cố gắng + 1 dòng.
Ghi chú cho buổi sau.
Ảnh (không bắt buộc, kho mẫu).
Nút "Gửi tổng kết & kết thúc" → buổi chuyển sang "Chờ User xác nhận hoàn thành". PT thấy buổi này trong "Cần xử lý → Buổi cần xác nhận hoàn thành".

Phía User:

Popup "Buổi tập đã kết thúc" — hiện tổng kết của PT (thời lượng, nội dung, ghi chú buổi sau).
Nút Xác nhận hoàn thành.
Nút Báo cáo vấn đề: chọn lý do (PT không đến · Buổi ngắn hơn thoả thuận · Nội dung không đúng · Khác) → buổi chuyển Disputed, hiện nhãn "Đang xem xét".
→ UR2 Đánh giá (3 mức + tag). Có nút "Để sau" — sau đó nhắc lại 1 lần bằng thông báo.
→ USE1 Hoàn thành buổi:
"Hoàn thành buổi 8/12" + thanh tiến độ gói
Streak +1 · cập nhật thành tích
Buổi tiếp theo (nếu đã có) hoặc nút "Đặt buổi tiếp theo"
Gợi ý nhỏ "Cập nhật cân nặng" → UPF3
Nếu là buổi cuối gói (12/12) → USE2 Hoàn thành gói: chúc mừng · tổng kết cả gói (số buổi, tổng giờ, thay đổi cân nặng) · nút "Gia hạn / mua gói mới với PT này" · "Đánh giá cả gói".

Hết hạn xác nhận:

User không xác nhận trong completion_confirm_timeout (mặc định 24 giờ) → buổi tự chuyển Completed, không có đánh giá.
User vẫn đánh giá trễ được trong review_window_days (mặc định 7 ngày).

Tiền của buổi (bên PT):

Completed → tiền buổi chuyển từ "App đang giữ" sang "Đang xử lý".
Sau payout_hold_days (mặc định 3 ngày đối soát) → sang "Có thể rút".
Có tranh chấp → giữ lại cho tới khi xử lý xong.

2.6c PT huỷ / đổi lịch / không đến [Claude bổ sung]

PT đề xuất đổi lịch: User nhận thẻ "PT đề xuất đổi sang 19:00 thứ 5" → Đồng ý / Từ chối (Từ chối thì giữ lịch cũ hoặc huỷ được hoàn 100%).
PT huỷ buổi:
User được hoàn 100% (hoặc buổi trả lại vào gói) + thông báo kèm lý do.
PT bị trừ điểm Uy tín theo config.
PT không đến: quá no_show_after mà PT chưa bấm "Tôi đã đến" → User thấy nút "Báo PT không đến" → buổi chuyển No-show PT → hoàn 100% / trả buổi vào gói · PT bị trừ Uy tín.
User không đến (PT báo): buổi chuyển No-show User → mất buổi theo chính sách · User nhận thông báo, có nút "Báo cáo vấn đề" nếu thấy sai.

2.7 Chat (tab 3) [U03]

UC1 — Danh sách hội thoại

Tiêu đề "Chat" · ô tìm "Tìm tên, nội dung tin nhắn…" · icon yêu cầu (có badge).
"Trợ lý AI" ghim đầu, thẻ nổi bật, có số tin chưa đọc.
Hội thoại với PT/Gym: avatar có chấm online · tin cuối · giờ · badge chưa đọc.
Lời chào từ PT: thẻ "PT Minh Anh muốn gửi lời chào" + nội dung lời chào → Chấp nhận / Từ chối. Chấp nhận → mở chat bình thường.
Cuối danh sách: "Đề xuất PT gần bạn" — dải thẻ PT có nút Chat, nhãn "Được tài trợ" (cờ monetization; Figma ghi "(đang Boost)").

UC2 — Chat User ↔ PT

Header: PT + gói đang tập.
Gửi được: chữ · ảnh (kho mẫu) · file (giả lập).
Thẻ có cấu trúc:
Gói tập ("12 buổi · 6.000.000đ · 3 buổi/tuần [Xem gói]")
Lịch tập
Địa điểm
Booking (trạng thái tự cập nhật)
Hợp đồng
Thanh toán
Nhắc buổi tập
Bấm "Xem gói" → mở Đặt lịch, chọn sẵn gói đó.

UAI1 — Trợ lý AI [U03]

Header "Trợ lý AI · Online" · … (lịch sử hội thoại theo ngày / tuần / chủ đề).
Tin chào cá nhân hoá: lấy từ buổi tập thật trong store.
Gợi ý nhanh dạng nút: Gợi ý bữa ăn hôm nay · Xem lịch tập hôm nay · Tư vấn bài tập · Hỏi về phục hồi · Khác.
Câu trả lời là kịch bản mẫu.
Khối "Được tài trợ" đặt dưới và tách riêng câu trả lời (cờ monetization).
Ô nhập + nút gửi ảnh.
Banner dùng thử "Còn 2 ngày dùng thử". Hết dùng thử → UAI2 Gói AI (Tháng / Năm, ghi rõ "giá minh hoạ").

2.8 Camera AI — UCA (tab 4): chụp ảnh và phân tích hình thể

UCA1 Chụp:
Khung camera giả lập (ảnh minh hoạ, không dùng camera thật).
Viền khung dáng người để căn tư thế.
Chọn góc: Mặt trước · Mặt bên · Mặt sau.
Nút chụp · nút "Chọn ảnh có sẵn" (kho mẫu).
UCA2 Kết quả phân tích — ghi rõ "Kết quả minh hoạ — AI phân tích thật sẽ có ở phiên bản sau":
Ảnh vừa chụp
Ước tính vóc dáng / % mỡ
Vùng cần cải thiện
2-3 gợi ý tập luyện
Nút "Lưu vào Tiến trình" → thêm vào Ảnh tiến trình (UPF3)
Nút "Hỏi Trợ lý AI"
UCA3 Lịch sử ảnh: danh sách ảnh theo ngày + so sánh trước/sau 2 ảnh.
PT AI theo kịch bản cũ → ẩn sau cờ cameraAiPreview (mặc định tắt).

2.9 Profile (tab 5) [U04]

| Mã | Màn | Nội dung |
|----|-----|----------|
| UPF1 | Tổng quan | Header nền màu: avatar · tên · tuổi · thành phố · "Chỉnh sửa hồ sơ" · ⚙. Mục tiêu. "ĐANG TẬP VỚI PT". Thành tích. Tiến trình cơ thể. Hành trình của tôi. Đã lưu. |
| UPF2 | Chỉnh sửa hồ sơ | Avatar · tên · tuổi · giới tính · chiều cao · cân nặng · mục tiêu · trình độ · khu vực · sở thích tập · Lưu |
| UJ2 | Chi tiết hợp đồng PT | Header PT + Nhắn tin · gói · thời hạn · tiến độ · 4 tab: Quá trình · Lịch tập · Ghi chú · Đánh giá |
| UPF4 | Thành tích | Tab Tổng quan / Theo tháng / Theo năm · 4 chỉ số · thống kê chi tiết |
| UPF3 | Tiến trình cơ thể | Tab Cân nặng · Số đo · Ảnh tiến trình |
| UJ1 | Hợp đồng của tôi | Tab Đang hoạt động · Đã hoàn thành · Đã huỷ. Có cả hợp đồng PT lẫn Gym Membership. |
| UL1 | Lịch tập của tôi | Lịch tháng + danh sách buổi theo ngày |
| UPY1 | Lịch sử thanh toán | Tab Tất cả · Thanh toán · Hoàn tiền |
| USV1 | Đã lưu | Tab PT · Gym · Spa |
| UST1 | Cài đặt | Thông tin cá nhân · Phương thức thanh toán (Ví PSGymer) · Thông báo · Quyền riêng tư · Người dùng đã chặn · Trợ giúp · Điều khoản · Chính sách bảo mật · Đăng xuất |
| UN1 | Thông báo | Mở từ chuông. Nhóm: Booking · Buổi tập · Chat · Thanh toán. Bấm → mở đúng màn. |

2.10 Ví PSGymer — UW1 [Claude bổ sung]

Ví là phương thức thanh toán mặc định, nên cần có màn quản lý ví. Mở từ: Profile → Hành trình của tôi → Thanh toán, Cài đặt → Phương thức thanh toán, hoặc ngay ở bước thanh toán khi ví thiếu tiền.

Số dư + nút Nạp tiền.
Nạp tiền: chọn mức có sẵn (500k · 1tr · 2tr · 5tr) hoặc tự nhập → chọn nguồn (MoMo · ZaloPay · Thẻ ATM/VNPay · Thẻ quốc tế) → đang xử lý → thành công. Giả lập, không nhập thông tin thẻ thật.
Lịch sử ví: Nạp · Thanh toán · Hoàn tiền.
Hoàn tiền mặc định về Ví PSGymer (nhanh, tức thì). Ghi chú: "Muốn hoàn về nguồn gốc, liên hệ hỗ trợ."
Ở bước thanh toán, ví thiếu tiền → nút "Nạp thêm" mở UW1, nạp xong quay về đúng bước thanh toán.

3. PT CENTER [P01–P03]

3.0 Vào PT Center [Claude bổ sung]

PL1 Đăng nhập: Google / Apple (giả lập), giống User.
PL2 Hồ sơ đang chờ duyệt (trạng thái demo, bật trong bảng điều khiển):
Danh sách việc cần hoàn tất: ảnh đại diện · chứng chỉ · gói tập · khu vực · tài khoản ngân hàng — mục nào xong có dấu ✓.
Dòng "Đội vận hành sẽ duyệt trong 1–2 ngày làm việc".
Khi chưa được duyệt: PT không hiện ở Discovery/Map; vào được tab Tôi để hoàn thiện hồ sơ.
Mặc định demo: PT đã được duyệt → vào thẳng Tổng quan.

PO1 — Tổng quan [P01]

Header nền tối:
Avatar · tên + ✎ · nhãn cấp (vd "GOLD PT") · ★ 4.9 (128 đánh giá)
Công tắc trạng thái "Đang nhận khách ▾" / "Tạm ngưng"
Chuông thông báo
Thao tác nhanh: Sửa profile · Đăng ảnh · Lịch dạy · Tin nhắn.
Hôm nay (Xem toàn bộ): 2-3 buổi.
Cần xử lý (lưới 4 ô có số đếm): Khách đang chờ phản hồi · Yêu cầu đổi lịch · Buổi cần xác nhận hoàn thành · Hợp đồng cần thao tác.
Khách quan tâm (Quick Action): "Minh vừa xem lại hồ sơ của bạn lần thứ 2" [Chào hỏi].
Thu nhập của bạn: Có thể rút (+ nút Rút tiền) · App đang giữ (x hợp đồng) · Đang xử lý (dự kiến ngày).
Quyền lợi & cấp bậc: "GOLD PT · Còn 7 buổi để lên PLATINUM" + thanh tiến độ 82%.
Hoạt động tháng này: buổi dạy · khách đang tập · đánh giá TB · thu nhập — mỗi chỉ số có % so với tháng trước.

PW1 — Công việc [P02]

3 tab: Hôm nay · Sắp tới · Cần xử lý.
Icon lịch tháng · icon tìm.
Hôm nay: thẻ buổi + nhóm "Đã diễn ra hôm nay".
Sắp tới: nhóm theo Tuần này / Tuần sau.
Cần xử lý: Yêu cầu đổi lịch · Khách đang chờ phản hồi · Buổi cần xác nhận hoàn thành · Hợp đồng mới chờ xác nhận.
Bộ lọc (sheet): khoảng thời gian · trạng thái · địa điểm · Áp dụng / Đặt lại.
Lịch dạy dạng tháng/tuần/ngày (mở từ icon lịch).

PSD1 — Chi tiết buổi tập [P02] + PSS (luồng buổi tập phía PT)

Nhãn trạng thái + đếm ngược.
Khách + Buổi x/y
4 nút: Nhắn tin · Gọi điện · Đổi lịch · Xem hợp đồng
Địa điểm + bản đồ nhỏ + Chỉ đường
Nút chính đổi theo trạng thái
Menu … → Thao tác nhanh

Luồng buổi tập phía PT:

Sắp đến giờ: popup nhắc PT di chuyển. Nút "Tôi đã đến".
Đúng giờ: "Bạn đã đến địa điểm tập."
Trễ: "Bạn đến trễ 8 phút." → Gửi thông báo cho User · Nhắn User · Xác nhận vẫn tiếp tục.
Xác nhận bắt đầu buổi tập — 2 cách:
(a) Chụp hình với học viên: camera giả lập → chụp → buổi tập bắt đầu ngay.
(b) Gửi yêu cầu xác nhận: User nhận popup → bấm Xác nhận → bắt đầu.
Training: đồng hồ · nội dung tập · ghi chú.
Nút "Kết thúc buổi tập" → chờ User xác nhận hoàn thành + đánh giá.
Quá no_show_after (15 phút) User chưa tới → hiện nút "Báo User không đến".

PC — Chat [P03]

PC1 Danh sách — 3 tab:

Tin nhắn: hội thoại. Dòng của khách đang chờ có nhãn "Chờ chấp nhận" / "Khách quan tâm".
Chờ chấp nhận: lời chào đã gửi, đang chờ User.
Khách quan tâm: banner + mỗi dòng tên · số lần xem · nút Chào hỏi.

Hợp đồng mới chờ xác nhận: hiện ngay trong Chat thành thẻ hợp đồng có nút Xác nhận / Từ chối. PT xác nhận → mở khung chat với User.

PC3 Gửi lời chào (sheet): ô lời chào soạn sẵn, tối đa 500 ký tự, gợi ý nhanh, nút Gửi lời chào.

PC2 Chi tiết chat: Header khách + gói · nhãn "Đã chấp nhận". Nút + → Thao tác nhanh: Gửi lịch tập · Gửi gói tập · Gửi địa điểm · Nhắc buổi tập · Hẹn lại · Gửi ghi chú.

PI1 — Thu nhập [Claude bổ sung]

3 tab: Tổng quan · Giao dịch · Rút tiền.

Tổng quan: 3 ô số dư (Có thể rút / App đang giữ / Đang xử lý) · ⓘ "Tiền đi thế nào?" · thu nhập theo kỳ · theo hợp đồng · Boost đã chi (cờ monetization).

Giao dịch: lọc Tất cả · Thu · Rút · Hoàn cho khách · Phạt · Boost. Bấm → PI2 Chi tiết giao dịch: dòng thời gian trạng thái.

Rút tiền: PI3 nhập số tiền (Rút tất cả, mức tối thiểu) → tài khoản ngân hàng dạng che → thành công "Dự kiến nhận trong 1–2 ngày làm việc".

PM1 — Tôi [Claude bổ sung]

Header: ảnh bìa · avatar · tên · nhãn cấp · ★ · Uy tín.
Công tắc Đang nhận khách / Tạm ngưng.
Nút "Xem hồ sơ như khách hàng" → UP1.
Thanh "Hoàn thiện hồ sơ".
Nhóm Hồ sơ & dịch vụ: PM2 Thông tin · PM3 Chứng chỉ · PM4 Gói tập & giá (luôn có gói 1 buổi) · PM5 Lịch làm việc · PM6 Khu vực & vị trí (kéo ghim) · PM7 Ảnh hồ sơ (hạn dùng).
Nhóm Phát triển: PM8 Cấp PT · PM9 Thống kê hồ sơ · PM10 Boost / Nổi bật (cờ monetization).
Nhóm Tài khoản: email/SĐT che · ngân hàng · thông báo · chính sách PT · trợ giúp · đăng xuất.

Cấp PT (tên sửa được trong config): Bronze · Silver · Gold · Platinum.

PN1 — Thông báo PT [Claude bổ sung]

Mở từ chuông ở Tổng quan. Nhóm: Booking · Buổi tập · Đổi lịch / Huỷ · Khách quan tâm · Đánh giá mới · Thanh toán · Hệ thống.
Bấm thông báo → mở đúng màn.

4. Luồng xuyên 2 app (phải chạy thật trên 2 điện thoại)

Khách quan tâm → lời chào:
User mở hồ sơ PT lần 2 → PT thấy User trong "Khách quan tâm" (Chat + Tổng quan).
PT gửi lời chào → User nhận thẻ lời chào trong Chat.
User chấp nhận → 2 bên chat được.

Đặt lịch → PT xác nhận:
User đặt + thanh toán → PT thấy "Khách đang chờ phản hồi" (Tổng quan) + thẻ hợp đồng trong Chat.
PT xác nhận → khung chat mở; User nhận thông báo "PT đã xác nhận", nhãn đổi thành "Đang diễn ra".
Quá 24 giờ PT không phản hồi → tự huỷ + hoàn tiền.

Buổi tập (dùng tua thời gian):
Còn 60 phút → popup "Trước buổi tập" bên User.
Đến giờ → popup "PT đang di chuyển".
PT bấm "Tôi đã đến" → User thấy "Hãy chờ PT xác nhận buổi tập".
PT chụp hình hoặc gửi yêu cầu → (User xác nhận) → Training.
PT kết thúc + gửi tổng kết (PSE1) → User thấy popup tổng kết → xác nhận + đánh giá → màn hoàn thành buổi (streak +1).
Bên PT: nhận review · tiền buổi chuyển từ "App đang giữ" sang "Đang xử lý" (tua +3 ngày → "Có thể rút") · ★ và Uy tín cập nhật.

Đổi lịch: User xin đổi → PT thấy trong "Cần xử lý" → đồng ý → cả 2 bên cập nhật.

Gửi gói qua chat: PT gửi thẻ Gói tập → User bấm Xem gói → đặt lịch với gói đó.

5. Giả định (đều chỉnh được trong config — cần Ruka xác nhận)

| # | Giả định |
|---|----------|
| 1 | Thêm trạng thái "Chờ PT xác nhận" + tự huỷ sau 24 giờ (theo ghi chú Figma). |
| 2 | upcoming_window = 60 phút (theo ghi chú Figma "trước buổi tập 1 tiếng"). |
| 3 | Thanh toán chỉ online: Ví PSGymer (mặc định) + MoMo, ZaloPay, VNPay, thẻ quốc tế. Không có tiền mặt. |
| 4 | Chính sách huỷ mẫu: trước 24 giờ hoàn 100% · trong 24 giờ phí 50% · trong 2 giờ hoặc không đến thì mất buổi. |
| 5 | Khách quan tâm: xem hồ sơ ≥ 2 lần trong 7 ngày. |
| 6 | no_show_after = 15 phút. |
| 7 | Quy đổi sao 2/4/5 · trọng số Uy tín 40/30/30. |
| 8 | Tên cấp PT: Bronze / Silver / Gold / Platinum. |
| 9 | Giá gói AI, Boost, gói nhóm là số minh hoạ. |
| 10 | Tin nhắn với Gym do đội vận hành trả lời (giả lập tự động). |
| 11 | [v2.2] completion_confirm_timeout = 24 giờ · review_window_days = 7 ngày. |
| 12 | [v2.2] payout_hold_days = 3 ngày đối soát trước khi PT rút được tiền. |
| 13 | [v2.2] Hoàn tiền mặc định về Ví PSGymer. |
| 14 | [v2.2] PT huỷ hoặc không đến → User hoàn 100% / trả buổi vào gói · PT trừ Uy tín (pt_cancel_trust_penalty). |
| 15 | [v2.2] PT mới phải được duyệt mới hiện ở Discovery/Map. |

6. Bảng điều khiển demo

Tua thời gian: +15 phút · +1 giờ · còn 60 phút trước giờ hẹn · đến giờ hẹn · +15 phút sau giờ hẹn · +24 giờ · về giờ thật.
Mô phỏng: User xem lại hồ sơ PT X · Hết dùng thử AI · Làm mới phiên Discovery · Hiện lý do xếp hạng · Xoá "đã xem" · Chạy lại onboarding.
Thao tác thay phía bên kia (khi chỉ xem 1 điện thoại): PT xác nhận / từ chối hợp đồng · Tôi đã đến · Chụp hình bắt đầu · Gửi yêu cầu bắt đầu · Kết thúc · Báo User không đến · Đồng ý đổi lịch · Gửi lời chào · Gửi thẻ gói. Phía User: Chấp nhận lời chào · Xác nhận bắt đầu.
Config nghiệp vụ: sửa trực tiếp mọi giá trị ở mục 5 + media_expire_days · reschedule_before · pt_response_timeout · số ngày dùng thử AI · % phí theo cấp.
Cờ tính năng: monetization · cameraAiPreview · spa · groupPackages · studentResults · aiAssistant.
[v2.2] Thêm: +3 ngày (đối soát) · Ví hết tiền · PT ở trạng thái chờ duyệt · Buổi cuối gói (để xem màn Hoàn thành gói) · PT huỷ buổi · PT không đến.

7. Bỏ khỏi prototype

Đăng nhập OTP
Nhật ký · Cộng đồng · tạo bài · like · bình luận
Tab Lịch sử
Chip lọc Coach/Phòng gym cũ
Đánh giá 5 sao do User tự chấm
Timeline booking cũ
Ví/chat/booking kiểu cũ
PT AI theo kịch bản (ẩn sau cờ)

Giữ dùng tiếp:

Dữ liệu PT, ảnh, gói, lịch trống, kết quả học viên, chứng chỉ
Gym: hệ thống = liên kết · thu thập = chưa liên kết
Bản đồ Stadia, tokens, bảng điều khiển, kho dữ liệu chung

8. Phần Figma chưa xem được

Do giới hạn lượt đọc Figma gói Starter, chưa xem được PT Thu nhập, PT Tôi, ảnh màn "Buổi tập diễn ra". Frame "Buổi tập kết thúc" đang trống.

v2.2: Ruka xác nhận Figma chỉ là tham khảo → Claude tự thiết kế các phần này theo bối cảnh (xem các mục [Claude bổ sung]). Không cần chờ Figma.

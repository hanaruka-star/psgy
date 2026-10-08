# 02 — Luồng

Mã màn: `01_MAN_HINH.md`.  
Session mock **không persist**, **không sync** User ↔ Coach.

## Lưu ý chung

- Dev (`ENV=development`): mọi màn User/Coach bọc U03 — AppBar nút `Chuyển sang Coach` / `Chuyển sang User`.
- Prod: Splash → (nếu chưa consent) U02 → flavor User U04 hoặc flavor Coach C01. Không ModeSwitcher.

---

## U-L1 Đăng nhập OTP giả lập → hồ sơ → Bản đồ

U01 Splash → (prod) U02 → U04 `Xác thực số điện thoại` → `Gửi mã OTP` → `Nhập mã xác thực` (mọi 6 số; SnackBar `Mã demo: 123456`) → U05 `Tạo hồ sơ` (tên bắt buộc) `Tiếp tục` → U06 tab Bản đồ = U07.

```mermaid
flowchart LR
  U01[U01 Splash] --> U02[U02 Consent prod]
  U02 --> U04[U04 OTP]
  U01 --> U04
  U04 --> U05[U05 Tạo hồ sơ]
  U05 --> U06[U06 Shell]
  U06 --> U07[U07 Bản đồ]
```

## U-L2 Bản đồ: lọc Coach / Phòng gym → Chỉ đường

U07 chip `Coach` | `Phòng gym`. Coach: tap marker/card → U09. Gym: tap marker → sheet U07a; `Chỉ đường` → Google Maps ngoài (fail: `Không mở được Google Maps.`).

```mermaid
flowchart TD
  U07[U07 Bản đồ]
  U07 -->|chip Coach| CoachLayer[Marker + list Coach]
  U07 -->|chip Phòng gym| GymLayer[Marker + list Gym]
  CoachLayer --> U09[U09 Chi tiết Coach]
  GymLayer --> Sheet[U07a Sheet gym]
  Sheet --> Maps[Google Maps ngoài]
```

## U-L3 Xem Coach → dịch vụ/gói → xác nhận đặt lịch → theo dõi → xác nhận + đánh giá → nhật ký

U09 chọn radio dịch vụ → `Chọn HLV` → U10. (Tuỳ chọn: tab `Gói` → `Mua` → dialog `Xác nhận mua`.)  
U10 `Đặt lịch ngay` → U11 auto-advance 3s: pending → confirmed → inProgress → awaitingUserConfirmation.  
Sao + `Xác nhận đã nhận dịch vụ` → completed. `📸 Chia sẻ buổi tập hôm nay` → U17 (ảnh bắt buộc) `Đăng` → U14.

```mermaid
flowchart TD
  U09[U09 Coach] -->|Chọn HLV| U10[U10 Xác nhận đặt lịch]
  U09 -->|Mua gói| Buy[Dialog Xác nhận mua]
  U10 -->|Đặt lịch ngay| U11[U11 Theo dõi]
  U11 -->|3s DEMO| U11
  U11 -->|Xác nhận đã nhận dịch vụ| Done[completed]
  Done -->|Chia sẻ| U17[U17 Chia sẻ buổi tập]
  U17 --> U14[U14 Nhật ký của tôi]
  Done -->|Về trang chủ| U06[U06 Shell]
```

## U-L4 Mua gói của Coach

U09 tab `Gói` → `Mua` → `Xác nhận mua` / `Hủy`. Sau mua: khối `Gói đã mua` `{remainingLabel}`. Dùng lúc U10 nếu `remainingSessions > 0` đúng `coachId`.

```mermaid
flowchart LR
  U09[U09 tab Gói] --> D[Dialog Xác nhận mua]
  D -->|Xác nhận mua| Own[Gói đã mua trên U09]
  Own --> U10[U10 Dùng gói trừ 1 buổi]
```

## U-L5 Chat trước booking và trong booking

Trước: U10 `Trao đổi với Coach` → U12 inquiry (subtitle `Trao đổi trước khi đặt lịch`).  
Trong: U11 từ mốc confirmed (và inquiry) `Chat với Coach` → U12 theo `bookingId`.  
**Không** hiện tin nhắn bên C04.

```mermaid
flowchart LR
  U10[U10] -->|Trao đổi với Coach| U12a[U12 inquiry]
  U11[U11] -->|Chat với Coach| U12b[U12 booking]
```

## U-L6 Lịch sử booking

U06 tab `Lịch sử` = U13. Tap: trackable → U11 live; completed/cancelled → U11 `readOnly: true` title `Chi tiết Booking`.

```mermaid
flowchart LR
  U13[U13 Lịch sử] -->|đang chạy| U11[U11 Theo dõi]
  U13 -->|xong/huỷ| U11r[U11 readOnly]
```

## U-L7 Nhật ký / Cộng đồng / chi tiết / like / bình luận / báo cáo

U14 / U15 grid → U16. `Thả tim` / `Đã thích`; composer `Viết bình luận...`; AppBar `Báo cáo` → SnackBar `Đã ghi nhận báo cáo` (không ẩn bài).

```mermaid
flowchart LR
  U14[U14 Nhật ký] --> U16[U16 Bài viết]
  U15[U15 Cộng đồng] --> U16
  U16 --> Like[Like / Bình luận / Báo cáo]
```

## U-L8 Kết quả học viên

U09 `Kết quả học viên` → `Xem chi tiết` → U18 (Trước/Sau + `Tóm tắt` + `Nhật ký tiến độ`).

```mermaid
flowchart LR
  U09[U09] -->|Xem chi tiết| U18[U18 studentLabel]
```

## U-L9 PT AI

U06 FAB `PT AI` → U19 `Bắt đầu` → U20 chọn bài `Bắt đầu tập` → U21 timer/cue → nghỉ 5s → bài sau → U22 `Xong` → U06. U21 `Dừng` → dialog `Dừng buổi tập?`.

```mermaid
flowchart LR
  U06 -->|PT AI| U19[U19 Giới thiệu]
  U19 -->|Bắt đầu| U20[U20 Chọn bài tập]
  U20 --> U21[U21 Tập]
  U21 --> U22[U22 Hoàn thành]
  U22 --> U06
```

---

## C-L1 Home: rảnh + vị trí

C01 Switch `Đang rảnh`; `Cập nhật vị trí` cycle Quận 2 → 1 → 7 → Thủ Đức.

```mermaid
flowchart LR
  C01[C01 Home] -->|Switch| Avail[isAvailableNow]
  C01 -->|Cập nhật vị trí| Loc[cycle 4 quận]
```

## C-L2 Nhận booking → xác nhận / từ chối

C01 card `Booking mới cần xác nhận` → C03. `Xác nhận` → confirmed. `Từ chối` → cancelled lý do `Coach từ chối`.

```mermaid
flowchart LR
  C01 --> C03[C03 Yêu cầu đặt lịch]
  C03 -->|Xác nhận| C01
  C03 -->|Từ chối| C01
```

## C-L3 Booking đang chạy → bắt đầu → hoàn thành / không đến

C01 `Booking đang diễn ra` → C02. confirmed: `Bắt đầu buổi tập` / `Báo cáo khách không đến`. inProgress: `Hoàn thành dịch vụ` → awaitingUserConfirmation (chờ User U11). Coach **không** tự `completed`.

```mermaid
flowchart TD
  C01 --> C02[C02 Active]
  C02 -->|Bắt đầu buổi tập| IP[inProgress]
  IP -->|Hoàn thành dịch vụ| Wait[awaitingUserConfirmation]
  C02 -->|Báo cáo khách không đến| NoShow[cancelled]
```

## C-L4 Chat Coach

C02 `Vào Chat` → C04. Gửi `Nhắn tin cho khách...`. Không sync U12.

```mermaid
flowchart LR
  C02 -->|Vào Chat| C04[C04 Chat]
```

## C-L5 Dịch vụ / Gói

C01 icon tạ → C05. Tab Dịch vụ / Gói; menu `Sửa`/`Xóa`; FAB `+`. Không xoá dịch vụ cuối.

```mermaid
flowchart LR
  C01 --> C05[C05 Dịch vụ của bạn]
  C05 --> CRUD[Dialog thêm/sửa/xoá]
```

## C-L6 Chỉnh sửa hồ sơ

C01 `Chỉnh sửa hồ sơ` → C06 `Lưu` → pop + `Đã lưu hồ sơ trong phiên demo.` Không sync catalog User U09.

```mermaid
flowchart LR
  C01 --> C06[C06 Chỉnh sửa hồ sơ]
  C06 -->|Lưu| C01
```

## C-L7 Nhật ký học viên

C01 `Nhật ký học viên` → C07 grid → U16 `readOnly: true` (không like/comment/báo cáo). Seed độc lập (`cjp_01`, `cjp_02`).

```mermaid
flowchart LR
  C01 --> C07[C07 Nhật ký học viên]
  C07 --> U16r[U16 readOnly]
```

---

## X-L1 Chuyển User ↔ Coach (dev)

U03 AppBar: User → `Chuyển sang Coach` (icon `Icons.person`) · Coach → `Chuyển sang User` (`Icons.engineering`). Body đổi `_UserPilotGate` ↔ `CoachHomeScreen`. Session mock **không** copy qua.

```mermaid
flowchart LR
  UserGate[User U04/U05/U06] -->|Chuyển sang Coach| C01
  C01 -->|Chuyển sang User| UserGate
```

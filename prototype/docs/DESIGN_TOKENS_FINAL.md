# Design tokens — Teal tươi (3C)

Sinh từ bảng **Giao diện** của prototype. User App và PT Center dùng chung một bộ.

Ngày xuất: 2026-10-09

## Điều chỉnh tương phản (Cursor)

Cặp dưới 4.5:1 đã chỉnh hoặc cấm dùng:

| Cặp | Spec | Thực tế | Việc làm |
|---|---|---|---|
| Chữ phụ / nền sáng | `#64748B` / `#F5F8F7` = 4.45:1 | `#5B677A` / `#F5F8F7` = **5.36:1** | Đẩy chữ phụ xuống đậm hơn |
| Tab đang chọn / nền tab sáng | `#0E9F87` / `#FFFFFF` = 3.32:1 | `#0B7A68` / `#FFFFFF` = **4.92:1** | Tab chữ dùng `--brand-text` |
| Chữ trắng / brand tươi `#0E9F87` | — | **3.32:1** | Không dùng. Nút chính dùng `--brand-strong` (A) hoặc teal tươi + chữ navy (B) |

## Màu trạng thái

| Trạng thái | Token |
|---|---|
| Chờ xác nhận | `--warning` |
| Sắp / đang diễn ra | `--brand` / `--brand-text` |
| Hoàn thành | `--success` |
| Đã huỷ | `--text-2` |
| No-show / tranh chấp | `--danger` |

## Cấp PT

| Cấp | Màu |
|---|---|
| Bronze | #B87333 |
| Silver | #94A3B8 |
| Gold | #D4A017 |
| Platinum | #5B8DB8 |

## A. Teal tươi

| Token | Giá trị |
|---|---|
| Font | Inter (OFL-1.1) |
| Cỡ chữ toàn app | 100% |
| Tiêu đề lớn | 24px / weight 700 |
| Tiêu đề | 20px / weight 700 |
| Tiêu đề nhỏ | 16px / weight 600 |
| Nội dung | 14px / weight 400 |
| Chú thích | 12px / weight 400 |
| Brand (teal tươi) | #0E9F87 |
| Nút chính (teal đậm) | #0B4F43 |
| Chữ thương hiệu / link | #0B7A68 |
| Nền tag / chip | #E6F6F2 |
| Nền app | #F5F8F7 |
| Nền thẻ | #FFFFFF |
| Chữ chính | #0F172A |
| Chữ phụ | #5B677A |
| Viền | #E2E8F0 |
| Cảnh báo / chờ | #F59E0B |
| Huỷ / tranh chấp | #E5484D |
| Hoàn thành | #16A34A |
| Chữ trên nút chính | #FFFFFF |
| Tab đang chọn | #0B7A68 |
| Tab không chọn | #5B677A |
| Nền bottom tab | #FFFFFF |
| Radius scale | 1 (12 / 16 / 20) |
| Bóng | 1 × 0 2px 8px rgba(15,23,42,.06) |
| Bottom tab | iconText / solid / 64px / icon 24px |

### Tương phản

| Cặp | Tỉ lệ | 4.5:1 |
|---|---|---|
| Chữ chính / nền (#0F172A / #F5F8F7) | 16.71:1 | ✓ |
| Chữ phụ / nền (#5B677A / #F5F8F7) | 5.36:1 | ✓ |
| Chữ chính / thẻ (#0F172A / #FFFFFF) | 17.85:1 | ✓ |
| Chữ / nút chính (#FFFFFF / #0B4F43) | 9.49:1 | ✓ |
| Link / nền (#0B7A68 / #F5F8F7) | 4.92:1 | ✓ |
| Link / thẻ (#0B7A68 / #FFFFFF) | 5.25:1 | ✓ |
| Tab đang chọn / nền tab (#0B7A68 / #FFFFFF) | 4.92:1 | ✓ |
| Chữ trắng / brand tươi (không dùng) (#FFFFFF / #0E9F87) | 3.32:1 | ✗ |

## B. Teal mềm

| Token | Giá trị |
|---|---|
| Font | Inter (OFL-1.1) |
| Cỡ chữ toàn app | 100% |
| Tiêu đề lớn | 24px / weight 700 |
| Tiêu đề | 20px / weight 700 |
| Tiêu đề nhỏ | 16px / weight 600 |
| Nội dung | 14px / weight 400 |
| Chú thích | 12px / weight 400 |
| Brand (teal tươi) | #0E9F87 |
| Nút chính (teal tươi) | #0E9F87 |
| Chữ thương hiệu / link | #0B7A68 |
| Nền tag / chip | #DDF4EE |
| Nền app | #F0FAF7 |
| Nền thẻ | #FFFFFF |
| Chữ chính | #0F172A |
| Chữ phụ | #5B677A |
| Viền | #E2E8F0 |
| Cảnh báo / chờ | #F59E0B |
| Huỷ / tranh chấp | #E5484D |
| Hoàn thành | #16A34A |
| Chữ trên nút chính | #0F172A |
| Tab đang chọn | #0B7A68 |
| Tab không chọn | #5B677A |
| Nền bottom tab | #FFFFFF |
| Radius scale | 1.4 (~17 / 22 / 28; mục tiêu cảm giác 16/20/28) |
| Bóng | 0.7 × 0 2px 8px rgba(15,23,42,.06) |
| Bottom tab | iconText / solid / 64px / icon 24px |

### Tương phản

| Cặp | Tỉ lệ | 4.5:1 |
|---|---|---|
| Chữ chính / nền (#0F172A / #F0FAF7) | 16.77:1 | ✓ |
| Chữ phụ / nền (#5B677A / #F0FAF7) | 5.38:1 | ✓ |
| Chữ chính / thẻ (#0F172A / #FFFFFF) | 17.85:1 | ✓ |
| Chữ / nút chính (#0F172A / #0E9F87) | 5.38:1 | ✓ |
| Link / nền (#0B7A68 / #F0FAF7) | 4.93:1 | ✓ |
| Link / thẻ (#0B7A68 / #FFFFFF) | 5.25:1 | ✓ |
| Tab đang chọn / nền tab (#0B7A68 / #FFFFFF) | 4.92:1 | ✓ |
| Chữ trắng / brand tươi (không dùng) (#FFFFFF / #0E9F87) | 3.32:1 | ✗ |

## C. Teal tối

| Token | Giá trị |
|---|---|
| Font | Inter (OFL-1.1) |
| Cỡ chữ toàn app | 100% |
| Tiêu đề lớn | 24px / weight 700 |
| Tiêu đề | 20px / weight 700 |
| Tiêu đề nhỏ | 16px / weight 600 |
| Nội dung | 14px / weight 400 |
| Chú thích | 12px / weight 400 |
| Brand (teal tươi) | #2EC4A6 |
| Nút chính | #2EC4A6 |
| Chữ thương hiệu / link | #7DDEC8 |
| Nền tag / chip | #1A2E29 |
| Nền app | #0B1412 |
| Nền thẻ | #13201D |
| Chữ chính | #E6F2EF |
| Chữ phụ | #94A3B8 |
| Viền | #243833 |
| Cảnh báo / chờ | #FBBF24 |
| Huỷ / tranh chấp | #F87171 |
| Hoàn thành | #4ADE80 |
| Chữ trên nút chính | #04211B |
| Tab đang chọn | #2EC4A6 |
| Tab không chọn | #94A3B8 |
| Nền bottom tab | #13201D |
| Radius scale | 1 (12 / 16 / 20) |
| Bóng | 0.4 × 0 2px 8px rgba(15,23,42,.06) |
| Bottom tab | iconText / solid / 64px / icon 24px |

### Tương phản

| Cặp | Tỉ lệ | 4.5:1 |
|---|---|---|
| Chữ chính / nền (#E6F2EF / #0B1412) | 16.31:1 | ✓ |
| Chữ phụ / nền (#94A3B8 / #0B1412) | 7.29:1 | ✓ |
| Chữ chính / thẻ (#E6F2EF / #13201D) | 14.63:1 | ✓ |
| Chữ / nút chính (#04211B / #2EC4A6) | 7.72:1 | ✓ |
| Link / nền (#7DDEC8 / #0B1412) | 11.71:1 | ✓ |
| Link / thẻ (#7DDEC8 / #13201D) | 10.51:1 | ✓ |
| Tab đang chọn / nền tab (#2EC4A6 / #13201D) | 7.64:1 | ✓ |
| Chữ trắng / brand tươi (không dùng) (#FFFFFF / #2EC4A6) | 2.20:1 | ✗ |

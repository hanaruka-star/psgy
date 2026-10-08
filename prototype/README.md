# PSGymer — prototype web (Bước 2)

Khung Vite + React để duyệt cảm giác giao diện. Không backend. Nguồn chuẩn: `docs/audit/`.

## Cách chạy

```bash
cd prototype
npm install
npm run dev -- --host
```

Mở http://localhost:5173

## Cách xem

**(a) Máy tính** — cửa sổ ≥ 900px: hai điện thoại cạnh nhau (User trái, Coach phải) + bảng điều khiển.

**(b) iOS Simulator** — mở Safari trong Simulator → `http://localhost:5173` → nút Chia sẻ → **Thêm vào Màn hình chính**. Mở icon PSGymer (toàn màn hình, không thanh Safari).

**(c) iPhone thật cùng Wi-Fi** — `http://<IP máy Mac>:5173` (IP xem bằng `ipconfig getifaddr en0`). Cũng có thể Thêm vào Màn hình chính.

## Thêm 1 màn

1. Tạo file `src/screens/user/U12_Chat.tsx` (hoặc `coach/C0x_...`), mã khớp audit.
2. Trong `src/screens/registry.tsx`, gắn `component` vào đúng `id` (U01…U22 / C01…C07).
3. Màn chưa dựng dùng chung Placeholder — mọi id đã có trong registry.

## Bật/tắt 1 tính năng

Sửa cờ lúc chạy trong bảng điều khiển, hoặc mặc định trong `src/config/features.ts` (`ptAi`, `journal`, `packages`, `chat`, `gymFilter`, `studentResults`, `promoRibbon`). Tắt `ptAi` → bottom bar còn 4 tab.

## Sửa dữ liệu mẫu

JSON trong `src/data/` (copy từ audit, đã chỉnh theo quyết định Ruka). Store Zustand + `localStorage` key `psgy-proto-v1`. Nút **Reset dữ liệu** trong bảng điều khiển khôi phục seed.

Ảnh / logo: `public/assets/` — nguồn ghi trong `public/assets/SOURCE.md`.

Bản đồ: CARTO Positron/Dark Matter raster hiện gắn watermark “API KEY REQUIRED” nếu không có key (2026). Prototype dùng OSM raster + filter gần Positron, ghi nguồn © OpenStreetMap. Khi có key CARTO, đổi `--map-tiles` trong `src/theme/tokens.css`.

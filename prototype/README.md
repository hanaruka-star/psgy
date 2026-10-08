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

**(b) iOS Simulator** — `open -a Simulator` rồi Safari → `http://localhost:5173`.

Thêm vào Màn hình chính (Ruka bấm tay):

1. Safari đang mở prototype.
2. Nút **Chia sẻ** (ô vuông + mũi tên lên) ở thanh dưới.
3. **Thêm vào Màn hình chính** → **Thêm**.
4. Về Home, mở icon **PSGymer** (toàn màn hình, không thanh Safari).

**(c) iPhone thật cùng Wi-Fi** — `http://<IP máy Mac>:5173` (`ipconfig getifaddr en0`). Có thể Thêm vào Màn hình chính. Tile bản đồ trên IP LAN cần `VITE_MAP_TILE_KEY` (xem dưới).

## Thêm 1 màn

1. Tạo file `src/screens/user/U12_Chat.tsx` (hoặc `coach/C0x_...`), mã khớp audit.
2. Trong `src/screens/registry.tsx`, gắn `component` vào đúng `id` (U01…U22 / C01…C07).
3. Màn chưa dựng dùng chung Placeholder — mọi id đã có trong registry.

## Bật/tắt 1 tính năng

Sửa cờ lúc chạy trong bảng điều khiển, hoặc mặc định trong `src/config/features.ts` (`ptAi`, `journal`, `packages`, `chat`, `gymFilter`, `studentResults`, `promoRibbon`). Tắt `ptAi` → bottom bar còn 4 tab.

## Sửa dữ liệu mẫu

JSON trong `src/data/` (copy từ audit, đã chỉnh theo quyết định Ruka). Store Zustand + `localStorage` key `psgy-proto-v1`. Nút **Reset dữ liệu** trong bảng điều khiển khôi phục seed.

Ảnh / logo: `public/assets/` — nguồn ghi trong `public/assets/SOURCE.md`.

## Bản đồ

Cấu hình: `src/config/map.ts` (URL sáng/tối + dòng ghi nguồn).

Nhà cung cấp: **Stadia Maps — Alidade Smooth** (sáng) / **Alidade Smooth Dark** (tối). Tối giản: đường + tên đường/phường/quận, không POI.

- Localhost: không cần key (Stadia cho phép Referer `localhost` / `127.0.0.1`).
- Deploy / iPhone Wi-Fi: copy `.env.example` → `.env.local`, điền `VITE_MAP_TILE_KEY` (https://client.stadiamaps.com/). Không commit `.env.local`.

Ghi nguồn bắt buộc: © Stadia Maps, © OpenMapTiles, © OpenStreetMap.

## Thư viện + giấy phép

**Runtime**
- `react`, `react-dom` — MIT
- `zustand` — MIT
- `motion` — MIT
- `leaflet` — BSD-2-Clause
- `@fontsource/inter` — OFL-1.1
- `@fontsource/material-symbols-outlined` — Apache-2.0

**Dev**
- `vite` — MIT
- `typescript` — Apache-2.0
- `tailwindcss`, `@tailwindcss/vite` — MIT
- `@vitejs/plugin-react` — MIT
- `@types/react`, `@types/react-dom`, `@types/leaflet` — MIT

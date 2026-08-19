# Firestore Schema — ParkingLink

> Single source of truth cho schema Firestore. Cập nhật khi đổi cấu trúc data.

## Geohash Specification (chốt 15/06/2026)

### Precision

- **WRITE precision = 7** (CỐ ĐỊNH) — ô ~150m, hợp mật độ bãi HCMC
- Áp dụng MỌI nơi write: `parking_lots.geohash`, `surveying_lots.geohash`, Isar cache
- **QUERY precision = dynamic ≤ 7** theo radius (`GeohashUtils.precisionForRadiusKm`):
  - ≤ 2.4 km → precision 6
  - ≤ 10 km → precision 5
  - ≤ 40 km → precision 4
  - > 40 km → precision 3
- Query precision THẤP HƠN write vẫn match (geohash 7 ký tự chứa tiền tố ngắn)

### Field

- Tên field: `geohash` (lowercase), kiểu `String`
- Là **INDEX field** (không nằm trên domain entity; chỉ Firestore + Isar local cache)
- Encode: `GeohashUtils.encode()` (Dart client) hoặc `ngeohash.encode(lat, lng, 7)` (seed scripts)

### Query pattern

- **Hybrid:** geohash range (server `.orderBy('geohash').startAt/endAt`) + Haversine filter (client `GeoDistance.kmBetweenCoordinates`)
- **Fallback chain:** geohash range → client-side (full collection limit) → all-limited
- Implementations: `UserParkingDataSource`, `UserSurveyingDataSource`, `ParkingLocalDataSource` (Isar)

### Collections dùng geohash

| Collection | Index | Ghi chú |
|---|---|---|
| `parking_lots` | single-field `orderBy(geohash)` | ⚠️ writer chưa đầy đủ trong app/seed (fix Phase 2) |
| `surveying_lots` | composite (`status` + `geohash`) | backfill script dùng precision 7 |

### TODO Phase 2 (fix code)

- [ ] `parking_lots`: thêm geohash writer (`seed_cc_dragon.js` + backfill mở rộng)
- [ ] `GeohashUtils.encode`: đổi default precision 5 → 7
- [ ] Isar mapper: encode precision 7
- [ ] Verify production lot-creation flow ghi geohash precision 7
- [ ] Verify mọi query precision ≤ 7
- [ ] Survey pipeline (Telegram → Sheets → Firestore): sinh `geohash` precision 7 khi ingest

---

## Collections (tham khảo — bổ sung dần)

Field dưới đây lấy từ Firestore models trong `lib/features/parking/data/models/`.  
Cột **Model** = field được `fromFirestore` / `toFirestore` map; **Firestore-only** = có trên Firestore nhưng chưa map vào Dart model.

### `parking_lots`

| Field | Type | Model | Ghi chú |
|---|---|---|---|
| `id` | `string` | ✅ | Document ID fallback nếu thiếu field |
| `name` | `string` | ✅ | |
| `address` | `string` | ✅ | |
| `lat` | `number` | ✅ | |
| `lng` | `number` | ✅ | |
| `status` | `string` | ✅ | Default `'closed'`; values: `open`, `closed`, … |
| `ownerId` | `string` | ✅ | Firebase Auth UID của owner |
| `createdAt` | `timestamp` | ✅ | |
| `updatedAt` | `timestamp` | ✅ | |
| `geohash` | `string` | Firestore-only | Index field; queried by nearby search, chưa ghi trong `ParkingLotModel.toFirestore()` |

**Subcollection:** `parking_lots/{lotId}/vehicle_types/{typeId}` (xem `VehicleTypeModel` — chưa liệt kê chi tiết ở đây).

### `surveying_lots`

| Field | Type | Model | Ghi chú |
|---|---|---|---|
| `name` | `string` | ✅ | |
| `address` | `string` | ✅ | |
| `lat` | `number` | ✅ | |
| `lng` | `number` | ✅ | |
| `status` | `string` | ✅ | Default `'surveying'`; queried với `where('status', 'surveying')` |
| `surveyedAt` | `timestamp` | ✅ | |
| `estimatedOpeningAt` | `timestamp` | ✅ | |
| `estimatedSlots` | `number` | ✅ | Optional |
| `estimatedCarSlots` | `number` | ✅ | Fallback từ `vehicleSlotEstimates` / `estimatedSlotsByVehicle` |
| `estimatedMotoSlots` | `number` | ✅ | Fallback từ `vehicleSlotEstimates` / `estimatedSlotsByVehicle` |
| `carPrice` | `number` | ✅ | VND |
| `motoPrice` | `number` | ✅ | VND |
| `totalSlots` | `number` | ✅ | |
| `vehicleTypes` | `string` | ✅ | |
| `category` | `string` | ✅ | |
| `photoUrl` | `string` | ✅ | Fallback đọc `imageUrl` |
| `notes` | `string` | ✅ | |
| `source` | `string` | ✅ | e.g. `telegram` |
| `surveyor` | `string` | ✅ | |
| `geohash` | `string` | Firestore-only | Index field; queried, chưa map trong `SurveyingLotModel` |
| `imageUrl` | `string` | Firestore-only | Alias cũ của `photoUrl` |
| `vehicleSlotEstimates` | `map<string, number>` | Firestore-only | Slot estimate theo vehicle type |
| `estimatedSlotsByVehicle` | `map<string, number>` | Firestore-only | Alias của `vehicleSlotEstimates` |

### `parking_sessions`

| Field | Type | Model | Ghi chú |
|---|---|---|---|
| `id` | `string` | ✅ | Document ID fallback nếu thiếu field |
| `lotId` | `string` | ✅ | Reference `parking_lots/{lotId}` |
| `vehicleType` | `string` | ✅ | e.g. `moto`, `car` |
| `vehiclePlate` | `string` | ✅ | Normalized plate |
| `checkedInAt` | `timestamp` | ✅ | Required |
| `checkedOutAt` | `timestamp` | ✅ | Optional; set khi checkout |
| `status` | `string` | ✅ | Default `'active'`; values: `active`, `completed`, … |
| `staffId` | `string` | ✅ | Staff check-in |
| `checkOutStaffId` | `string` | ✅ | Staff check-out |
| `userId` | `string` | ✅ | Optional; user liên kết (QR flow) |
| `vehicleId` | `string` | ✅ | Optional |
| `vehiclePhotoUrl` | `string` | ✅ | Optional |
| `checkInMethod` | `string` | ✅ | e.g. `manual`, `qr` |
| `checkOutMethod` | `string` | ✅ | e.g. `manual`, `qr` |
| `checkOutTokenId` | `string` | ✅ | Checkout QR token reference |
| `metadata` | `map` | ✅ | Extensible; IoT/BLE/QR/Camera reserved |

**Composite indexes** (see `firestore.indexes.json`): `lotId` + `status` + `checkedInAt`, `lotId` + `vehicleType` + `status` + `checkedInAt`, `lotId` + `vehiclePlate` + `status`, `lotId` + `status` + `checkedOutAt`.

---

## Related collections (chưa liệt kê chi tiết)

Các collection khác trong project (bổ sung sau):

- `staff_profiles`
- `pricing_history`
- `manual_adjustments`
- `bookings`
- `checkout_qr_tokens` / `qr_tokens` (user profile datasource)
- `users` / `vehicles` (user profile)

# BẢN HIẾN PHÁP PARKINGLINK (BẤT BIẾN)

**Project:** ParkingLink
**Kiến trúc:** Clean Architecture + Feature-first
**State Management:** Riverpod 2.0+
**Version:** Grok Handover v1.0

## 1. NGUYÊN TẮC CỐT LÕI (PHẢI TUÂN THỦ 100%)

1. **Layer Dependency Rule**
   - Presentation → Domain → Data
   - Presentation **KHÔNG** được import bất kỳ file nào trong Data layer
   - Domain **KHÔNG** import Firebase, http, package external nào

2. **Repository Pattern**
   - Tất cả truy vấn dữ liệu phải qua Interface (`IxxxRepository`)
   - Implementation nằm ở Data layer

3. **UseCase Rule**
   - 1 file = 1 UseCase
   - 1 UseCase = 1 method `FutureOr call(...)`
   - Không gộp nhiều logic vào 1 UseCase

4. **Feature Independence**
   - Mỗi feature là 1 folder độc lập trong `features/`
   - Thêm feature mới không được sửa code ở features khác hoặc core (trừ shared)

5. **Performance Rules (Rất quan trọng)**
   - Realtime stream phải giới hạn theo khu vực (geoquery) hoặc có pagination
   - Ưu tiên dùng Local Cache (Isar) cho dữ liệu hay đọc
   - Tránh stream quá rộng trên Map và Dashboard
   - Sử dụng `select` / `Consumer` / `family` để giảm rebuild UI

## 2. FOLDER STRUCTURE CHUẨN (Áp dụng ngay)

```text
lib/
├── core/
│   ├── config/
│   ├── di/                  # Riverpod providers chính
│   ├── error/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── utils/
│   └── constants.dart
│
├── features/
│   ├── auth/
│   ├── parking/             # Core business: lots, sessions, vehicle types
│   ├── staff/
│   ├── owner/
│   ├── user/
│   └── common/              # Shared models, widgets
│
│   └── [feature_name]/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/     # interfaces only
│       │   ├── usecases/
│       │   └── mappers/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/     # impl
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/
│
├── shared/                  # Design system, reusable widgets
└── main.dart
```

## 3. CODING STANDARDS

- Null safety 100%
- File naming: `snake_case.dart`
- Class: `PascalCase`
- Function / variable: `camelCase`
- Sử dụng `freezed` cho Entity và Model khi có thể
- Error phải throw `AppException`
- Comment rõ ràng cho mỗi UseCase và Repository method

## 5. NỀN TẢNG (iOS + Android ONLY)

**ParkingLink chỉ phát triển và build cho iOS và Android.**

- Không hỗ trợ Web, Desktop (macOS/Windows/Linux)
- Config, signing, flavors, assets chỉ tối ưu cho mobile
- Release targets:
  - **Android:** APK + AAB (`user` / `staff` flavors)
  - **iOS:** IPA cho TestFlight / App Store (`User` / `Staff` schemes)
- Bootstrap gọi `SupportedPlatforms.ensureMobile()` — app throw nếu chạy trên nền tảng không hỗ trợ
- Build scripts: `./scripts/build_production_mobile.sh` (Android), `./scripts/build_production_ios.sh` (iOS)

## 6. WORKFLOW VỚI CURSOR

- Luôn tuân thủ Bản Hiến Pháp này
- Khi implement, ưu tiên performance + clean code
- Sau khi code xong, kiểm tra lại dependency giữa các layer
- Commit theo format: `feat:`, `refactor:`, `perf:`, `fix:`

---

**Hướng dẫn sử dụng với Cursor + AgentMemory MCP:**

1. Tạo file mới trong project: `docs/constitution.md`
2. Paste toàn bộ nội dung trên vào file đó.
3. Trong Cursor, bạn có thể nói với AgentMemory:
   > "Từ giờ về sau, tuân thủ nghiêm ngặt Bản Hiến Pháp trong file constitution.md"

4. Mỗi khi bắt đầu task mới, bạn nhắc Cursor:
   > "Làm theo Bản Hiến Pháp Grok + Feature-first structure"

## 7. MULTI-APP ARCHITECTURE

**Hiện tại (Production — CP24):**
- Single codebase, **2 app binaries** qua flavors:
  - `ParkingLink User` — `com.parkinglink.user`
  - `ParkingLink Staff` — `com.parkinglink.staff`
- Android: product flavors `user` / `staff`
- iOS: schemes `User` / `Staff`
- Chung 1 Firebase project (`parkinglink-v2`), plist/json theo flavor

**Nguyên tắc thiết kế phải tuân thủ:**
- Domain và Data layer phải **thuần túy**, không phụ thuộc vào loại app
- Presentation phải tách rõ theo feature + role (`features/user/`, `features/staff/`, `features/owner/`)
- Không hardcode logic UI chung cho cả User và Staff
- Dễ dàng extract một phần presentation ra app riêng sau này

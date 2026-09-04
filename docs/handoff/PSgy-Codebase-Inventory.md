# PSgy Codebase Inventory

Nguồn: code thật trong `lib/features/pilot_demo/` tại thời điểm 2026-09-04 (commit `45c943b` trên `main`).

Chỉ đọc/liệt kê — không suy đoán field chưa có trong code. Không có folder `screens/`; màn hình nằm ở `presentation/`.

Đối chiếu nhanh với checklist handoff (tên thật, không phải tên Claude đoán):

| Claude có thể đoán | Tên / field THẬT trong code |
| --- | --- |
| `introduction` trên profile Coach | **Không có.** User thấy `MockCoach.bio`. Coach session dùng `MockCoachProfile.bio` (field cũ, seed khác). |
| `Package` | **`MockPackage`** — có `coachId` |
| Ví / wallet / `MockWalletPackage` | **Đã xoá.** User đã mua gói = **`MockPurchasedPackage`**, số buổi còn = **`remainingSessions`** |
| `packageId` trên booking | **`purchasedPackageId`** + **`purchasedPackageName`** trên `MockBookingRequest` |
| `paymentMethod` | enum **`MockPaymentMethod { cash, package }`** (không còn `wallet`) |
| `MockGym` | **Không tồn tại** trong `pilot_demo` |
| `Badge` / `UserBadge` | Cả hai class đều có (`models/mock_badge.dart`) |
| Reviews F1 | **`MockCoachReview`** + helper `reviewsForCoach` / `reviewStatsFor` — không nằm trên session |

---

## 1. Cây thư mục `lib/features/pilot_demo/`

```
lib/features/pilot_demo/
├── data/
│   ├── mock_coach_reviews.dart
│   ├── mock_coach_session.dart
│   ├── mock_coaches.dart
│   ├── mock_journal_seed.dart
│   └── mock_user_session.dart
├── models/
│   ├── mock_badge.dart
│   ├── mock_booking_request.dart
│   ├── mock_coach.dart
│   ├── mock_coach_profile.dart
│   ├── mock_coach_review.dart
│   ├── mock_journal_comment.dart
│   ├── mock_journal_post.dart
│   ├── mock_message.dart
│   ├── mock_package.dart          ← MockPackage + MockPurchasedPackage
│   ├── mock_service.dart
│   ├── mock_user_profile.dart
│   └── mock_user_streak.dart
└── presentation/
    ├── booking_pending_screen.dart
    ├── booking_status_style.dart     ← helper style, không phải screen
    ├── booking_summary_screen.dart
    ├── coach_detail_screen.dart
    ├── community_feed_screen.dart
    ├── create_journal_post_screen.dart
    ├── journal_media.dart            ← helper media, không phải screen
    ├── journal_photo_grid.dart       ← widget lưới, không phải screen
    ├── journal_post_card.dart        ← widget card, không phải screen
    ├── journal_post_detail_screen.dart
    ├── main_shell_screen.dart
    ├── mock_phone_auth_screen.dart
    ├── my_journal_screen.dart
    ├── pilot_list_screen.dart
    ├── pilot_map_screen.dart
    ├── user_booking_history_screen.dart
    ├── user_chat_screen.dart
    ├── user_profile_setup_screen.dart
    └── coach/
        ├── active_booking_screen.dart
        ├── booking_request_detail_screen.dart
        ├── coach_chat_screen.dart
        ├── coach_home_screen.dart
        ├── coach_services_screen.dart
        └── coach_student_journal_screen.dart
```

Đã xoá (không còn trong tree): `presentation/user_wallet_screen.dart`, `models/mock_wallet_package.dart`.

---

## 2. Toàn bộ model class

### 2.1 `models/mock_coach.dart` — `MockCoach`

Catalog Coach phía **User** (map/list/chi tiết). Field intro F1 nằm **ở đây**, tên `bio` (không phải `introduction`).

```dart
class MockCoach {
  final String id;
  final String name;
  final String initials;
  final double rating;
  final int yearsExperience;
  final double distanceKm;
  final String nextSlotLabel;
  final double lat;
  final double lng;
  final List<MockService> services;
  final List<MockPackage> packages;
  final String bio;

  const MockCoach({
    required this.id,
    required this.name,
    required this.initials,
    required this.rating,
    required this.yearsExperience,
    required this.distanceKm,
    required this.nextSlotLabel,
    required this.lat,
    required this.lng,
    required this.services,
    required this.packages,
    required this.bio,
  });
}
```

### 2.2 `models/mock_coach_profile.dart` — `MockCoachProfile`

Hồ sơ Coach phía **Coach app** (`MockCoachSession.profile`). **Đã có `bio` từ trước** (không phải field mới tên `introduction`). Seed hiện tại ngắn hơn `MockCoach.bio` của `coach_01` — hai nguồn độc lập, không sync.

```dart
class MockCoachProfile {
  final String id;
  final String name;
  final String avatarInitials;
  final String bio;
  final int yearsExperience;
  final double ratingAvg;
  final int ratingCount;
  final bool isAvailableNow;
  final String availableFrom;
  final String availableUntil;
  final String currentLocationLabel;

  const MockCoachProfile({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.bio,
    required this.yearsExperience,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isAvailableNow,
    required this.availableFrom,
    required this.availableUntil,
    required this.currentLocationLabel,
  });

  String get hoursLabel => '$availableFrom - $availableUntil';

  MockCoachProfile copyWith({
    bool? isAvailableNow,
    String? currentLocationLabel,
  });
}
```

### 2.3 `models/mock_package.dart` — `MockPackage`

**Có `coachId`.** Không còn `validityDays` (era ví hệ thống).

```dart
class MockPackage {
  final String id;
  final String coachId;
  final String name;
  final int sessionCount;
  final int totalPriceVnd;
  final String description;

  const MockPackage({
    required this.id,
    required this.coachId,
    required this.name,
    required this.sessionCount,
    required this.totalPriceVnd,
    required this.description,
  });

  String get priceLabel => formatVnd(totalPriceVnd);
  MockPackage copyWith({ ... });
}
```

### 2.4 `models/mock_package.dart` — `MockPurchasedPackage`

**Đây là model “gói User đã mua của 1 Coach”.** Số buổi còn lại = `remainingSessions`. Không còn class ví.

```dart
class MockPurchasedPackage {
  final String id;
  final String packageId;
  final String coachId;
  final String packageName;
  final int sessionCount;
  final int remainingSessions;
  final DateTime purchasedAt;

  const MockPurchasedPackage({
    required this.id,
    required this.packageId,
    required this.coachId,
    required this.packageName,
    required this.sessionCount,
    required this.remainingSessions,
    required this.purchasedAt,
  });

  String get remainingLabel => 'Còn $remainingSessions / $sessionCount buổi';
  MockPurchasedPackage copyWith({int? remainingSessions});
}
```

### 2.5 `models/mock_booking_request.dart`

```dart
enum MockBookingStatus {
  pending,
  confirmed,
  inProgress,
  awaitingUserConfirmation,
  completed,
  cancelled,
}

enum MockPaymentMethod { cash, package }

class MockBookingRequest {
  final String id;
  final String userName;
  final String userAvatarInitials;
  final String serviceName;
  final int priceVnd;
  final String requestedTimeLabel;
  final String locationLabel;
  final MockBookingStatus status;
  final String? cancelReason;
  final MockPaymentMethod paymentMethod;
  final String? purchasedPackageId;
  final String? purchasedPackageName;
  final int? rating;
  final String? reviewComment;
  final String coachId;
  final String coachName;

  const MockBookingRequest({
    required this.id,
    required this.userName,
    required this.userAvatarInitials,
    required this.serviceName,
    required this.priceVnd,
    required this.requestedTimeLabel,
    required this.locationLabel,
    required this.status,
    this.cancelReason,
    this.paymentMethod = MockPaymentMethod.cash,
    this.purchasedPackageId,
    this.purchasedPackageName,
    this.rating,
    this.reviewComment,
    this.coachId = '',
    this.coachName = '',
  });
}
```

Getter: `priceLabel`, `paymentSummary`, `paymentMethodLabel`, `isActive`, `isTrackable`, `statusLabel`.  
`copyWith({ MockBookingStatus? status, String? cancelReason, int? rating, String? reviewComment })`.

Gói đang dùng khi đặt lịch: **`purchasedPackageId`** (id của `MockPurchasedPackage`, không phải `MockPackage.id`) + **`purchasedPackageName`**.

### 2.6 `models/mock_coach_review.dart` — F1 đã build

```dart
class MockCoachReview {
  final String id;
  final String coachId;
  final String reviewerName;
  final int rating;          // 1–5
  final String comment;
  final DateTime date;

  const MockCoachReview({
    required this.id,
    required this.coachId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class MockCoachReviewStats {
  final int count;
  final double average;
  final List<int> countsByStar;   // index 0 unused; 1..5 = số review

  const MockCoachReviewStats({
    required this.count,
    required this.average,
    required this.countsByStar,
  });

  double percentOf(int star);
  String get summaryLabel;        // vd "4.1/5 · 8 đánh giá"
}

MockCoachReviewStats reviewStatsFor(Iterable<MockCoachReview> reviews);
```

Seed: `data/mock_coach_reviews.dart` — `List<MockCoachReview> mockCoachReviews` (8 review, chỉ `coachId: 'coach_01'`).  
`List<MockCoachReview> reviewsForCoach(String coachId)` — lọc + sort `date` mới nhất trước.

### 2.7 `models/mock_journal_post.dart`

```dart
enum JournalPrivacy { private, coachOnly, public }

class JournalPost {
  final String id;
  final String userId;
  final String bookingId;
  final String coachId;
  final String coachName;
  final String serviceName;
  final int durationMinutes;
  final String caption;
  final String? mediaUrl;
  final JournalPrivacy privacy;
  final DateTime createdAt;
  final List<String> likeUserIds;
  final int commentCount;
  final bool reported;

  const JournalPost({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.coachId,
    required this.coachName,
    required this.serviceName,
    required this.durationMinutes,
    required this.caption,
    this.mediaUrl,
    required this.privacy,
    required this.createdAt,
    this.likeUserIds = const [],
    this.commentCount = 0,
    this.reported = false,
  });

  JournalPost copyWith({
    List<String>? likeUserIds,
    int? commentCount,
    bool? reported,
  });
}
```

### 2.8 `models/mock_journal_comment.dart`

```dart
class JournalComment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  const JournalComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });
}
```

### 2.9 `models/mock_user_streak.dart`

```dart
class UserStreak {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  const UserStreak({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
  });

  UserStreak copyWith({ ... });
}
```

### 2.10 `models/mock_badge.dart`

```dart
class Badge {
  final String id;
  final String name;
  final String description;
  final String iconAsset;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
  });
}

class UserBadge {
  final String userId;
  final String badgeId;
  final DateTime earnedAt;

  const UserBadge({
    required this.userId,
    required this.badgeId,
    required this.earnedAt,
  });
}
```

Catalog tĩnh `const mockBadges`: `badge_first_session`, `badge_streak_3`, `badge_streak_7`.

### 2.11 `models/mock_service.dart`

```dart
class MockService {
  final String id;
  final String name;
  final int priceVnd;
  final int durationMinutes;

  const MockService({
    required this.id,
    required this.name,
    required this.priceVnd,
    required this.durationMinutes,
  });

  String get priceLabel => formatVnd(priceVnd);
  MockService copyWith({ ... });
}

String formatVnd(int priceVnd);   // "300.000đ"
```

### 2.12 `models/mock_user_profile.dart`

```dart
class MockUserProfile {
  final String id;
  final String phone;
  final String name;
  final String? avatarPath;
  final DateTime createdAt;

  const MockUserProfile({
    required this.id,
    required this.phone,
    required this.name,
    this.avatarPath,
    required this.createdAt,
  });
}
```

### 2.13 `models/mock_message.dart`

```dart
enum MockSenderRole { user, coach }

class MockMessage {
  final String id;
  final MockSenderRole senderRole;
  final String text;
  final String sentAtLabel;

  const MockMessage({
    required this.id,
    required this.senderRole,
    required this.text,
    required this.sentAtLabel,
  });

  bool get isFromCoach => senderRole == MockSenderRole.coach;
}
```

### 2.14 Không có trong `pilot_demo`

- **`MockGym` / Gym (Admin):** không có class, không có file.
- **`MockWalletPackage`:** đã xoá.
- **`introduction`:** không có field này trên bất kỳ model nào.

---

## 3. Bề mặt public — session

UI bind `ChangeNotifier` singleton: `MockUserSession.instance` / `MockCoachSession.instance`.

### 3.1 `MockUserSession` — field public

| Field | Type |
| --- | --- |
| `instance` | `static final MockUserSession` |
| `profile` | `MockUserProfile?` |
| `purchasedPackages` | `List<MockPurchasedPackage>` |
| `bookings` | `List<MockBookingRequest>` |
| `messages` | `Map<String, List<MockMessage>>` — key = **bookingId** |
| `coachInquiryMessages` | `Map<String, List<MockMessage>>` — key = **coachId** (chat trước khi đặt) |
| `journalPosts` | `List<JournalPost>` |
| `journalComments` | `List<JournalComment>` |
| `userStreak` | `UserStreak` |
| `userBadges` | `List<UserBadge>` |

Private: `String? _verifiedPhone`.

### 3.2 `MockUserSession` — method public

```dart
List<MockPurchasedPackage> usablePackagesFor(String coachId);

void rememberVerifiedPhone(String? phone);

void createProfile({required String name, String? avatarPath});

void purchasePackage(MockPackage package);

MockBookingRequest placeBooking({
  required String coachId,
  required String coachName,
  required String serviceName,
  required int priceVnd,
  required String requestedTimeLabel,
  required MockPaymentMethod paymentMethod,
  String? purchasedPackageId,
});

MockBookingRequest? bookingById(String id);

List<MockMessage> messagesFor(String bookingId);

void updateBookingStatus(
  String bookingId,
  MockBookingStatus status, {
  int? rating,
  String? reviewComment,
});

void addJournalPost({
  required String bookingId,
  required String coachId,
  required String coachName,
  required String serviceName,
  required int durationMinutes,
  required String caption,
  String? mediaUrl,
  required JournalPrivacy privacy,
});

MockUserProfile? profileById(String userId);

String displayNameFor(String userId);

JournalPost? journalPostById(String id);

List<JournalComment> commentsForPost(String postId);

void toggleJournalLike(String postId);

void addJournalComment(String postId, String text);

void reportJournalPost(String postId);

List<MockMessage> inquiryMessagesFor(String coachId);

void ensureCoachInquiry(String coachId);

void addInquiryMessage(String coachId, String text);

void addUserMessage(String bookingId, String text);
```

Private (không phải bề mặt UI): `_applyCompletionRewards()`, `_awardBadge(String badgeId, String userId)`, `_dateOnly(DateTime)`, `_initials(String)`.

`placeBooking`: nếu `paymentMethod == package` và có `purchasedPackageId` thì `remainingSessions -= 1` trên đúng `MockPurchasedPackage`.

### 3.3 `MockCoachSession` — field public

| Field | Type |
| --- | --- |
| `instance` | `static final MockCoachSession` |
| `profile` | `MockCoachProfile` |
| `bookings` | `List<MockBookingRequest>` |
| `services` | `List<MockService>` |
| `packages` | `List<MockPackage>` |
| `messages` | `Map<String, List<MockMessage>>` — key = bookingId |
| `studentJournalPosts` | `List<JournalPost>` — seed độc lập, **không** đọc `MockUserSession` |

### 3.4 `MockCoachSession` — method / getter public

```dart
String studentNameFor(String userId);

List<MockBookingRequest> get pendingBookings;
List<MockBookingRequest> get activeBookings;

MockBookingRequest? bookingById(String id);

List<MockMessage> messagesFor(String bookingId);

void setAvailable(bool value);

void cycleLocation();

void updateBookingStatus(
  String bookingId,
  MockBookingStatus status, {
  String? cancelReason,
});

void addCoachMessage(String bookingId, String text);

void upsertService(MockService service);

void removeService(String id);   // no-op nếu services.length <= 1

void upsertPackage(MockPackage package);

void removePackage(String id);
```

Hai session **không đồng bộ** nhau. Comment trong code: bản thật cần Firestore sync xuyên 2 app.

### 3.5 Data catalog (không phải session, UI vẫn đọc trực tiếp)

| Symbol | File | Ý nghĩa |
| --- | --- | --- |
| `const List<MockCoach> mockCoaches` | `data/mock_coaches.dart` | 6 coach User map/list |
| `mockCoachReviews` / `reviewsForCoach` | `data/mock_coach_reviews.dart` | Review F1, không qua session |
| `mockSampleUsers` / `mockSeedJournalPosts` / `mockSeedJournalComments` | `data/mock_journal_seed.dart` | Seed journal + 3 user mẫu |

---

## 4. Screen / widget và method session chúng gọi

Không có `screens/`. Dưới đây là mọi file `.dart` trong `presentation/` (kể cả widget phụ).

| File | Class Widget chính | `MockUserSession` | `MockCoachSession` |
| --- | --- | --- | --- |
| `main_shell_screen.dart` | `MainShellScreen` | — | — |
| `pilot_map_screen.dart` | `PilotMapScreen` | — (đọc `mockCoaches`) | — |
| `pilot_list_screen.dart` | `PilotListScreen` | — (đọc `mockCoaches`) | — |
| `coach_detail_screen.dart` | `CoachDetailScreen` | `purchasePackage`, field `purchasedPackages` | — |
| | | Review: `reviewsForCoach` / `reviewStatsFor` (không qua session) | |
| `booking_summary_screen.dart` | `BookingSummaryScreen` | `usablePackagesFor`, `placeBooking` | — |
| `booking_pending_screen.dart` | `BookingPendingScreen` | `bookingById`, `updateBookingStatus` | — |
| `user_chat_screen.dart` | `UserChatScreen` | Inquiry: `ensureCoachInquiry`, `addInquiryMessage`, `inquiryMessagesFor`. Booking: `addUserMessage`, `messagesFor` | — |
| `user_booking_history_screen.dart` | `UserBookingHistoryScreen` | field `bookings` | — |
| `user_profile_setup_screen.dart` | `UserProfileSetupScreen` | `createProfile` | — |
| `mock_phone_auth_screen.dart` | `MockPhoneAuthScreen` | `rememberVerifiedPhone` | — |
| `my_journal_screen.dart` | `MyJournalScreen` | `profile`, `journalPosts`, `userStreak`, `userBadges` | — |
| `community_feed_screen.dart` | `CommunityFeedScreen` | `journalPosts` (filter `JournalPrivacy.public`) | — |
| `create_journal_post_screen.dart` | `CreateJournalPostScreen` | `addJournalPost` | — |
| `journal_post_detail_screen.dart` | `JournalPostDetailScreen` | `journalPostById`, `commentsForPost`, `addJournalComment`, `toggleJournalLike`, `reportJournalPost`, `profile` | `studentJournalPosts`, `studentNameFor` |
| `journal_post_card.dart` | `JournalPostCard` | `profileById`, `displayNameFor`, `profile` | — |
| `journal_photo_grid.dart` | `JournalPhotoGrid` | — | — |
| `journal_media.dart` | (functions) | — | — |
| `booking_status_style.dart` | (functions) | — | — |
| `coach/coach_home_screen.dart` | `CoachHomeScreen` | — | `profile`, `pendingBookings`, `activeBookings`, `setAvailable`, `cycleLocation` |
| `coach/coach_services_screen.dart` | `CoachServicesScreen` | — | `profile` (lấy `id` khi tạo gói), `services`, `packages`, `upsertService`, `removeService`, `upsertPackage`, `removePackage` |
| `coach/booking_request_detail_screen.dart` | `BookingRequestDetailScreen` | — | `bookingById`, `updateBookingStatus` |
| `coach/active_booking_screen.dart` | `ActiveBookingScreen` | — | `bookingById`, `updateBookingStatus` |
| `coach/coach_chat_screen.dart` | `CoachChatScreen` | — | `addCoachMessage`, `bookingById`, `messagesFor` |
| `coach/coach_student_journal_screen.dart` | `CoachStudentJournalScreen` | — | `studentJournalPosts` |

Ghi chú UI:

- Chat **trước booking** (`UserChatScreen.inquiryCoachId`) ≠ chat **sau confirmed** (`bookingId`). Hai map riêng.
- `CoachDetailScreen` / `PilotMapScreen` đọc `MockCoach` từ `mockCoaches`, không từ `MockCoachSession.profile`.
- Card đánh giá trên chi tiết Coach tính từ `mockCoachReviews`, không hardcode số liệu.

---

## 5. `pubspec.yaml` — `dependencies:`

Copy nguyên (không gồm `dev_dependencies`):

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Core
  firebase_core: ^3.15.2
  cloud_firestore: ^5.4.4
  firebase_auth: ^5.3.1
  firebase_messaging: ^15.2.10
  firebase_crashlytics: ^4.3.10
  firebase_performance: ^0.10.1+8
  google_maps_flutter: ^2.9.0
  geolocator: ^13.0.0

  # State Management
  flutter_riverpod: ^2.5.1

  # Utils
  uuid: ^4.5.0
  equatable: ^2.0.7
  intl: ^0.19.0
  fluttertoast: ^8.2.8
  path_provider: ^2.1.5

  # Local cache
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

  # QR Code
  qr_flutter: ^4.1.0
  mobile_scanner: ^6.0.0

  # Navigation & UI
  go_router: ^14.2.0
  url_launcher: ^6.3.0
  connectivity_plus: ^7.1.1
  flutter_local_notifications: ^18.0.1
  firebase_storage: ^12.4.10
  image_picker: ^1.1.2
  google_fonts: ^6.2.1
  figma_squircle: ^0.6.3
```

Trong `pilot_demo`, import trực tiếp thấy: `image_picker` (`user_profile_setup_screen`, `create_journal_post_screen`), `google_maps_flutter` (`pilot_map_screen`), `intl`. `google_fonts` / `figma_squircle` / `cloud_firestore` dùng ở phần app ngoài `pilot_demo` (theme / ParkingLink), đã khai báo ở đây.

---

## 6. TODO / FIXME / comment backend

Grep `// TODO`, `// FIXME`, `// backend` trong `lib/features/pilot_demo/`: **0 kết quả**.

Các comment liên quan backend / Firestore (nguyên văn + dòng):

| File | Dòng | Nguyên văn |
| --- | --- | --- |
| `data/mock_coach_session.dart` | 16–17 | `// Mock độc lập minh hoạ UI — không đọc MockUserSession.` / `// Bản thật cần Firestore sync xuyên 2 app (việc đội dev sau).` |
| `data/mock_coach_session.dart` | 198–200 | `/// Data mock độc lập minh hoạ UI Coach xem nhật ký học viên.` / `/// Không đồng bộ với MockUserSession / journalPosts phía User.` / `/// Bản thật cần Firestore sync xuyên 2 app (việc đội dev sau).` |
| `presentation/coach/coach_student_journal_screen.dart` | 7–9 | `/// Nhật ký học viên — đọc-only từ seed MockCoachSession.` / `/// Data mock độc lập minh hoạ UI, không kéo từ MockUserSession.` / `/// Bản thật cần Firestore sync xuyên 2 app (việc đội dev sau).` |
| `presentation/booking_pending_screen.dart` | 50–51 | `/// DEMO ONLY: auto-advance fakes Coach actions on this device.` / `/// Production must sync status via Firestore between User and Coach apps.` |
| `presentation/mock_phone_auth_screen.dart` | 7 | `/// TEMP: pilot demo OTP — no Firebase. Real flow remains in PhoneAuthScreen.` |
| `data/mock_user_session.dart` | 12 | `/// In-memory user session for the pilot. Not persisted across app restarts.` |
| `data/mock_coach_session.dart` | 9 | `/// In-memory coach session for the 22/08 pilot. Not persisted.` |

---

## Phụ lục — hai nguồn Coach không trùng

| | User catalog | Coach session |
| --- | --- | --- |
| Model | `MockCoach` | `MockCoachProfile` + lists riêng |
| Bio F1 (dài, intro card) | `MockCoach.bio` | `MockCoachProfile.bio` (ngắn hơn, UI Coach home không hiện card Giới thiệu) |
| Gói | `MockCoach.packages` | `MockCoachSession.packages` |
| Dịch vụ | `MockCoach.services` | `MockCoachSession.services` |
| Review | `mockCoachReviews` theo `coachId` | không có |
| Journal | `MockUserSession.journalPosts` | `MockCoachSession.studentJournalPosts` (seed khác) |

Backend thay mock cần **một** nguồn sự thật rồi sync hai app — đây là chỗ code hiện cố tình tách.

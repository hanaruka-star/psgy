import 'package:psgy/features/pilot_demo/models/mock_availability_slot.dart';
import 'package:psgy/features/pilot_demo/models/mock_training_location.dart';

/// Hồ sơ phía Coach app. Độc lập với [MockCoach] (catalog User).
/// Đợt 2 (chưa làm): slideshow 5 ảnh + case-study học viên — chọn từ kho ảnh
/// mẫu trong app, không mở thư viện máy (chưa có Storage thật).
class MockCoachProfile {
  static const goalOptions = [
    'Tăng cơ',
    'Giảm mỡ',
    'Tăng sức bền',
    'Phục hồi sau chấn thương',
  ];

  static const audienceOptions = [
    'Nam',
    'Nữ',
    'VĐV',
    'Người mới bắt đầu',
    'Phục hồi chấn thương',
  ];

  static const formatOptions = ['1-1', 'Online', 'Nhóm 1-2'];

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
  final List<String> goals;
  final List<String> targetAudience;
  final List<String> trainingFormats;
  final List<MockAvailabilitySlot> weeklyAvailability;
  final List<MockTrainingLocation> trainingLocations;
  final String bookingCancellationPolicy;
  final List<String> certifications;
  final bool gymFeeIncluded;
  final String? membershipFeeLabel;

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
    this.goals = const [],
    this.targetAudience = const [],
    this.trainingFormats = const [],
    this.weeklyAvailability = const [],
    this.trainingLocations = const [],
    this.bookingCancellationPolicy = '',
    this.certifications = const [],
    this.gymFeeIncluded = false,
    this.membershipFeeLabel,
  });

  String get hoursLabel => '$availableFrom - $availableUntil';

  String get avatarAsset => 'assets/avatars/$id.png';

  MockCoachProfile copyWith({
    String? bio,
    bool? isAvailableNow,
    String? currentLocationLabel,
    List<String>? goals,
    List<String>? targetAudience,
    List<String>? trainingFormats,
    List<MockAvailabilitySlot>? weeklyAvailability,
    List<MockTrainingLocation>? trainingLocations,
    String? bookingCancellationPolicy,
    List<String>? certifications,
    bool? gymFeeIncluded,
    String? membershipFeeLabel,
    bool clearMembershipFeeLabel = false,
  }) {
    return MockCoachProfile(
      id: id,
      name: name,
      avatarInitials: avatarInitials,
      bio: bio ?? this.bio,
      yearsExperience: yearsExperience,
      ratingAvg: ratingAvg,
      ratingCount: ratingCount,
      isAvailableNow: isAvailableNow ?? this.isAvailableNow,
      availableFrom: availableFrom,
      availableUntil: availableUntil,
      currentLocationLabel: currentLocationLabel ?? this.currentLocationLabel,
      goals: goals ?? this.goals,
      targetAudience: targetAudience ?? this.targetAudience,
      trainingFormats: trainingFormats ?? this.trainingFormats,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      trainingLocations: trainingLocations ?? this.trainingLocations,
      bookingCancellationPolicy:
          bookingCancellationPolicy ?? this.bookingCancellationPolicy,
      certifications: certifications ?? this.certifications,
      gymFeeIncluded: gymFeeIncluded ?? this.gymFeeIncluded,
      membershipFeeLabel: clearMembershipFeeLabel
          ? null
          : (membershipFeeLabel ?? this.membershipFeeLabel),
    );
  }
}

import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

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

  /// Ảnh hồ sơ mock (5 tấm / Coach). Bản demo không tách
  /// "ảnh Admin upload" vs "ảnh Coach tự up" — backend làm khi có Admin tool.
  final List<String> photoUrls;
  final int totalBookings;
  final List<String> goals;
  final List<String> targetAudience;
  final List<String> trainingFormats;
  final bool gymFeeIncluded;
  final String trainingLocationAddress;
  final String? membershipFeeLabel;
  final List<String> studentResults;
  final List<String> certifications;
  final String bookingCancellationPolicy;

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
    this.photoUrls = const [],
    this.totalBookings = 0,
    this.goals = const [],
    this.targetAudience = const [],
    this.trainingFormats = const [],
    this.gymFeeIncluded = false,
    this.trainingLocationAddress = '',
    this.membershipFeeLabel,
    this.studentResults = const [],
    this.certifications = const [],
    this.bookingCancellationPolicy = '',
  });
}

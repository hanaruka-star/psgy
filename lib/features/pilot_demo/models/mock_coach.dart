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

import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

const _personal60 = MockService(
  id: 'svc_personal_60',
  name: 'Tập cá nhân 60 phút',
  priceVnd: 300000,
  durationMinutes: 60,
);

const _duo60 = MockService(
  id: 'svc_duo_60',
  name: 'Tập cặp đôi 60 phút',
  priceVnd: 500000,
  durationMinutes: 60,
);

const _nutrition = MockService(
  id: 'svc_nutrition',
  name: 'Tư vấn dinh dưỡng',
  priceVnd: 150000,
  durationMinutes: 45,
);

const _personal90 = MockService(
  id: 'svc_personal_90',
  name: 'Tập cá nhân 90 phút',
  priceVnd: 420000,
  durationMinutes: 90,
);

/// System catalog — shared across every Coach, not owned by one coach.
const mockSystemPackages = [
  MockPackage(
    id: 'pkg_10',
    name: 'Gói 10 buổi',
    sessionCount: 10,
    totalPriceVnd: 2500000,
    description: 'Linh hoạt lịch trong 3 tháng, tiết kiệm so với tập lẻ.',
    validityDays: 90,
  ),
  MockPackage(
    id: 'pkg_20',
    name: 'Gói 20 buổi',
    sessionCount: 20,
    totalPriceVnd: 4500000,
    description: 'Ưu đãi dài hạn, kèm 1 buổi tư vấn dinh dưỡng.',
    validityDays: 180,
  ),
];

const List<MockCoach> mockCoaches = [
  MockCoach(
    id: 'coach_01',
    name: 'Nguyễn Văn Long',
    initials: 'NL',
    rating: 4.8,
    yearsExperience: 8,
    distanceKm: 0.8,
    nextSlotLabel: 'Rảnh 18:00 hôm nay',
    lat: 10.7765,
    lng: 106.7009,
    services: [_personal60, _duo60, _nutrition],
  ),
  MockCoach(
    id: 'coach_02',
    name: 'Trần Thị Mai',
    initials: 'TM',
    rating: 4.9,
    yearsExperience: 10,
    distanceKm: 1.5,
    nextSlotLabel: 'Rảnh 19:30 hôm nay',
    lat: 10.7798,
    lng: 106.6882,
    services: [_personal60, _nutrition],
  ),
  MockCoach(
    id: 'coach_03',
    name: 'Lê Hoàng Nam',
    initials: 'LN',
    rating: 4.6,
    yearsExperience: 6,
    distanceKm: 2.1,
    nextSlotLabel: 'Rảnh 17:00 hôm nay',
    lat: 10.8104,
    lng: 106.7098,
    services: [_personal60, _duo60],
  ),
  MockCoach(
    id: 'coach_04',
    name: 'Phạm Minh Châu',
    initials: 'PC',
    rating: 4.7,
    yearsExperience: 7,
    distanceKm: 3.4,
    nextSlotLabel: 'Rảnh 07:00 ngày mai',
    lat: 10.7872,
    lng: 106.7185,
    services: [_personal90, _nutrition, _duo60],
  ),
  MockCoach(
    id: 'coach_05',
    name: 'Võ Thành Đạt',
    initials: 'VĐ',
    rating: 4.2,
    yearsExperience: 4,
    distanceKm: 4.2,
    nextSlotLabel: 'Rảnh 20:00 hôm nay',
    lat: 10.7721,
    lng: 106.7210,
    services: [_personal60, _duo60],
  ),
  MockCoach(
    id: 'coach_06',
    name: 'Hoàng Thị Thu Hà',
    initials: 'HH',
    rating: 4.5,
    yearsExperience: 12,
    distanceKm: 5.0,
    nextSlotLabel: 'Rảnh 09:00 ngày mai',
    lat: 10.8250,
    lng: 106.6952,
    services: [_personal60, _nutrition, _personal90],
  ),
];

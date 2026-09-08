import 'package:psgy/features/pilot_demo/models/mock_gym.dart';

const _collected = MockGym.sourceCollected;
const _partner = MockGym.sourcePartner;

/// DEMO DATA — seed bản đồ User, xoá khi có backend gym thật.
final List<MockGym> mockGyms = [
  const MockGym(
    id: 'gym_sys_01',
    name: 'California Fitness Nguyễn Du',
    address: '117 Nguyễn Du, Q.1, TP.HCM',
    lat: 10.7758,
    lng: 106.7019,
    gymSourceType: _partner,
  ),
  const MockGym(
    id: 'gym_col_01',
    name: 'Gym Xóm Chiếu',
    address: '12 Xóm Chiếu, Q.4, TP.HCM',
    lat: 10.7640,
    lng: 106.7065,
    gymSourceType: _collected,
  ),
  const MockGym(
    id: 'gym_sys_02',
    name: 'California Fitness Q.7',
    address: '209 Nguyễn Văn Linh, Q.7, TP.HCM',
    lat: 10.7328,
    lng: 106.7215,
    gymSourceType: _partner,
  ),
  const MockGym(
    id: 'gym_col_02',
    name: 'Phòng tập Nguyễn Văn Cừ',
    address: '88 Nguyễn Văn Cừ, Q.5, TP.HCM',
    lat: 10.7588,
    lng: 106.6821,
    gymSourceType: _collected,
  ),
  const MockGym(
    id: 'gym_sys_03',
    name: 'GetFit Phú Mỹ Hưng',
    address: 'S01 Sky Garden 1, Q.7, TP.HCM',
    lat: 10.7294,
    lng: 106.7218,
    gymSourceType: _partner,
  ),
  const MockGym(
    id: 'gym_col_03',
    name: 'Gym nhà trọ Thủ Đức',
    address: '45 Võ Văn Ngân, Thủ Đức, TP.HCM',
    lat: 10.8494,
    lng: 106.7617,
    gymSourceType: _collected,
  ),
  const MockGym(
    id: 'gym_sys_04',
    name: 'Elite Fitness Landmark 81',
    address: '720A Điện Biên Phủ, Bình Thạnh, TP.HCM',
    lat: 10.7943,
    lng: 106.7218,
    gymSourceType: _partner,
  ),
  const MockGym(
    id: 'gym_col_04',
    name: 'Phòng tạ Bình Thạnh',
    address: '210 Nơ Trang Long, Bình Thạnh, TP.HCM',
    lat: 10.8016,
    lng: 106.7108,
    gymSourceType: _collected,
  ),
  const MockGym(
    id: 'gym_sys_05',
    name: 'Citigym Hai Bà Trưng',
    address: '59-61 Hai Bà Trưng, Q.1, TP.HCM',
    lat: 10.7824,
    lng: 106.6951,
    gymSourceType: _partner,
  ),
  const MockGym(
    id: 'gym_col_05',
    name: 'Gym 24h Tân Bình',
    address: '32 Hoàng Văn Thụ, Tân Bình, TP.HCM',
    lat: 10.8011,
    lng: 106.6525,
    gymSourceType: _collected,
  ),
];

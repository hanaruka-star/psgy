import type { Gym, PT, Spa, AlbumPhoto, PtPackage, Contract, Session, Review, WeightPoint } from '@/domain/types';
import type { PtTier } from '@/config/business';

const GYM_IMG = [
  '/assets/journal/gym-01.jpg',
  '/assets/journal/gym-02.jpg',
  '/assets/journal/gym-03.jpg',
  '/assets/journal/gym-04.jpg',
  '/assets/journal/gym-05.jpg',
  '/assets/journal/gym-06.jpg',
];

const UNSPLASH = [
  'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1574680096145-d05b474e2155?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1518310383802-640c2de311b2?auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1599058917212-d750089bc07e?auto=format&fit=crop&w=800&q=60',
];

function album(now: number, urls: string[]): AlbumPhoto[] {
  const day = 86400000;
  return urls.slice(0, 6).map((url, i) => {
    const uploadedAt = now - [1, 3, 8, 12, 16, 20][i] * day;
    const expiresAt = uploadedAt + 15 * day;
    const expired = expiresAt < now;
    const expiring = !expired && expiresAt - now < 3 * day;
    return {
      id: `ph_${i}_${uploadedAt}`,
      url,
      uploadedAt,
      expiresAt,
      status: expired ? 'expired' : 'approved',
      ...(expiring ? {} : {}),
    };
  });
}

function pkgs(pt: string, from: number): PtPackage[] {
  const one = from;
  return [
    { id: `${pt}_p1`, kind: 'personal', name: '1 buổi', sessions: 1, priceVnd: one, perWeek: 1 },
    { id: `${pt}_p5`, kind: 'personal', name: '5 buổi', sessions: 5, priceVnd: Math.round(one * 5 * 0.92), perWeek: 2 },
    { id: `${pt}_p10`, kind: 'personal', name: '10 buổi', sessions: 10, priceVnd: Math.round(one * 10 * 0.85), perWeek: 3 },
    { id: `${pt}_p12`, kind: 'personal', name: '12 buổi', sessions: 12, priceVnd: Math.round(one * 12 * 0.82), perWeek: 3 },
    { id: `${pt}_g8`, kind: 'group', name: 'Nhóm 8 buổi', sessions: 8, priceVnd: Math.round(one * 8 * 0.55), perWeek: 2 },
  ];
}

const slots = (['07:00', '09:00', '18:00', '19:00'] as const).flatMap((start, i) =>
  [1, 2, 3, 4, 5, 6].map((wd) => ({
    weekday: wd,
    start,
    end: ['08:00', '10:00', '19:00', '20:00'][i],
  })),
);

type Raw = {
  id: string;
  name: string;
  initials: string;
  age: number;
  area: string;
  lat: number;
  lng: number;
  specialties: string[];
  years: number;
  tier: PtTier;
  sessionsTaught: number;
  avatar: string;
  priceFrom: number;
  distanceKm: number;
  featured?: boolean;
  bio: string;
};

const RAW: Raw[] = [
  { id: 'pt_01', name: 'Nguyễn Văn Long', initials: 'NL', age: 32, area: 'Quận 1', lat: 10.7765, lng: 106.7009, specialties: ['Giảm mỡ', 'Tăng cơ', 'Người mới'], years: 8, tier: 'gold', sessionsTaught: 214, avatar: '/assets/avatars/coach_01.png', priceFrom: 350000, distanceKm: 0.8, featured: true, bio: 'HLV 8 năm, kỹ thuật trước tăng tạ. Giáo án rõ mục tiêu từng buổi.' },
  { id: 'pt_02', name: 'Trần Thị Mai', initials: 'TM', age: 28, area: 'Quận 3', lat: 10.7822, lng: 106.6945, specialties: ['Giảm mỡ', 'Yoga'], years: 5, tier: 'silver', sessionsTaught: 96, avatar: '/assets/avatars/coach_02.png', priceFrom: 280000, distanceKm: 1.5, bio: 'Tập bền, phục hồi tốt, hợp dân văn phòng.' },
  { id: 'pt_03', name: 'Lê Hoàng Nam', initials: 'LN', age: 30, area: 'Bình Thạnh', lat: 10.8011, lng: 106.7108, specialties: ['Tăng cơ', 'VĐV'], years: 7, tier: 'gold', sessionsTaught: 180, avatar: '/assets/avatars/coach_03.png', priceFrom: 400000, distanceKm: 2.1, bio: 'Powerbuilding, chỉnh form nghiêm.' },
  { id: 'pt_04', name: 'Phạm Minh Châu', initials: 'PC', age: 26, area: 'Quận 7', lat: 10.7328, lng: 106.7215, specialties: ['Người mới', 'Cải thiện sức khỏe'], years: 4, tier: 'silver', sessionsTaught: 70, avatar: '/assets/avatars/coach_04.png', priceFrom: 250000, distanceKm: 4.2, bio: 'Đi từ zero, không ép thực đơn cực đoan.' },
  { id: 'pt_05', name: 'Võ Thành Đạt', initials: 'VĐ', age: 34, area: 'Thủ Đức', lat: 10.8494, lng: 106.7617, specialties: ['Tăng sức bền', 'Cardio'], years: 9, tier: 'platinum', sessionsTaught: 310, avatar: '/assets/avatars/coach_05.png', priceFrom: 450000, distanceKm: 8.4, featured: true, bio: 'Endurance + sức mạnh, từng dẫn runner 21km.' },
  { id: 'pt_06', name: 'Hoàng Thị Thu Hà', initials: 'HH', age: 29, area: 'Phú Nhuận', lat: 10.799, lng: 106.678, specialties: ['Giảm mỡ', 'Người mới'], years: 6, tier: 'gold', sessionsTaught: 140, avatar: '/assets/avatars/coach_06.png', priceFrom: 320000, distanceKm: 3.1, bio: 'Nữ HLV, tập tôn dáng, lịch linh hoạt tối.' },
  { id: 'pt_07', name: 'Đặng Quốc Huy', initials: 'ĐH', age: 27, area: 'Tân Bình', lat: 10.8011, lng: 106.6525, specialties: ['Tăng cơ', 'Boxing'], years: 3, tier: 'bronze', sessionsTaught: 42, avatar: UNSPLASH[0], priceFrom: 220000, distanceKm: 5.6, bio: 'Boxing cơ bản + gym, buổi vui nhưng đúng kỹ thuật.' },
  { id: 'pt_08', name: 'Ngô Thanh Tâm', initials: 'NT', age: 31, area: 'Quận 2', lat: 10.787, lng: 106.749, specialties: ['Cải thiện sức khỏe', 'Phục hồi'], years: 6, tier: 'silver', sessionsTaught: 88, avatar: UNSPLASH[1], priceFrom: 300000, distanceKm: 6.2, bio: 'Phục hồi sau ngồi nhiều, mobility + sức bền.' },
  { id: 'pt_09', name: 'Bùi Nhật Minh', initials: 'BM', age: 24, area: 'Quận 4', lat: 10.764, lng: 106.7065, specialties: ['Người mới', 'Tăng cơ'], years: 2, tier: 'bronze', sessionsTaught: 28, avatar: UNSPLASH[2], priceFrom: 180000, distanceKm: 2.8, bio: 'PT mới, giá dễ, nhiệt tình chỉnh form.' },
  { id: 'pt_10', name: 'Trịnh Khánh Linh', initials: 'TL', age: 33, area: 'Quận 1', lat: 10.7758, lng: 106.7019, specialties: ['Giảm mỡ', 'Dinh dưỡng'], years: 10, tier: 'platinum', sessionsTaught: 260, avatar: UNSPLASH[3], priceFrom: 500000, distanceKm: 0.6, featured: true, bio: 'Kèm dinh dưỡng, học viên văn phòng giảm mỡ bền.' },
  { id: 'pt_11', name: 'Phan Đức Anh', initials: 'PA', age: 36, area: 'Bình Thạnh', lat: 10.7943, lng: 106.7218, specialties: ['Tăng sức bền', 'VĐV'], years: 12, tier: 'gold', sessionsTaught: 400, avatar: UNSPLASH[5], priceFrom: 420000, distanceKm: 3.8, bio: 'Cựu VĐV, giáo án chu kỳ rõ.' },
  { id: 'pt_12', name: 'Mai Phương Thảo', initials: 'MT', age: 25, area: 'Quận 5', lat: 10.7588, lng: 106.6821, specialties: ['Yoga', 'Cải thiện sức khỏe'], years: 3, tier: 'bronze', sessionsTaught: 36, avatar: UNSPLASH[6], priceFrom: 200000, distanceKm: 4.9, bio: 'Yoga + sức mạnh nhẹ, hợp người mới và nữ.' },
];

export function seedPts(now: number): PT[] {
  return RAW.map((r, i) => ({
    ...r,
    radiusKm: r.distanceKm < 3 ? 2.5 : r.distanceKm < 7 ? 4 : 6,
    certs: [
      { name: 'ACE Personal Trainer', photo: GYM_IMG[i % 6], status: 'approved' as const },
      { name: 'Dinh dưỡng thể thao', photo: GYM_IMG[(i + 1) % 6], status: i % 4 === 0 ? 'pending' : 'approved' },
    ],
    badge: r.tier === 'platinum' ? 'Top' : r.tier === 'gold' ? 'Gold' : r.tier === 'silver' ? 'Standard' : 'Entry',
    packages: pkgs(r.id, r.priceFrom),
    slots,
    gymIds: i % 2 === 0 ? ['gym_sys_01', 'gym_sys_02'] : ['gym_sys_03', 'gym_sys_04'],
    cover: GYM_IMG[i % 6],
    album: album(now, [r.avatar, GYM_IMG[i % 6], GYM_IMG[(i + 2) % 6], UNSPLASH[i % 8], GYM_IMG[(i + 4) % 6], UNSPLASH[(i + 3) % 8]]),
    fitFor: r.specialties,
    intro: r.bio,
    verified: true,
    onTimePct: 90 + (i % 8),
    completePct: 92 + (i % 6),
    trust: 78 + (i % 18),
    stars: 4.4 + (i % 6) * 0.1,
    reviewCount: 12 + i * 9,
    accepting: true,
    boosted: i === 4,
    studentResults: [
      {
        label: 'Minh (12 tuần)',
        summary: '−4.2 kg, tăng sức bền.',
        before: GYM_IMG[0],
        after: GYM_IMG[1],
      },
    ],
    approved: true,
  }));
}

export function seedGyms(): Gym[] {
  const base: Omit<Gym, 'photo' | 'priceFrom' | 'rating' | 'amenities' | 'hours' | 'memberships' | 'openNow' | 'linked' | 'featured'>[] = [
    { id: 'gym_sys_01', name: 'California Fitness Nguyễn Du', address: '117 Nguyễn Du, Q.1, TP.HCM', lat: 10.7758, lng: 106.7019 },
    { id: 'gym_col_01', name: 'Gym Xóm Chiếu', address: '12 Xóm Chiếu, Q.4, TP.HCM', lat: 10.764, lng: 106.7065 },
    { id: 'gym_sys_02', name: 'California Fitness Q.7', address: '209 Nguyễn Văn Linh, Q.7, TP.HCM', lat: 10.7328, lng: 106.7215 },
    { id: 'gym_col_02', name: 'Phòng tập Nguyễn Văn Cừ', address: '88 Nguyễn Văn Cừ, Q.5, TP.HCM', lat: 10.7588, lng: 106.6821 },
    { id: 'gym_sys_03', name: 'GetFit Phú Mỹ Hưng', address: 'S01 Sky Garden 1, Q.7, TP.HCM', lat: 10.7294, lng: 106.7218 },
    { id: 'gym_col_03', name: 'Gym nhà trọ Thủ Đức', address: '45 Võ Văn Ngân, Thủ Đức, TP.HCM', lat: 10.8494, lng: 106.7617 },
    { id: 'gym_sys_04', name: 'Elite Fitness Landmark 81', address: '720A Điện Biên Phủ, Bình Thạnh, TP.HCM', lat: 10.7943, lng: 106.7218 },
    { id: 'gym_col_04', name: 'Phòng tạ Bình Thạnh', address: '210 Nơ Trang Long, Bình Thạnh, TP.HCM', lat: 10.8016, lng: 106.7108 },
    { id: 'gym_sys_05', name: 'Citigym Hai Bà Trưng', address: '59-61 Hai Bà Trưng, Q.1, TP.HCM', lat: 10.7824, lng: 106.6951 },
    { id: 'gym_col_05', name: 'Gym 24h Tân Bình', address: '32 Hoàng Văn Thụ, Tân Bình, TP.HCM', lat: 10.8011, lng: 106.6525 },
  ];
  return base.map((g, i) => ({
    ...g,
    linked: g.id.startsWith('gym_sys'),
    featured: g.id === 'gym_sys_01',
    photo: GYM_IMG[i % 6],
    priceFrom: g.id.startsWith('gym_sys') ? 800000 : 350000,
    rating: 4.2 + (i % 7) * 0.1,
    amenities: ['Điều hoà', 'Tủ đồ', 'Tạ tự do', ...(i % 2 ? ['Hồ bơi'] : ['Lớp yoga'])],
    hours: '06:00–22:00',
    memberships: [
      { name: 'Tháng', priceVnd: g.id.startsWith('gym_sys') ? 800000 : 350000 },
      { name: 'Năm', priceVnd: g.id.startsWith('gym_sys') ? 7200000 : 3000000 },
    ],
    openNow: i !== 5,
  }));
}

export function seedSpas(): Spa[] {
  return [
    { id: 'spa_01', name: 'An Spa Thảo Điền', lat: 10.802, lng: 106.732, photo: UNSPLASH[4], services: [{ name: 'Massage 60′', priceVnd: 450000 }, { name: 'Chườm đá', priceVnd: 180000 }], rating: 4.7, hours: '10:00–21:00', offer: 'Giảm 20% buổi đầu', distanceKm: 3.4 },
    { id: 'spa_02', name: 'Reset Body Q.1', lat: 10.775, lng: 106.698, photo: UNSPLASH[7], services: [{ name: 'Recovery 45′', priceVnd: 390000 }], rating: 4.5, hours: '09:00–20:00', offer: 'Combo PT + spa', distanceKm: 0.9 },
    { id: 'spa_03', name: 'Yên Gym Spa Q.7', lat: 10.73, lng: 106.72, photo: UNSPLASH[0], services: [{ name: 'Sauna', priceVnd: 150000 }], rating: 4.3, hours: '08:00–22:00', offer: 'Đồng hành giảm mỡ', distanceKm: 4.8 },
    { id: 'spa_04', name: 'Sống Chậm Phú Mỹ Hưng', lat: 10.728, lng: 106.718, photo: UNSPLASH[1], services: [{ name: 'Massage chân', priceVnd: 220000 }], rating: 4.6, hours: '11:00–21:30', offer: 'Tặng 15 phút', distanceKm: 5.1 },
    { id: 'spa_05', name: 'Calm Studio Bình Thạnh', lat: 10.803, lng: 106.712, photo: UNSPLASH[2], services: [{ name: 'Stretching 40′', priceVnd: 280000 }], rating: 4.4, hours: '07:00–19:00', offer: 'Ưu đãi học viên PT', distanceKm: 2.4 },
  ];
}

export const ME = {
  name: 'Minh',
  age: 29,
  city: 'TP.HCM',
  goals: ['Giảm mỡ', 'Tăng sức bền'],
  height: 172,
  weight: 74.2,
};

export function seedWeights(now: number): WeightPoint[] {
  return Array.from({ length: 8 }, (_, i) => ({
    at: now - (7 - i) * 7 * 86400000,
    kg: 78.4 - i * 0.525,
  }));
}

export function seedContracts(now: number): Contract[] {
  return [
    {
      id: 'ct_active',
      kind: 'pt',
      ptId: 'pt_01',
      userName: 'Minh',
      packageName: '12 buổi',
      sessions: 12,
      done: 7,
      priceVnd: 3_444_000,
      perWeek: 3,
      status: 'active',
      createdAt: now - 50 * 86400000,
    },
    {
      id: 'ct_done',
      kind: 'pt',
      ptId: 'pt_02',
      userName: 'Minh',
      packageName: '8 buổi',
      sessions: 8,
      done: 8,
      priceVnd: 1_800_000,
      perWeek: 2,
      status: 'completed',
      createdAt: now - 180 * 86400000,
    },
    {
      id: 'ct_cancel',
      kind: 'pt',
      ptId: 'pt_04',
      userName: 'Minh',
      packageName: '5 buổi',
      sessions: 5,
      done: 1,
      priceVnd: 1_150_000,
      perWeek: 2,
      status: 'cancelled',
      createdAt: now - 90 * 86400000,
    },
  ];
}

export function seedSessions(now: number): Session[] {
  const start = now + 45 * 60000;
  const done: Session[] = Array.from({ length: 7 }, (_, i) => ({
    id: `ss_done_${i + 1}`,
    contractId: 'ct_active',
    ptId: 'pt_01',
    userName: 'Minh',
    index: i + 1,
    total: 12,
    startAt: now - (8 - i) * 4 * 86400000,
    durationMin: 60,
    locationLabel: 'California Fitness Nguyễn Du',
    gymId: 'gym_sys_01',
    status: 'completed',
    completedAt: now - (8 - i) * 4 * 86400000 + 3600000,
  }));
  return [
    ...done,
    {
      id: 'ss_today',
      contractId: 'ct_active',
      ptId: 'pt_01',
      userName: 'Minh',
      index: 8,
      total: 12,
      startAt: start,
      durationMin: 60,
      locationLabel: 'California Fitness Nguyễn Du',
      gymId: 'gym_sys_01',
      status: 'scheduled',
    },
  ];
}

export function seedReviews(now: number): Review[] {
  return [
    { id: 'rv1', ptId: 'pt_01', level: 'love', tags: ['Chuyên môn rất tốt', 'Rất tận tâm'], comment: 'Form chuẩn, buổi nào cũng rõ mục tiêu.', at: now - 9 * 86400000, reviewer: 'Hùng' },
    { id: 'rv2', ptId: 'pt_01', level: 'happy', tags: ['Đúng giờ', 'Hướng dẫn rõ'], comment: 'Ổn định, dễ theo.', at: now - 20 * 86400000, reviewer: 'Lan' },
    { id: 'rv3', ptId: 'pt_01', level: 'love', tags: ['Muốn tiếp tục tập'], comment: 'Sẽ gia hạn gói.', at: now - 40 * 86400000, reviewer: 'Phúc' },
  ];
}

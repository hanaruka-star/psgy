export type FeatureFlags = {
  ptAi: boolean;
  journal: boolean;
  packages: boolean;
  chat: boolean;
  gymFilter: boolean;
  studentResults: boolean;
  promoRibbon: boolean;
};

export const defaultFeatures: FeatureFlags = {
  ptAi: true,
  journal: true,
  packages: true,
  chat: true,
  gymFilter: true,
  studentResults: true,
  promoRibbon: true,
};

export const featureLabels: Record<keyof FeatureFlags, string> = {
  ptAi: 'PT AI',
  journal: 'Nhật ký + Cộng đồng',
  packages: 'Gói',
  chat: 'Chat',
  gymFilter: 'Lọc Coach / Phòng gym',
  studentResults: 'Kết quả học viên',
  promoRibbon: 'Ribbon khuyến mãi',
};

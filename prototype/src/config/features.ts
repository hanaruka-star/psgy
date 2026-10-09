export type FeatureFlags = {
  monetization: boolean;
  cameraAiPreview: boolean;
  spa: boolean;
  groupPackages: boolean;
  studentResults: boolean;
  aiAssistant: boolean;
};

export const defaultFeatures: FeatureFlags = {
  monetization: true,
  cameraAiPreview: false,
  spa: true,
  groupPackages: true,
  studentResults: true,
  aiAssistant: true,
};

export const featureLabels: Record<keyof FeatureFlags, string> = {
  monetization: 'Monetization (tài trợ / nổi bật / Boost)',
  cameraAiPreview: 'PT AI kịch bản cũ',
  spa: 'Spa trên bản đồ',
  groupPackages: 'Gói nhóm',
  studentResults: 'Kết quả học viên',
  aiAssistant: 'Trợ lý AI',
};

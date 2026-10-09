import type { PtTier } from '@/config/business';

export type Role = 'user' | 'pt';

export type NavEntry = { id: string; params?: Record<string, string> };

export type PhotoStatus = 'pending' | 'approved' | 'rejected' | 'expired';

export type AlbumPhoto = {
  id: string;
  url: string;
  uploadedAt: number;
  expiresAt: number;
  status: PhotoStatus;
};

export type PtPackage = {
  id: string;
  kind: 'personal' | 'group';
  name: string;
  sessions: number;
  priceVnd: number;
  perWeek: number;
  hidden?: boolean;
};

export type WeeklySlot = { weekday: number; start: string; end: string };

export type PT = {
  id: string;
  name: string;
  initials: string;
  age: number;
  area: string;
  lat: number;
  lng: number;
  radiusKm: number;
  specialties: string[];
  years: number;
  certs: { name: string; photo: string; status: PhotoStatus }[];
  tier: PtTier;
  badge: string;
  sessionsTaught: number;
  packages: PtPackage[];
  slots: WeeklySlot[];
  gymIds: string[];
  avatar: string;
  cover: string;
  album: AlbumPhoto[];
  bio: string;
  fitFor: string[];
  intro: string;
  verified: boolean;
  onTimePct: number;
  completePct: number;
  trust: number;
  stars: number;
  reviewCount: number;
  accepting: boolean;
  featured?: boolean;
  boosted?: boolean;
  distanceKm: number;
  priceFrom: number;
  studentResults: {
    label: string;
    summary: string;
    before: string;
    after: string;
  }[];
  approved: boolean;
};

export type Gym = {
  id: string;
  name: string;
  address: string;
  lat: number;
  lng: number;
  linked: boolean;
  featured?: boolean;
  photo: string;
  priceFrom: number;
  rating: number;
  amenities: string[];
  hours: string;
  memberships: { name: string; priceVnd: number }[];
  openNow: boolean;
};

export type Spa = {
  id: string;
  name: string;
  lat: number;
  lng: number;
  photo: string;
  services: { name: string; priceVnd: number }[];
  rating: number;
  hours: string;
  offer: string;
  distanceKm: number;
};

export type SessionStatus =
  | 'pendingConfirm'
  | 'scheduled'
  | 'training'
  | 'awaitingUserComplete'
  | 'completed'
  | 'cancelled'
  | 'rescheduled'
  | 'noShowUser'
  | 'noShowPt'
  | 'disputed';

export type Contract = {
  id: string;
  kind: 'pt' | 'gym';
  ptId: string;
  gymId?: string;
  userName: string;
  packageName: string;
  sessions: number;
  done: number;
  priceVnd: number;
  perWeek: number;
  status: 'active' | 'pending' | 'completed' | 'cancelled';
  createdAt: number;
};

export type Session = {
  id: string;
  contractId: string;
  ptId: string;
  userName: string;
  index: number;
  total: number;
  startAt: number;
  durationMin: number;
  locationLabel: string;
  gymId?: string;
  status: SessionStatus;
  note?: string;
  summary?: SessionSummary;
  lateMin?: number;
  startPhoto?: string;
  cancelBy?: Role;
  cancelReason?: string;
  refundPct?: number;
  proposedStartAt?: number;
  arrivedAt?: number;
  trainedAt?: number;
  completedAt?: number;
};

export type SessionSummary = {
  actualMin: number;
  muscles: string[];
  progress: 'up' | 'same' | 'try';
  nextNote: string;
  photo?: string;
};

export type ReviewLevel = 'unhappy' | 'happy' | 'love';

export type Review = {
  id: string;
  ptId: string;
  sessionId?: string;
  level: ReviewLevel;
  tags: string[];
  comment: string;
  at: number;
  reviewer: string;
};

export type WalletTx = {
  id: string;
  kind: 'topup' | 'pay' | 'refund';
  amount: number;
  note: string;
  at: number;
};

export type LedgerTx = {
  id: string;
  sessionId?: string;
  contractId?: string;
  userName: string;
  amount: number;
  fee: number;
  net: number;
  status: 'held' | 'processing' | 'withdrawable' | 'withdrawn' | 'refunded' | 'disputed';
  at: number;
  processingUntil?: number;
};

export type ChatCard =
  | { type: 'package'; packageId: string; label: string }
  | { type: 'schedule'; text: string }
  | { type: 'place'; text: string }
  | { type: 'booking'; sessionId: string }
  | { type: 'contract'; contractId: string }
  | { type: 'pay'; text: string }
  | { type: 'remind'; text: string };

export type ChatMsg = {
  id: string;
  threadId: string;
  from: 'user' | 'pt' | 'ai' | 'system';
  text?: string;
  card?: ChatCard;
  at: number;
};

export type Thread = {
  id: string;
  peerId: string;
  peerName: string;
  avatar: string;
  kind: 'pt' | 'ai' | 'gym';
  unread: number;
};

export type Greeting = {
  id: string;
  ptId: string;
  text: string;
  status: 'pending' | 'accepted' | 'skipped';
};

export type Noti = {
  id: string;
  role: Role;
  group: string;
  title: string;
  body: string;
  screen: string;
  params?: Record<string, string>;
  at: number;
  read: boolean;
};

export type PushToast = {
  id: string;
  role: Role;
  title: string;
  body: string;
  screen: string;
  params?: Record<string, string>;
};

export type WeightPoint = { at: number; kg: number };

export type Visit = { ptId: string; userId: string; userName: string; at: number };

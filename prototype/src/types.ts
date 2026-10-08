export type Role = 'user' | 'coach';

export type NavEntry = {
  id: string;
  params?: Record<string, string>;
};

export type BookingStatus =
  | 'pending'
  | 'confirmed'
  | 'inProgress'
  | 'awaitingUserConfirmation'
  | 'completed'
  | 'cancelled';

export type Booking = {
  id: string;
  userName: string;
  userAvatarInitials: string;
  serviceName: string;
  priceVnd: number;
  priceLabel: string;
  requestedTimeLabel: string;
  locationLabel: string;
  status: BookingStatus;
  statusLabel: string;
  cancelReason: string | null;
  paymentMethod: string;
  coachId: string;
  coachName: string;
};

export type Coach = {
  id: string;
  name: string;
  initials: string;
  avatarAsset: string;
  rating: number;
  yearsExperience: number;
  distanceKm: number;
  nextSlotLabel: string;
  lat: number;
  lng: number;
  bio: string;
  photoUrls: string[];
  totalBookings: number;
  goals: string[];
  targetAudience: string[];
  trainingFormats: string[];
  gymFeeIncluded: boolean;
  membershipFeeLabel: string | null;
  certifications: string[];
  certificationPhotos?: string[];
  bookingCancellationPolicy: string;
  services: {
    id: string;
    name: string;
    priceVnd: number;
    priceLabel: string;
    durationMinutes: number;
    promoLabel: string | null;
  }[];
  packages: {
    id: string;
    coachId: string;
    name: string;
    sessionCount: number;
    totalPriceVnd: number;
    priceLabel: string;
    description: string;
  }[];
  trainingLocations: { name: string; address: string; type: string }[];
  studentResults: {
    studentLabel: string;
    summary: string;
    beforeImageUrl: string;
    afterImageUrl: string;
    timeline: { dateLabel: string; note: string }[];
  }[];
  weeklyAvailability: {
    offsetDays: number;
    startTime: string;
    endTime: string;
    dateRule?: string;
  }[];
};

export type Gym = {
  id: string;
  name: string;
  address: string;
  lat: number;
  lng: number;
  gymSourceType: string;
};

export type Review = {
  id: string;
  coachId: string;
  reviewerName: string;
  rating: number;
  comment: string;
  date: string;
};

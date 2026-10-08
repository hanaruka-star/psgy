import coachesFile from '@/data/coaches.json';
import gymsFile from '@/data/gyms.json';
import reviewsFile from '@/data/reviews.json';
import privacyFile from '@/data/privacy.json';
import sessionFile from '@/data/coach_session.json';
import type { Coach, Gym, Review } from '@/types';

export const coaches = coachesFile.coaches as Coach[];
export const gyms = gymsFile as Gym[];
export const reviews = reviewsFile as Review[];
export const privacy = privacyFile;
export const coachSession = sessionFile;

export function coachById(id: string) {
  return coaches.find((c) => c.id === id) ?? coaches[0];
}

export function reviewsFor(coachId: string) {
  return reviews.filter((r) => r.coachId === coachId);
}

export function gymById(id: string) {
  return gyms.find((g) => g.id === id);
}

const VN_DAYS = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'] as const;

export function addDays(offset: number) {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() + offset);
  return d;
}

export function vnWeekday(offset: number) {
  return VN_DAYS[addDays(offset).getDay()];
}

export function formatReviewDate(iso: string) {
  const d = new Date(iso);
  const dd = String(d.getDate()).padStart(2, '0');
  const mm = String(d.getMonth() + 1).padStart(2, '0');
  return `${dd}/${mm}/${d.getFullYear()}`;
}

export const tagStyle: Record<string, { bg: string; fg: string }> = {
  'Tăng cơ': { bg: 'var(--success-container)', fg: 'var(--success-on)' },
  'Giảm mỡ': { bg: 'var(--warning-container)', fg: 'var(--warning-on)' },
  'Tăng sức bền': {
    bg: 'var(--primary-container)',
    fg: 'var(--on-primary-container)',
  },
  'Phục hồi sau chấn thương': {
    bg: 'var(--tertiary-container)',
    fg: 'var(--on-tertiary-container)',
  },
  Nam: { bg: 'var(--secondary-container)', fg: 'var(--on-secondary-container)' },
  Nữ: { bg: 'var(--sheet)', fg: 'var(--sheet-title)' },
  VĐV: {
    bg: 'color-mix(in srgb, var(--highlight) 18%, transparent)',
    fg: 'var(--highlight)',
  },
  'Người mới bắt đầu': {
    bg: 'color-mix(in srgb, var(--tab-active) 16%, transparent)',
    fg: 'var(--tab-active)',
  },
  'Phục hồi chấn thương': {
    bg: 'color-mix(in srgb, var(--danger-container) 85%, transparent)',
    fg: 'var(--danger-on)',
  },
};

export function statusChip(status: string) {
  if (status === 'pending' || status === 'awaitingUserConfirmation') {
    return { bg: 'var(--warning-container)', fg: 'var(--warning-on)' };
  }
  if (status === 'inProgress' || status === 'completed' || status === 'confirmed') {
    return { bg: 'var(--success-container)', fg: 'var(--success-on)' };
  }
  if (status === 'cancelled') {
    return { bg: 'var(--danger-container)', fg: 'var(--danger-on)' };
  }
  return { bg: 'var(--tag)', fg: 'var(--on-surface-variant)' };
}

export function mapsDirUrl(lat: number, lng: number) {
  return `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`;
}

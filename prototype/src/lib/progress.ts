import type { Session, Visit } from '@/domain/types';

export function completedCount(sessions: Session[], contractId: string) {
  return sessions.filter((s) => s.contractId === contractId && s.status === 'completed').length;
}

export function interestedLeads(visits: Visit[], ptId: string, min: number, days: number, now: number) {
  const cutoff = now - days * 86400000;
  const map = new Map<string, { userId: string; userName: string; times: number; lastAt: number }>();
  for (const v of visits) {
    if (v.ptId !== ptId || v.at < cutoff) continue;
    const cur = map.get(v.userId) ?? { userId: v.userId, userName: v.userName, times: 0, lastAt: 0 };
    cur.times += 1;
    cur.lastAt = Math.max(cur.lastAt, v.at);
    map.set(v.userId, cur);
  }
  return [...map.values()].filter((x) => x.times >= min).sort((a, b) => b.lastAt - a.lastAt);
}

export function deltaPct(curr: number, prev: number) {
  if (!prev) return { pct: 0, up: curr >= prev };
  const pct = Math.round(((curr - prev) / prev) * 100);
  return { pct, up: pct >= 0 };
}

export const PROGRESS_LABEL = {
  up: 'Tốt hơn buổi trước',
  same: 'Như cũ',
  try: 'Cần cố gắng',
} as const;

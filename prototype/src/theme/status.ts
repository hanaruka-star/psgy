export type StatusTone = 'pending' | 'live' | 'done' | 'cancel' | 'alert';

export function sessionTone(status: string): StatusTone {
  if (status === 'pendingConfirm' || status === 'pending' || status === 'awaitingUserComplete') return 'pending';
  if (status === 'scheduled' || status === 'training' || status === 'upcoming' || status === 'due' || status === 'active') {
    return 'live';
  }
  if (status === 'completed') return 'done';
  if (status === 'cancelled' || status === 'rescheduled') return 'cancel';
  if (status === 'noShowUser' || status === 'noShowPt' || status === 'disputed') return 'alert';
  return 'live';
}

export function statusVars(tone: StatusTone): { bg: string; fg: string } {
  if (tone === 'pending') return { bg: 'var(--warning-container)', fg: 'var(--warning-on)' };
  if (tone === 'live') return { bg: 'var(--brand-soft)', fg: 'var(--brand-text)' };
  if (tone === 'done') return { bg: 'var(--success-container)', fg: 'var(--success-on)' };
  if (tone === 'cancel') return { bg: 'var(--tag)', fg: 'var(--on-surface-variant)' };
  return { bg: 'var(--danger-container)', fg: 'var(--danger-on)' };
}

export function sessionChipStyle(status: string) {
  return statusVars(sessionTone(status));
}

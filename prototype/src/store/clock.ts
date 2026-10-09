export type ClockJump =
  | 'plus15'
  | 'plus60'
  | 'remain60'
  | 'atTime'
  | 'plus15after'
  | 'late8'
  | 'plus24h'
  | 'plus3d'
  | 'real';

export function applyJump(now: number, realNow: number, targetStart: number | null, jump: ClockJump): number {
  switch (jump) {
    case 'plus15':
      return now + 15 * 60000;
    case 'plus60':
      return now + 60 * 60000;
    case 'remain60':
      return targetStart ? targetStart - 60 * 60000 : now;
    case 'atTime':
      return targetStart ?? now;
    case 'plus15after':
      return (targetStart ?? now) + 15 * 60000;
    case 'late8':
      return (targetStart ?? now) + 8 * 60000;
    case 'plus24h':
      return now + 24 * 3600000;
    case 'plus3d':
      return now + 3 * 86400000;
    case 'real':
      return realNow;
  }
}

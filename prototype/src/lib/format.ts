export function vnd(n: number) {
  return `${Math.round(n).toLocaleString('vi-VN')}đ`;
}

export function pad(n: number) {
  return String(n).padStart(2, '0');
}

export function atDay(ms: number) {
  const d = new Date(ms);
  return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}`;
}

export function atTime(ms: number) {
  const d = new Date(ms);
  return `${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

export function atFull(ms: number) {
  const d = new Date(ms);
  const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
  return `${days[d.getDay()]} ${atDay(ms)} · ${atTime(ms)}`;
}

export function minutesBetween(a: number, b: number) {
  return Math.round((b - a) / 60000);
}

export function hoursBetween(a: number, b: number) {
  return (b - a) / 3600000;
}

export function uid(prefix: string) {
  return `${prefix}_${Math.random().toString(36).slice(2, 8)}${Date.now().toString(36).slice(-4)}`;
}

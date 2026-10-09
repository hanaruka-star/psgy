export type StyleId = 'fresh' | 'soft' | 'night';
export type ModeId = 'light' | 'dark';

export const styles: { id: StyleId; label: string; hint: string }[] = [
  { id: 'fresh', label: 'A. Teal tươi', hint: 'Nền trắng, nút teal đậm' },
  { id: 'soft', label: 'B. Teal mềm', hint: 'Nền mint, bo góc lớn' },
  { id: 'night', label: 'C. Teal tối', hint: 'Nền rừng đêm' },
];

export function modeForStyle(style: StyleId): ModeId {
  return style === 'night' ? 'dark' : 'light';
}

export function applyTheme(style: StyleId, mode: ModeId) {
  const root = document.documentElement;
  root.dataset.style = style;
  root.dataset.mode = mode;
  const themeMeta = document.querySelector('meta[name="theme-color"]');
  if (themeMeta) {
    themeMeta.setAttribute('content', style === 'night' ? '#0B1412' : '#0B4F43');
  }
}

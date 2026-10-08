export type StyleId = 'minimal' | 'dark' | 'glass' | 'neumorph';
export type ModeId = 'light' | 'dark';

export const styles: { id: StyleId; label: string }[] = [
  { id: 'minimal', label: 'Minimal (hiện tại)' },
  { id: 'dark', label: 'Dark' },
  { id: 'glass', label: 'Glass' },
  { id: 'neumorph', label: 'Neumorph' },
];

export function applyTheme(style: StyleId, mode: ModeId) {
  const root = document.documentElement;
  root.dataset.style = style;
  root.dataset.mode = mode;
  const darkChrome = style === 'dark' || mode === 'dark';
  const themeMeta = document.querySelector('meta[name="theme-color"]');
  if (themeMeta) {
    themeMeta.setAttribute('content', darkChrome ? '#121212' : '#00A0E0');
  }
}

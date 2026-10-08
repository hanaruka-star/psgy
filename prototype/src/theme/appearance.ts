import type { ModeId, StyleId } from './presets';
import projectOverrides from './overrides.json' with { type: 'json' };

export type FontId =
  | 'system'
  | 'inter'
  | 'beVietnamPro'
  | 'nunito'
  | 'montserrat'
  | 'lexend'
  | 'roboto';

export type TypeLevelId = 'display' | 'title' | 'subtitle' | 'body' | 'caption';

export type TypeLevel = { size: number; weight: number };

export type AppearanceColors = {
  onSurface: string;
  onSurfaceVariant: string;
  onPrimary: string;
  primaryText: string;
  primary: string;
  highlight: string;
  bg: string;
  card: string;
  tag: string;
  tabActive: string;
  tabInactive: string;
  navBar: string;
  fab: string;
};

export type TabLayout = 'raised' | 'flat';
export type TabLabelMode = 'iconText' | 'iconOnly';
export type NavBg = 'solid' | 'glass' | 'transparent';

export type TabAppearance = {
  layout: TabLayout;
  label: TabLabelMode;
  navBg: NavBg;
  height: number;
  iconSize: number;
  fabIcon: string;
  order: string[];
};

export type AppearanceSlice = {
  font: FontId;
  fontScale: number;
  type: Record<TypeLevelId, TypeLevel>;
  colors: AppearanceColors;
  radiusScale: number;
  tab: TabAppearance;
};

export type AppearanceSlices = Record<StyleId, Record<ModeId, AppearanceSlice>>;

export const TYPE_LEVELS: { id: TypeLevelId; label: string }[] = [
  { id: 'display', label: 'Tiêu đề lớn' },
  { id: 'title', label: 'Tiêu đề' },
  { id: 'subtitle', label: 'Tiêu đề nhỏ' },
  { id: 'body', label: 'Nội dung' },
  { id: 'caption', label: 'Chú thích' },
];

export const FONT_OPTIONS: {
  id: FontId;
  label: string;
  license: string;
  vietnamese: boolean;
  stack: string;
}[] = [
  {
    id: 'system',
    label: 'Font hệ thống iOS',
    license: 'Hệ thống (không đóng gói SF Pro)',
    vietnamese: true,
    stack: '-apple-system, BlinkMacSystemFont, system-ui, sans-serif',
  },
  {
    id: 'inter',
    label: 'Inter',
    license: 'OFL-1.1',
    vietnamese: true,
    stack: '"Inter", ui-sans-serif, system-ui, sans-serif',
  },
  {
    id: 'beVietnamPro',
    label: 'Be Vietnam Pro',
    license: 'OFL-1.1',
    vietnamese: true,
    stack: '"Be Vietnam Pro", ui-sans-serif, system-ui, sans-serif',
  },
  {
    id: 'nunito',
    label: 'Nunito',
    license: 'OFL-1.1',
    vietnamese: true,
    stack: '"Nunito", ui-sans-serif, system-ui, sans-serif',
  },
  {
    id: 'montserrat',
    label: 'Montserrat',
    license: 'OFL-1.1',
    vietnamese: true,
    stack: '"Montserrat", ui-sans-serif, system-ui, sans-serif',
  },
  {
    id: 'lexend',
    label: 'Lexend',
    license: 'OFL-1.1',
    vietnamese: true,
    stack: '"Lexend", ui-sans-serif, system-ui, sans-serif',
  },
  {
    id: 'roboto',
    label: 'Roboto',
    license: 'Apache-2.0',
    vietnamese: true,
    stack: '"Roboto", ui-sans-serif, system-ui, sans-serif',
  },
];

export const TAB_SLOTS: { id: string; label: string }[] = [
  { id: 'U07', label: 'Bản đồ' },
  { id: 'U14', label: 'Nhật ký' },
  { id: 'U19', label: 'PT AI' },
  { id: 'U15', label: 'Cộng đồng' },
  { id: 'U13', label: 'Lịch sử' },
];

export const FAB_ICONS = [
  'smart_toy',
  'fitness_center',
  'bolt',
  'auto_awesome',
  'sports_gymnastics',
  'psychology',
] as const;

export const DEFAULT_TAB_ORDER = TAB_SLOTS.map((t) => t.id);

const TYPE_DEFAULT: AppearanceSlice['type'] = {
  display: { size: 24, weight: 700 },
  title: { size: 20, weight: 700 },
  subtitle: { size: 16, weight: 600 },
  body: { size: 14, weight: 400 },
  caption: { size: 12, weight: 400 },
};

const TAB_DEFAULT: TabAppearance = {
  layout: 'raised',
  label: 'iconText',
  navBg: 'solid',
  height: 64,
  iconSize: 24,
  fabIcon: 'smart_toy',
  order: [...DEFAULT_TAB_ORDER],
};

const LIGHT_COLORS: AppearanceColors = {
  onSurface: '#181c20',
  onSurfaceVariant: '#41484d',
  onPrimary: '#0a2540',
  primaryText: '#0077a8',
  primary: '#00a0e0',
  highlight: '#346b34',
  bg: '#f8fafc',
  card: '#eff3fa',
  tag: '#eff3fa',
  tabActive: '#275f95',
  tabInactive: '#94a3b8',
  navBar: '#ffffff',
  fab: '#346b34',
};

const DARK_COLORS: AppearanceColors = {
  onSurface: '#e5e1e9',
  onSurfaceVariant: '#c8c5d0',
  onPrimary: '#1a1840',
  primaryText: '#c3c1ff',
  primary: '#9290fa',
  highlight: '#7bc17b',
  bg: '#0f172a',
  card: '#36363b',
  tag: '#2f2f34',
  tabActive: '#7baee0',
  tabInactive: '#94a3b8',
  navBar: '#1b1b21',
  fab: '#7bc17b',
};

function slice(colors: AppearanceColors, extra?: Partial<AppearanceSlice>): AppearanceSlice {
  return {
    font: 'inter',
    fontScale: 1,
    type: structuredClone(TYPE_DEFAULT),
    colors: { ...colors },
    radiusScale: 1,
    tab: { ...TAB_DEFAULT, order: [...DEFAULT_TAB_ORDER] },
    ...extra,
  };
}

export function codeDefaults(): AppearanceSlices {
  return {
    minimal: {
      light: slice(LIGHT_COLORS),
      dark: slice(DARK_COLORS),
    },
    dark: {
      light: slice({
        ...DARK_COLORS,
        bg: '#121212',
        card: '#1e1e1e',
        tag: '#2a2a2a',
        navBar: '#1e1e1e',
        onSurface: '#f2f2f2',
      }),
      dark: slice({
        ...DARK_COLORS,
        bg: '#121212',
        card: '#1e1e1e',
        tag: '#2a2a2a',
        navBar: '#1e1e1e',
        onSurface: '#f2f2f2',
      }),
    },
    glass: {
      light: slice(
        {
          ...LIGHT_COLORS,
          bg: '#d4e8f5',
          card: '#e8f4fa',
          tag: '#dceef5',
          navBar: '#e4f3f8',
        },
        { radiusScale: 1.875 },
      ),
      dark: slice(
        {
          ...DARK_COLORS,
          bg: '#1a2040',
          card: '#2a2a48',
          tag: '#243050',
          navBar: '#222848',
        },
        { radiusScale: 1.875 },
      ),
    },
    neumorph: {
      light: slice(
        {
          ...LIGHT_COLORS,
          bg: '#e0e5ec',
          card: '#e0e5ec',
          tag: '#d5dae2',
          navBar: '#e0e5ec',
        },
        { radiusScale: 1.5 },
      ),
      dark: slice(
        {
          ...DARK_COLORS,
          bg: '#121212',
          card: '#1e1e1e',
          navBar: '#1e1e1e',
        },
        { radiusScale: 1.5 },
      ),
    },
  };
}

function isObj(v: unknown): v is Record<string, unknown> {
  return Boolean(v) && typeof v === 'object' && !Array.isArray(v);
}

function mergeDeep<T>(base: T, over: unknown): T {
  if (!isObj(over)) return structuredClone(base);
  if (Array.isArray(base)) return (over as T) ?? structuredClone(base);
  if (!isObj(base)) return (over as T) ?? structuredClone(base);
  const out: Record<string, unknown> = { ...(base as Record<string, unknown>) };
  for (const [k, v] of Object.entries(over)) {
    const cur = out[k];
    out[k] = isObj(cur) && isObj(v) && !Array.isArray(cur) ? mergeDeep(cur, v) : v;
  }
  return out as T;
}

export function resolvedDefaults(): AppearanceSlices {
  return mergeDeep(codeDefaults(), projectOverrides);
}

export function cloneSlices(s: AppearanceSlices): AppearanceSlices {
  return structuredClone(s);
}

export function parseHex(input: string): { r: number; g: number; b: number } | null {
  let h = input.trim().replace('#', '');
  if (h.length === 3) h = h.split('').map((c) => c + c).join('');
  if (!/^[0-9a-fA-F]{6}$/.test(h)) return null;
  return {
    r: parseInt(h.slice(0, 2), 16),
    g: parseInt(h.slice(2, 4), 16),
    b: parseInt(h.slice(4, 6), 16),
  };
}

function channel(c: number) {
  const s = c / 255;
  return s <= 0.03928 ? s / 12.92 : ((s + 0.055) / 1.055) ** 2.4;
}

export function contrastRatio(a: string, b: string): number | null {
  const A = parseHex(a);
  const B = parseHex(b);
  if (!A || !B) return null;
  const L1 = 0.2126 * channel(A.r) + 0.7152 * channel(A.g) + 0.0722 * channel(A.b);
  const L2 = 0.2126 * channel(B.r) + 0.7152 * channel(B.g) + 0.0722 * channel(B.b);
  const [hi, lo] = L1 > L2 ? [L1, L2] : [L2, L1];
  return (hi + 0.05) / (lo + 0.05);
}

export function formatContrast(ratio: number | null): string {
  if (ratio == null) return '—';
  return `${ratio.toFixed(1)}:1`;
}

export type ContrastPair = {
  key: keyof AppearanceColors;
  label: string;
  fg: string;
  bg: string;
};

export function contrastPairs(c: AppearanceColors): ContrastPair[] {
  return [
    { key: 'onSurface', label: 'Chữ chính', fg: c.onSurface, bg: c.bg },
    { key: 'onSurfaceVariant', label: 'Chữ phụ', fg: c.onSurfaceVariant, bg: c.bg },
    { key: 'onPrimary', label: 'Chữ trên nút chính', fg: c.onPrimary, bg: c.primary },
    { key: 'primaryText', label: 'Link', fg: c.primaryText, bg: c.bg },
  ];
}

export function applyAppearance(slice: AppearanceSlice) {
  const root = document.documentElement;
  const font = FONT_OPTIONS.find((f) => f.id === slice.font) ?? FONT_OPTIONS[1];
  root.style.setProperty('--font', font.stack);
  root.style.setProperty('--font-scale', String(slice.fontScale));
  const scaled = (px: number) => `${+(px * slice.fontScale).toFixed(2)}px`;
  (Object.keys(slice.type) as TypeLevelId[]).forEach((id) => {
    root.style.setProperty(`--text-${id}`, scaled(slice.type[id].size));
    root.style.setProperty(`--text-${id}-weight`, String(slice.type[id].weight));
  });
  const c = slice.colors;
  root.style.setProperty('--on-surface', c.onSurface);
  root.style.setProperty('--on-surface-variant', c.onSurfaceVariant);
  root.style.setProperty('--on-primary', c.onPrimary);
  root.style.setProperty('--primary-text', c.primaryText);
  root.style.setProperty('--primary', c.primary);
  root.style.setProperty('--highlight', c.highlight);
  root.style.setProperty('--bg', c.bg);
  root.style.setProperty('--card', c.card);
  root.style.setProperty('--tag', c.tag);
  root.style.setProperty('--tab-active', c.tabActive);
  root.style.setProperty('--tab-inactive', c.tabInactive);
  root.style.setProperty('--nav-bar', c.navBar);
  root.style.setProperty('--fab', c.fab);
  root.style.setProperty('--radius-scale', String(slice.radiusScale));
  root.style.setProperty('--radius-sm', `${+(12 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-md', `${+(16 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-lg', `${+(24 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-xl', `${+(28 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-card', `${+(16 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--nav-height', `${slice.tab.height}px`);
  root.style.setProperty('--nav-icon', `${slice.tab.iconSize}px`);
  root.style.setProperty('--fab-size', '60px');
  const lift = slice.tab.layout === 'raised' ? 16 : 0;
  root.style.setProperty('--fab-lift', `${lift}px`);
  root.style.setProperty(
    '--nav-pad-bottom',
    `calc(${slice.tab.height}px + ${lift}px + env(safe-area-inset-bottom, 0px))`,
  );
  root.dataset.tabLayout = slice.tab.layout;
  root.dataset.tabLabel = slice.tab.label;
  root.dataset.navBg = slice.tab.navBg;
}

export function generateDesignTokensMarkdown(slices: AppearanceSlices): string {
  const styles: StyleId[] = ['minimal', 'dark', 'glass', 'neumorph'];
  const modes: ModeId[] = ['light', 'dark'];
  const lines: string[] = [
    '# Design tokens — bản Ruka chốt',
    '',
    'Sinh từ bảng **Giao diện** của prototype. Đội dev dùng bảng này khi dựng app thật.',
    '',
    `Ngày xuất: ${new Date().toISOString().slice(0, 10)}`,
    '',
  ];
  for (const style of styles) {
    for (const mode of modes) {
      const s = slices[style][mode];
      const font = FONT_OPTIONS.find((f) => f.id === s.font);
      lines.push(`## ${style} × ${mode === 'light' ? 'sáng' : 'tối'}`, '');
      lines.push('| Token | Giá trị |', '|---|---|');
      lines.push(`| Font | ${font?.label ?? s.font} (${font?.license ?? ''}) |`);
      lines.push(`| Font stack | \`${font?.stack ?? ''}\` |`);
      lines.push(`| Cỡ chữ toàn app | ${Math.round(s.fontScale * 100)}% |`);
      for (const lv of TYPE_LEVELS) {
        const t = s.type[lv.id];
        lines.push(
          `| ${lv.label} | ${t.size}px × ${s.fontScale} = ${(t.size * s.fontScale).toFixed(1)}px / weight ${t.weight} |`,
        );
      }
      lines.push(`| Chữ chính | ${s.colors.onSurface} |`);
      lines.push(`| Chữ phụ | ${s.colors.onSurfaceVariant} |`);
      lines.push(`| Chữ trên nút chính | ${s.colors.onPrimary} |`);
      lines.push(`| Link | ${s.colors.primaryText} |`);
      lines.push(`| Màu chính | ${s.colors.primary} |`);
      lines.push(`| Highlight | ${s.colors.highlight} |`);
      lines.push(`| Nền app | ${s.colors.bg} |`);
      lines.push(`| Nền card | ${s.colors.card} |`);
      lines.push(`| Nền tag | ${s.colors.tag} |`);
      lines.push(`| Tab đang chọn | ${s.colors.tabActive} |`);
      lines.push(`| Tab không chọn | ${s.colors.tabInactive} |`);
      lines.push(`| Nền thanh | ${s.colors.navBar} |`);
      lines.push(`| Nút giữa | ${s.colors.fab} |`);
      lines.push(`| Radius scale | ${s.radiusScale} |`);
      lines.push(`| Bottom tab kiểu | ${s.tab.layout} / ${s.tab.label} / ${s.tab.navBg} |`);
      lines.push(`| Chiều cao thanh | ${s.tab.height}px |`);
      lines.push(`| Cỡ icon | ${s.tab.iconSize}px |`);
      lines.push(`| Icon nút giữa | ${s.tab.fabIcon} |`);
      lines.push(`| Thứ tự tab | ${s.tab.order.join(' → ')} |`);
      lines.push('');
    }
  }
  return lines.join('\n');
}

import type { ModeId, StyleId } from './presets';
import { styles as styleList } from './presets';
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

/** Vai trò màu mục 1 sitemap 3C — đổi 1 biến, cả 2 app đổi. */
export type AppearanceColors = {
  brand: string;
  brandStrong: string;
  brandText: string;
  brandSoft: string;
  bg: string;
  card: string;
  text: string;
  text2: string;
  border: string;
  warning: string;
  danger: string;
  success: string;
  onPrimary: string;
  tabActive: string;
  tabInactive: string;
  navBar: string;
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
  shadowStrength: number;
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
  { id: 'UD1', label: 'Discovery' },
  { id: 'UM1', label: 'Map' },
  { id: 'UC1', label: 'Chat' },
  { id: 'UCA1', label: 'Camera AI' },
  { id: 'UPF1', label: 'Profile' },
];

export const FAB_ICONS = [
  'photo_camera',
  'fitness_center',
  'bolt',
  'auto_awesome',
  'map',
  'chat',
] as const;

export const DEFAULT_TAB_ORDER = TAB_SLOTS.map((t) => t.id);

export const COLOR_ROLES: { key: keyof AppearanceColors; label: string }[] = [
  { key: 'brand', label: 'Brand (teal tươi)' },
  { key: 'brandStrong', label: 'Nút chính (teal đậm)' },
  { key: 'brandText', label: 'Chữ thương hiệu / link' },
  { key: 'brandSoft', label: 'Nền tag / chip' },
  { key: 'bg', label: 'Nền app' },
  { key: 'card', label: 'Nền thẻ' },
  { key: 'text', label: 'Chữ chính' },
  { key: 'text2', label: 'Chữ phụ' },
  { key: 'border', label: 'Viền' },
  { key: 'warning', label: 'Cảnh báo / chờ' },
  { key: 'danger', label: 'Huỷ / tranh chấp' },
  { key: 'success', label: 'Hoàn thành' },
  { key: 'onPrimary', label: 'Chữ trên nút chính' },
  { key: 'tabActive', label: 'Tab đang chọn' },
  { key: 'tabInactive', label: 'Tab không chọn' },
  { key: 'navBar', label: 'Nền bottom tab' },
];

export const TIER_COLORS = {
  bronze: '#B87333',
  silver: '#94A3B8',
  gold: '#D4A017',
  platinum: '#5B8DB8',
} as const;

const TYPE_DEFAULT: AppearanceSlice['type'] = {
  display: { size: 24, weight: 700 },
  title: { size: 20, weight: 700 },
  subtitle: { size: 16, weight: 600 },
  body: { size: 14, weight: 400 },
  caption: { size: 12, weight: 400 },
};

const TAB_DEFAULT: TabAppearance = {
  layout: 'flat',
  label: 'iconText',
  navBg: 'solid',
  height: 64,
  iconSize: 24,
  fabIcon: 'photo_camera',
  order: [...DEFAULT_TAB_ORDER],
};

/** #64748B trên #F5F8F7 = 4.45:1 — đẩy xuống #5B677A (5.36:1). */
const TEXT2_LIGHT = '#5B677A';

const FRESH: AppearanceColors = {
  brand: '#0E9F87',
  brandStrong: '#0B4F43',
  brandText: '#0B7A68',
  brandSoft: '#E6F6F2',
  bg: '#F5F8F7',
  card: '#FFFFFF',
  text: '#0F172A',
  text2: TEXT2_LIGHT,
  border: '#E2E8F0',
  warning: '#F59E0B',
  danger: '#E5484D',
  success: '#16A34A',
  onPrimary: '#FFFFFF',
  /** #0E9F87 trên trắng = 3.32:1 — tab chữ dùng brand-text. */
  tabActive: '#0B7A68',
  tabInactive: TEXT2_LIGHT,
  navBar: '#FFFFFF',
};

const SOFT: AppearanceColors = {
  ...FRESH,
  bg: '#F0FAF7',
  brandSoft: '#DDF4EE',
  brandStrong: '#0E9F87',
  onPrimary: '#0F172A',
  tabActive: '#0B7A68',
};

const NIGHT: AppearanceColors = {
  brand: '#2EC4A6',
  brandStrong: '#2EC4A6',
  brandText: '#7DDEC8',
  brandSoft: '#1A2E29',
  bg: '#0B1412',
  card: '#13201D',
  text: '#E6F2EF',
  text2: '#94A3B8',
  border: '#243833',
  warning: '#FBBF24',
  danger: '#F87171',
  success: '#4ADE80',
  onPrimary: '#04211B',
  tabActive: '#2EC4A6',
  tabInactive: '#94A3B8',
  navBar: '#13201D',
};

function slice(colors: AppearanceColors, extra?: Partial<AppearanceSlice>): AppearanceSlice {
  return {
    font: 'inter',
    fontScale: 1,
    type: structuredClone(TYPE_DEFAULT),
    colors: { ...colors },
    radiusScale: 1,
    shadowStrength: 1,
    tab: { ...TAB_DEFAULT, order: [...DEFAULT_TAB_ORDER] },
    ...extra,
  };
}

export function codeDefaults(): AppearanceSlices {
  const fresh = slice(FRESH);
  const soft = slice(SOFT, { radiusScale: 1.4, shadowStrength: 0.7 });
  const night = slice(NIGHT, { shadowStrength: 0.4 });
  return {
    fresh: { light: fresh, dark: slice(NIGHT) },
    soft: { light: soft, dark: slice({ ...NIGHT, bg: '#0C1815', card: '#15241F' }) },
    night: { light: slice(FRESH), dark: night },
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
    { key: 'text', label: 'Chữ chính / nền', fg: c.text, bg: c.bg },
    { key: 'text2', label: 'Chữ phụ / nền', fg: c.text2, bg: c.bg },
    { key: 'text', label: 'Chữ chính / thẻ', fg: c.text, bg: c.card },
    { key: 'onPrimary', label: 'Chữ / nút chính', fg: c.onPrimary, bg: c.brandStrong },
    { key: 'brandText', label: 'Link / nền', fg: c.brandText, bg: c.bg },
    { key: 'brandText', label: 'Link / thẻ', fg: c.brandText, bg: c.card },
    { key: 'tabActive', label: 'Tab đang chọn / nền tab', fg: c.tabActive, bg: c.navBar },
    { key: 'onPrimary', label: 'Chữ trắng / brand tươi (không dùng)', fg: '#FFFFFF', bg: c.brand },
  ];
}

export function roleContrastPair(
  key: keyof AppearanceColors,
  c: AppearanceColors,
): { fg: string; bg: string } | null {
  switch (key) {
    case 'text':
    case 'bg':
      return { fg: c.text, bg: c.bg };
    case 'text2':
      return { fg: c.text2, bg: c.bg };
    case 'card':
    case 'border':
      return { fg: c.text, bg: key === 'card' ? c.card : c.border };
    case 'brandText':
      return { fg: c.brandText, bg: c.bg };
    case 'brandSoft':
      return { fg: c.brandText, bg: c.brandSoft };
    case 'brandStrong':
    case 'onPrimary':
      return { fg: c.onPrimary, bg: c.brandStrong };
    case 'brand':
      return { fg: c.brand, bg: c.bg };
    case 'tabActive':
      return { fg: c.tabActive, bg: c.navBar };
    case 'tabInactive':
      return { fg: c.tabInactive, bg: c.navBar };
    case 'navBar':
      return { fg: c.text, bg: c.navBar };
    case 'warning':
      return { fg: c.text, bg: c.warning };
    case 'danger':
      return { fg: c.text, bg: c.danger };
    case 'success':
      return { fg: c.text, bg: c.success };
    default:
      return null;
  }
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
  root.style.setProperty('--brand', c.brand);
  root.style.setProperty('--brand-strong', c.brandStrong);
  root.style.setProperty('--brand-text', c.brandText);
  root.style.setProperty('--brand-soft', c.brandSoft);
  root.style.setProperty('--primary', c.brandStrong);
  root.style.setProperty('--on-primary', c.onPrimary);
  root.style.setProperty('--primary-text', c.brandText);
  root.style.setProperty('--on-surface', c.text);
  root.style.setProperty('--on-surface-variant', c.text2);
  root.style.setProperty('--bg', c.bg);
  root.style.setProperty('--card', c.card);
  root.style.setProperty('--tag', c.brandSoft);
  root.style.setProperty('--primary-container', c.brandSoft);
  root.style.setProperty('--on-primary-container', c.brandText);
  root.style.setProperty('--outline-variant', c.border);
  root.style.setProperty('--outline', c.text2);
  root.style.setProperty('--warning', c.warning);
  root.style.setProperty('--danger', c.danger);
  root.style.setProperty('--success', c.success);
  root.style.setProperty('--highlight', c.success);
  root.style.setProperty('--on-highlight', c.card);
  root.style.setProperty('--tab-active', c.tabActive);
  root.style.setProperty('--tab-inactive', c.tabInactive);
  root.style.setProperty('--nav-bar', c.navBar);
  root.style.setProperty('--fab', c.brand);
  root.style.setProperty('--surface', c.bg);
  root.style.setProperty('--status-bar', c.bg);
  root.style.setProperty('--sheet', c.card);
  root.style.setProperty('--sheet-title', c.text);
  root.style.setProperty('--header-bg', c.brandStrong);
  root.style.setProperty('--header-fg', c.onPrimary);
  root.style.setProperty('--label-sponsored-bg', c.border);
  root.style.setProperty('--label-sponsored-fg', c.text2);
  root.style.setProperty('--label-featured-bg', `color-mix(in srgb, ${c.warning} 22%, ${c.card})`);
  const cardLum = (() => {
    const p = parseHex(c.card);
    if (!p) return 1;
    return 0.2126 * channel(p.r) + 0.7152 * channel(p.g) + 0.0722 * channel(p.b);
  })();
  root.style.setProperty('--label-featured-fg', cardLum < 0.4 ? '#FDE68A' : '#92400E');
  root.style.setProperty('--tier-bronze', TIER_COLORS.bronze);
  root.style.setProperty('--tier-silver', TIER_COLORS.silver);
  root.style.setProperty('--tier-gold', TIER_COLORS.gold);
  root.style.setProperty('--tier-platinum', TIER_COLORS.platinum);
  root.style.setProperty('--radius-scale', String(slice.radiusScale));
  root.style.setProperty('--radius-sm', `${+(12 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-md', `${+(16 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-lg', `${+(20 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-xl', `${+(20 * slice.radiusScale).toFixed(1)}px`);
  root.style.setProperty('--radius-card', `${+(16 * slice.radiusScale).toFixed(1)}px`);
  const sh = Math.max(0, slice.shadowStrength ?? 1);
  root.style.setProperty('--shadow-strength', String(sh));
  root.style.setProperty('--shadow-card', `0 2px 8px rgba(15, 23, 42, ${+(0.06 * sh).toFixed(3)})`);
  root.style.setProperty('--shadow-sheet', `0 -8px 24px rgba(15, 23, 42, ${+(0.12 * sh).toFixed(3)})`);
  root.style.setProperty('--shadow-pin', `0 2px 8px rgba(15, 23, 42, ${+(0.28 * sh).toFixed(3)})`);
  root.style.setProperty('--elev-nav', `0 2px 8px rgba(15, 23, 42, ${+(0.06 * sh).toFixed(3)})`);
  root.style.setProperty('--nav-height', `${slice.tab.height}px`);
  root.style.setProperty('--nav-icon', `${slice.tab.iconSize}px`);
  root.style.setProperty('--fab-size', '56px');
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
  const lines: string[] = [
    '# Design tokens — Teal tươi (3C)',
    '',
    'Sinh từ bảng **Giao diện** của prototype. User App và PT Center dùng chung một bộ.',
    '',
    `Ngày xuất: ${new Date().toISOString().slice(0, 10)}`,
    '',
    '## Màu trạng thái',
    '',
    '| Trạng thái | Token |',
    '|---|---|',
    '| Chờ xác nhận | `--warning` |',
    '| Sắp / đang diễn ra | `--brand` / `--brand-text` |',
    '| Hoàn thành | `--success` |',
    '| Đã huỷ | `--text-2` |',
    '| No-show / tranh chấp | `--danger` |',
    '',
    '## Cấp PT',
    '',
    '| Cấp | Màu |',
    '|---|---|',
    `| Bronze | ${TIER_COLORS.bronze} |`,
    `| Silver | ${TIER_COLORS.silver} |`,
    `| Gold | ${TIER_COLORS.gold} |`,
    `| Platinum | ${TIER_COLORS.platinum} |`,
    '',
  ];
  for (const meta of styleList) {
    const mode: ModeId = meta.id === 'night' ? 'dark' : 'light';
    const s = slices[meta.id][mode];
    const font = FONT_OPTIONS.find((f) => f.id === s.font);
    lines.push(`## ${meta.label}`, '');
    lines.push('| Token | Giá trị |', '|---|---|');
    lines.push(`| Font | ${font?.label ?? s.font} (${font?.license ?? ''}) |`);
    lines.push(`| Cỡ chữ toàn app | ${Math.round(s.fontScale * 100)}% |`);
    for (const lv of TYPE_LEVELS) {
      const t = s.type[lv.id];
      lines.push(
        `| ${lv.label} | ${t.size}px × ${s.fontScale} = ${(t.size * s.fontScale).toFixed(1)}px / weight ${t.weight} |`,
      );
    }
    for (const role of COLOR_ROLES) {
      lines.push(`| ${role.label} | ${s.colors[role.key]} |`);
    }
    lines.push(`| Radius scale | ${s.radiusScale} (12/16/20 × scale) |`);
    lines.push(`| Bóng | ${s.shadowStrength} × 0 2px 8px rgba(15,23,42,.06) |`);
    lines.push(`| Bottom tab | ${s.tab.label} / ${s.tab.navBg} / ${s.tab.height}px / icon ${s.tab.iconSize}px |`);
    lines.push('');
    lines.push('### Tương phản', '');
    lines.push('| Cặp | Tỉ lệ | 4.5:1 |', '|---|---|---|');
    for (const p of contrastPairs(s.colors)) {
      const r = contrastRatio(p.fg, p.bg);
      const ok = r != null && r >= 4.5;
      lines.push(`| ${p.label} (${p.fg} / ${p.bg}) | ${formatContrast(r)} | ${ok ? '✓' : '✗'} |`);
    }
    lines.push('');
  }
  return lines.join('\n');
}

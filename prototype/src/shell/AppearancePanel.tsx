import { useState } from 'react';
import { featureLabels, type FeatureFlags } from '@/config/features';
import { useAppearance } from '@/store/appearanceStore';
import { useAppStore } from '@/store/appStore';
import {
  FAB_ICONS,
  FONT_OPTIONS,
  TAB_SLOTS,
  TYPE_LEVELS,
  contrastPairs,
  contrastRatio,
  formatContrast,
  generateDesignTokensMarkdown,
  type AppearanceColors,
  type FontId,
  type NavBg,
  type TabLabelMode,
  type TabLayout,
} from '@/theme/appearance';
import { Icon } from '@/components/Icon';

const TAB_FEATURES: Partial<Record<string, keyof FeatureFlags>> = {
  UCA1: 'cameraAiPreview',
};

export function AppearancePanel() {
  const style = useAppStore((s) => s.style);
  const mode = useAppStore((s) => s.mode);
  const features = useAppStore((s) => s.features);
  const setFeature = useAppStore((s) => s.setFeature);
  const slice = useAppearance((s) => s.slices[style][mode]);
  const patchCurrent = useAppearance((s) => s.patchCurrent);
  const restoreDefaults = useAppearance((s) => s.restoreDefaults);
  const markProjectSaved = useAppearance((s) => s.markProjectSaved);
  const slices = useAppearance((s) => s.slices);
  const [msg, setMsg] = useState<string | null>(null);
  const isDev = import.meta.env.DEV;

  const note = (text: string) => {
    setMsg(text);
    window.setTimeout(() => setMsg(null), 2800);
  };

  const saveProject = async () => {
    try {
      const res = await fetch('/__proto/save-overrides', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(slices, null, 2),
      });
      if (!res.ok) throw new Error(String(res.status));
      markProjectSaved(slices);
      note('Đã lưu vào src/theme/overrides.json');
    } catch {
      note('Không lưu được — chỉ chạy với npm run dev');
    }
  };

  const exportTokens = async () => {
    const markdown = generateDesignTokensMarkdown(slices);
    try {
      const res = await fetch('/__proto/export-tokens', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ markdown }),
      });
      if (!res.ok) throw new Error(String(res.status));
      note('Đã ghi docs/DESIGN_TOKENS_FINAL.md');
    } catch {
      note('Không ghi được file — chỉ chạy với npm run dev');
    }
  };

  const exportJson = () => {
    const blob = new Blob([JSON.stringify(slices, null, 2)], {
      type: 'application/json',
    });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'psgy-appearance.json';
    a.click();
    URL.revokeObjectURL(a.href);
  };

  const pairs = contrastPairs(slice.colors);

  return (
    <div className="space-y-5 text-[13px]">
      <p className="rounded-lg bg-white/5 px-3 py-2 text-[12px] leading-relaxed text-slate-300">
        Đang sửa <b className="text-sky-300">{style}</b> ×{' '}
        <b className="text-sky-300">{mode === 'light' ? 'sáng' : 'tối'}</b>. Hai điện
        thoại đổi ngay.
      </p>

      <section>
        <H>Chữ</H>
        <label className="mt-2 block text-[12px] text-slate-400">Font</label>
        <select
          id="appearance-font"
          className="mt-1 w-full rounded-lg border border-white/15 bg-slate-800 px-2 py-2"
          value={slice.font}
          onChange={(e) => patchCurrent({ font: e.target.value as FontId })}
        >
          {FONT_OPTIONS.map((f) => (
            <option key={f.id} value={f.id}>
              {f.label}
            </option>
          ))}
        </select>
        <label className="mt-3 flex items-center justify-between text-[12px] text-slate-400">
          Cỡ chữ toàn app
          <span className="font-mono text-sky-300">{Math.round(slice.fontScale * 100)}%</span>
        </label>
        <input
          id="appearance-scale"
          type="range"
          min={85}
          max={125}
          step={1}
          value={Math.round(slice.fontScale * 100)}
          onChange={(e) => patchCurrent({ fontScale: Number(e.target.value) / 100 })}
          className="mt-1 w-full"
        />
        <div className="mt-3 space-y-2">
          {TYPE_LEVELS.map((lv) => {
            const t = slice.type[lv.id];
            return (
              <div key={lv.id} className="rounded-lg bg-white/5 p-2">
                <div className="mb-1 text-[12px] font-semibold text-slate-200">{lv.label}</div>
                <div className="grid grid-cols-2 gap-2">
                  <Num
                    label="px"
                    value={t.size}
                    min={8}
                    max={48}
                    onChange={(size) =>
                      patchCurrent({ type: { [lv.id]: { ...t, size } } })
                    }
                  />
                  <label className="text-[11px] text-slate-400">
                    Đậm
                    <select
                      className="mt-1 w-full rounded border border-white/15 bg-slate-800 px-1 py-1 text-slate-100"
                      value={t.weight}
                      onChange={(e) =>
                        patchCurrent({
                          type: { [lv.id]: { ...t, weight: Number(e.target.value) } },
                        })
                      }
                    >
                      {[400, 500, 600, 700, 800].map((w) => (
                        <option key={w} value={w}>
                          {w}
                        </option>
                      ))}
                    </select>
                  </label>
                </div>
              </div>
            );
          })}
        </div>
        <div className="mt-3 space-y-2">
          {pairs.map((p) => (
            <ColorRow
              key={p.key}
              label={p.label}
              value={slice.colors[p.key]}
              contrastFg={p.fg}
              contrastBg={p.bg}
              onChange={(hex) =>
                patchCurrent({ colors: { [p.key]: hex } as Partial<AppearanceColors> })
              }
            />
          ))}
        </div>
      </section>

      <section>
        <H>Màu & hình khối</H>
        <div className="mt-2 space-y-2">
          {(
            [
              ['primary', 'Màu chính'],
              ['highlight', 'Màu nhấn'],
              ['bg', 'Nền app'],
              ['card', 'Nền card'],
              ['tag', 'Nền tag'],
            ] as const
          ).map(([key, label]) => (
            <ColorRow
              key={key}
              label={label}
              value={slice.colors[key]}
              onChange={(hex) =>
                patchCurrent({ colors: { [key]: hex } as Partial<AppearanceColors> })
              }
            />
          ))}
        </div>
        <label className="mt-3 flex items-center justify-between text-[12px] text-slate-400">
          Bo góc
          <span className="font-mono text-sky-300">{Math.round(slice.radiusScale * 100)}%</span>
        </label>
        <input
          type="range"
          min={50}
          max={200}
          step={5}
          value={Math.round(slice.radiusScale * 100)}
          onChange={(e) => patchCurrent({ radiusScale: Number(e.target.value) / 100 })}
          className="mt-1 w-full"
        />
      </section>

      <section>
        <H>Bottom tab</H>
        <label className="mt-2 block text-[12px] text-slate-400">Kiểu</label>
        <div className="mt-1 grid grid-cols-2 gap-1.5">
          {(
            [
              ['raised', '5 tab, nút giữa nổi'],
              ['flat', '5 tab phẳng'],
            ] as [TabLayout, string][]
          ).map(([id, label]) => (
            <Mini
              key={id}
              active={slice.tab.layout === id}
              onClick={() => patchCurrent({ tab: { layout: id } })}
            >
              {label}
            </Mini>
          ))}
          {(
            [
              ['iconOnly', 'chỉ icon'],
              ['iconText', 'icon + chữ'],
            ] as [TabLabelMode, string][]
          ).map(([id, label]) => (
            <Mini
              key={id}
              active={slice.tab.label === id}
              onClick={() => patchCurrent({ tab: { label: id } })}
            >
              {label}
            </Mini>
          ))}
        </div>
        <div className="mt-3 space-y-2">
          <ColorRow
            label="Tab đang chọn"
            value={slice.colors.tabActive}
            onChange={(hex) => patchCurrent({ colors: { tabActive: hex } })}
          />
          <ColorRow
            label="Tab không chọn"
            value={slice.colors.tabInactive}
            onChange={(hex) => patchCurrent({ colors: { tabInactive: hex } })}
          />
          <ColorRow
            label="Nền thanh"
            value={slice.colors.navBar}
            onChange={(hex) => patchCurrent({ colors: { navBar: hex } })}
          />
          <ColorRow
            label="Nút giữa"
            value={slice.colors.fab}
            onChange={(hex) => patchCurrent({ colors: { fab: hex } })}
          />
        </div>
        <label className="mt-3 block text-[12px] text-slate-400">Nền thanh</label>
        <div className="mt-1 grid grid-cols-3 gap-1.5">
          {(
            [
              ['solid', 'Đặc'],
              ['glass', 'Mờ kính'],
              ['transparent', 'Trong suốt'],
            ] as [NavBg, string][]
          ).map(([id, label]) => (
            <Mini
              key={id}
              active={slice.tab.navBg === id}
              onClick={() => patchCurrent({ tab: { navBg: id } })}
            >
              {label}
            </Mini>
          ))}
        </div>
        <label className="mt-3 flex items-center justify-between text-[12px] text-slate-400">
          Chiều cao thanh
          <span className="font-mono text-sky-300">{slice.tab.height}px</span>
        </label>
        <input
          type="range"
          min={52}
          max={88}
          step={2}
          value={slice.tab.height}
          onChange={(e) => patchCurrent({ tab: { height: Number(e.target.value) } })}
          className="mt-1 w-full"
        />
        <label className="mt-2 flex items-center justify-between text-[12px] text-slate-400">
          Cỡ icon
          <span className="font-mono text-sky-300">{slice.tab.iconSize}px</span>
        </label>
        <input
          type="range"
          min={18}
          max={32}
          step={1}
          value={slice.tab.iconSize}
          onChange={(e) => patchCurrent({ tab: { iconSize: Number(e.target.value) } })}
          className="mt-1 w-full"
        />
        <label className="mt-3 block text-[12px] text-slate-400">Icon nút giữa</label>
        <div className="mt-1 grid grid-cols-6 gap-1">
          {FAB_ICONS.map((name) => (
            <button
              key={name}
              type="button"
              title={name}
              onClick={() => patchCurrent({ tab: { fabIcon: name } })}
              className={`grid h-9 place-items-center rounded-lg ${
                slice.tab.fabIcon === name ? 'bg-sky-500 text-slate-950' : 'bg-white/10'
              }`}
            >
              <Icon name={name} size={18} />
            </button>
          ))}
        </div>
        <div className="mt-3 text-[12px] text-slate-400">Thứ tự tab</div>
        <div className="mt-1 space-y-1">
          {slice.tab.order.map((id, i) => {
            const meta = TAB_SLOTS.find((t) => t.id === id);
            const flag = TAB_FEATURES[id];
            return (
              <div
                key={id}
                className="flex items-center gap-2 rounded-lg bg-white/5 px-2 py-1.5"
              >
                <span className="w-8 font-mono text-[11px] text-sky-300">{id}</span>
                <span className="flex-1 truncate">{meta?.label ?? id}</span>
                {flag && (
                  <span className="text-[10px] text-slate-500">
                    {features[flag] ? 'bật' : 'tắt'}
                  </span>
                )}
                <button
                  type="button"
                  disabled={i === 0}
                  className="px-1 disabled:opacity-30"
                  onClick={() => {
                    const order = [...slice.tab.order];
                    [order[i - 1], order[i]] = [order[i], order[i - 1]];
                    patchCurrent({ tab: { order } });
                  }}
                >
                  ↑
                </button>
                <button
                  type="button"
                  disabled={i === slice.tab.order.length - 1}
                  className="px-1 disabled:opacity-30"
                  onClick={() => {
                    const order = [...slice.tab.order];
                    [order[i + 1], order[i]] = [order[i], order[i + 1]];
                    patchCurrent({ tab: { order } });
                  }}
                >
                  ↓
                </button>
              </div>
            );
          })}
        </div>
        <div className="mt-2 space-y-1 text-[12px]">
          <div className="text-slate-400">Bật/tắt tab (cùng cờ features.ts)</div>
          {(['cameraAiPreview', 'aiAssistant', 'spa'] as const).map((k) => (
            <label key={k} className="flex items-center justify-between">
              <span>{featureLabels[k]}</span>
              <input
                type="checkbox"
                checked={features[k]}
                onChange={(e) => setFeature(k, e.target.checked)}
              />
            </label>
          ))}
        </div>
      </section>

      <section className="space-y-2">
        <H>Lưu</H>
        {isDev && (
          <button
            type="button"
            onClick={saveProject}
            className="press w-full rounded-xl bg-sky-500 py-2.5 font-semibold text-slate-950"
          >
            Lưu vào dự án
          </button>
        )}
        <button
          type="button"
          onClick={exportJson}
          className="press w-full rounded-xl bg-white/10 py-2.5 font-semibold"
        >
          Xuất JSON
        </button>
        {isDev && (
          <button
            type="button"
            onClick={exportTokens}
            className="press w-full rounded-xl bg-white/10 py-2.5 font-semibold"
          >
            Xuất bảng token cho đội dev
          </button>
        )}
        <button
          type="button"
          onClick={() => {
            restoreDefaults();
            note('Đã khôi phục mặc định dự án');
          }}
          className="press w-full rounded-xl bg-white/10 py-2.5 font-semibold"
        >
          Khôi phục mặc định
        </button>
        {msg && <p className="text-center text-[12px] text-sky-300">{msg}</p>}
      </section>
    </div>
  );
}

function H({ children }: { children: string }) {
  return (
    <div className="text-[11px] font-semibold uppercase tracking-wider text-slate-400">
      {children}
    </div>
  );
}

function Mini({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: string;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`press rounded-lg px-2 py-2 text-[11px] font-semibold leading-tight ${
        active ? 'bg-sky-500 text-slate-950' : 'bg-white/10'
      }`}
    >
      {children}
    </button>
  );
}

function Num({
  label,
  value,
  min,
  max,
  onChange,
}: {
  label: string;
  value: number;
  min: number;
  max: number;
  onChange: (n: number) => void;
}) {
  return (
    <label className="text-[11px] text-slate-400">
      {label}
      <input
        type="number"
        min={min}
        max={max}
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
        className="mt-1 w-full rounded border border-white/15 bg-slate-800 px-2 py-1 text-slate-100"
      />
    </label>
  );
}

function ColorRow({
  label,
  value,
  onChange,
  contrastFg,
  contrastBg,
}: {
  label: string;
  value: string;
  onChange: (hex: string) => void;
  contrastFg?: string;
  contrastBg?: string;
}) {
  const ratio =
    contrastFg && contrastBg ? contrastRatio(contrastFg, contrastBg) : null;
  const warn = ratio != null && ratio < 4.5;
  return (
    <div className="flex items-center gap-2">
      <input
        type="color"
        value={parseHexInput(value)}
        onChange={(e) => onChange(e.target.value)}
        className="h-8 w-8 shrink-0 cursor-pointer rounded border-0 bg-transparent"
      />
      <div className="min-w-0 flex-1">
        <div className="text-[11px] text-slate-300">{label}</div>
        <input
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="w-full rounded border border-white/15 bg-slate-800 px-2 py-1 font-mono text-[11px]"
        />
      </div>
      {ratio != null && (
        <span
          className={`w-14 shrink-0 text-right font-mono text-[10px] ${
            warn ? 'font-bold text-red-400' : 'text-slate-400'
          }`}
          title={warn ? 'Dưới 4.5:1' : 'Đạt 4.5:1'}
        >
          {formatContrast(ratio)}
          {warn ? ' !' : ''}
        </span>
      )}
    </div>
  );
}

function parseHexInput(v: string) {
  const h = v.trim();
  if (/^#[0-9a-fA-F]{6}$/.test(h)) return h;
  if (/^#[0-9a-fA-F]{3}$/.test(h)) {
    const s = h.slice(1);
    return `#${s[0]}${s[0]}${s[1]}${s[1]}${s[2]}${s[2]}`;
  }
  return '#000000';
}

import { useMemo, useState, type ReactNode } from 'react';
import { featureLabels, type FeatureFlags } from '@/config/features';
import { screens } from '@/screens/registry';
import { useAppStore } from '@/store/appStore';
import { styles, type ModeId, type StyleId } from '@/theme/presets';
import type { Role } from '@/types';

export function DemoPanel({ compact }: { compact?: boolean }) {
  const mobileRole = useAppStore((s) => s.mobileRole);
  const setMobileRole = useAppStore((s) => s.setMobileRole);
  const style = useAppStore((s) => s.style);
  const setStyle = useAppStore((s) => s.setStyle);
  const mode = useAppStore((s) => s.mode);
  const setMode = useAppStore((s) => s.setMode);
  const features = useAppStore((s) => s.features);
  const setFeature = useAppStore((s) => s.setFeature);
  const jump = useAppStore((s) => s.jump);
  const setUserTab = useAppStore((s) => s.setUserTab);
  const reset = useAppStore((s) => s.reset);
  const [q, setQ] = useState('');

  const filtered = useMemo(() => {
    const n = q.trim().toLowerCase();
    return screens.filter(
      (s) =>
        !n ||
        s.id.toLowerCase().includes(n) ||
        s.name.toLowerCase().includes(n),
    );
  }, [q]);

  const users = filtered.filter((s) => s.role === 'user' || s.role === 'both');
  const coaches = filtered.filter((s) => s.role === 'coach' || s.role === 'both');

  const go = (id: string, role: Role, params?: Record<string, string>) => {
    const tabIds = new Set(['U07', 'U13', 'U14', 'U15', 'U19']);
    if (role === 'user' && tabIds.has(id)) setUserTab(id);
    else jump(role, { id, params });
    if (compact) setMobileRole(role);
  };

  return (
    <aside
      className={`flex flex-col overflow-hidden rounded-2xl border border-white/10 bg-slate-900/90 text-slate-100 shadow-xl backdrop-blur ${
        compact ? 'h-full max-h-[80dvh] w-[min(360px,92vw)]' : 'h-[844px] w-[320px]'
      }`}
    >
      <div className="border-b border-white/10 px-4 py-3">
        <div className="text-[11px] font-semibold uppercase tracking-wider text-sky-300">
          Bảng điều khiển demo
        </div>
        <div className="text-lg font-bold">PSGymer prototype</div>
      </div>
      <div className="no-scrollbar flex-1 space-y-5 overflow-y-auto p-4 text-[13px]">
        <section>
          <Label>Vai (màn hẹp / 1 app)</Label>
          <div className="mt-1 grid grid-cols-2 gap-2">
            {(['user', 'coach'] as Role[]).map((r) => (
              <Seg
                key={r}
                active={mobileRole === r}
                onClick={() => setMobileRole(r)}
              >
                {r === 'user' ? 'User' : 'Coach'}
              </Seg>
            ))}
          </div>
        </section>

        <section>
          <Label>Sáng / Tối</Label>
          <div className="mt-1 grid grid-cols-2 gap-2">
            {(['light', 'dark'] as ModeId[]).map((m) => (
              <Seg key={m} active={mode === m} onClick={() => setMode(m)}>
                {m === 'light' ? 'Sáng' : 'Tối'}
              </Seg>
            ))}
          </div>
        </section>

        <section>
          <Label>Style</Label>
          <div className="mt-1 grid grid-cols-2 gap-2">
            {styles.map((s) => (
              <Seg
                key={s.id}
                active={style === s.id}
                onClick={() => setStyle(s.id as StyleId)}
              >
                {s.label.replace(' (hiện tại)', '')}
              </Seg>
            ))}
          </div>
        </section>

        <section>
          <Label>Tính năng</Label>
          <div className="mt-2 space-y-2">
            {(Object.keys(featureLabels) as (keyof FeatureFlags)[]).map((k) => (
              <label key={k} className="flex items-center justify-between gap-3">
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

        <section>
          <Label>Nhảy tới màn</Label>
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="Tìm mã hoặc tên…"
            className="mt-1 w-full rounded-lg border border-white/15 bg-slate-800 px-3 py-2 text-[13px] outline-none"
          />
          <Group title="User">
            {users.map((s) => (
              <button
                key={`u-${s.id}`}
                type="button"
                className="press flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left hover:bg-white/10"
                onClick={() => go(s.id, 'user', s.defaultParams)}
              >
                <span className="font-mono text-[11px] text-sky-300">{s.id}</span>
                <span className="truncate pl-2">{s.name}</span>
              </button>
            ))}
          </Group>
          <Group title="Coach">
            {coaches.map((s) => (
              <button
                key={`c-${s.id}`}
                type="button"
                className="press flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left hover:bg-white/10"
                onClick={() => go(s.id, 'coach', s.defaultParams)}
              >
                <span className="font-mono text-[11px] text-violet-300">{s.id}</span>
                <span className="truncate pl-2">{s.name}</span>
              </button>
            ))}
          </Group>
        </section>

        <button
          type="button"
          onClick={reset}
          className="press w-full rounded-xl bg-white/10 py-2.5 font-semibold hover:bg-white/15"
        >
          Reset dữ liệu
        </button>
      </div>
    </aside>
  );
}

function Label({ children }: { children: string }) {
  return (
    <div className="text-[11px] font-semibold uppercase tracking-wider text-slate-400">
      {children}
    </div>
  );
}

function Seg({
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
      className={`press rounded-lg px-2 py-2 text-[12px] font-semibold ${
        active ? 'bg-sky-500 text-slate-950' : 'bg-white/10'
      }`}
    >
      {children}
    </button>
  );
}

function Group({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div className="mt-3">
      <div className="mb-1 text-[11px] font-bold text-slate-400">{title}</div>
      <div className="space-y-0.5">{children}</div>
    </div>
  );
}

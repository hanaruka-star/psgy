import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { brand } from '@/config/brand';
import { vnd, atDay } from '@/lib/format';
import { useAppStore, useNow } from '@/store/appStore';
import { useEffect, useState } from 'react';

function Bar({ n, onBack }: { n: number; onBack: () => void }) {
  return (
    <div className="flex items-center gap-2 px-4 py-2">
      <button type="button" onClick={onBack}>←</button>
      <div className="h-1 flex-1 overflow-hidden rounded bg-[var(--tag)]">
        <div className="h-full bg-[var(--primary)]" style={{ width: `${(n / 5) * 100}%` }} />
      </div>
      <span className="type-caption">{n}/5</span>
    </div>
  );
}

export function UB1({ params }: { params?: Record<string, string> }) {
  const pt = useAppStore((s) => s.pts.find((p) => p.id === (params?.ptId ?? s.draft?.ptId)) ?? s.pts[0]);
  const draft = useAppStore((s) => s.draft);
  const patch = useAppStore((s) => s.patchDraft);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const features = useAppStore((s) => s.features);
  const existing = useAppStore((s) => s.contracts.find((c) => c.ptId === pt.id && c.status === 'active'));
  const packs = pt.packages.filter((p) => features.groupPackages || p.kind === 'personal');
  return (
    <Screen title="Chọn gói tập" onBack={() => pop('user')}>
      <Bar n={1} onBack={() => pop('user')} />
      <div className="px-4">
        <div className="font-bold">{pt.name} · ★ {pt.stars.toFixed(1)}</div>
        {existing && (
          <button
            type="button"
            className="app-card mt-3 w-full p-3 text-left"
            onClick={() => patch({ useExisting: true, packageId: existing.id })}
          >
            Dùng gói đang có (còn {existing.sessions - existing.done}/{existing.sessions} buổi)
          </button>
        )}
        {packs.map((p) => (
          <button
            key={p.id}
            type="button"
            className={`app-card mt-2 w-full p-3 text-left ${draft?.packageId === p.id ? 'ring-1 ring-[var(--primary)]' : ''}`}
            onClick={() => patch({ packageId: p.id, useExisting: false })}
          >
            <div className="flex justify-between">
              <span>{p.name}</span>
              <span>{vnd(p.priceVnd)}</span>
            </div>
            {p.sessions > 1 && (
              <div className="type-caption">Tiết kiệm {Math.round((1 - p.priceVnd / (pt.priceFrom * p.sessions)) * 100)}%</div>
            )}
          </button>
        ))}
        <Button className="mt-4" block onClick={() => jump('user', { id: 'UB2', params })}>
          Tiếp tục
        </Button>
      </div>
    </Screen>
  );
}

export function UB2({ params }: { params?: Record<string, string> }) {
  const pt = useAppStore((s) => s.pts.find((p) => p.id === params?.ptId) ?? s.pts[0]);
  const draft = useAppStore((s) => s.draft);
  const patch = useAppStore((s) => s.patchDraft);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const now = useNow();
  const times = [...new Set(pt.slots.map((s) => s.start))];
  const days = Array.from({ length: 14 }, (_, i) => now + i * 86400000);
  return (
    <Screen title="Chọn thời gian" onBack={() => pop('user')}>
      <Bar n={2} onBack={() => pop('user')} />
      <div className="flex gap-2 overflow-x-auto px-4">
        {days.map((d) => (
          <Chip key={d} selected={draft?.dateMs === d} onClick={() => patch({ dateMs: d })}>
            {atDay(d)}
          </Chip>
        ))}
      </div>
      <div className="mt-3 flex flex-wrap gap-2 px-4">
        {times.map((t) => (
          <Chip key={t} selected={draft?.time === t} onClick={() => patch({ time: t })}>
            {t}
          </Chip>
        ))}
      </div>
      <div className="px-4 mt-3 flex gap-2">
        {[60, 90, 120].map((m) => (
          <Chip key={m} selected={draft?.durationMin === m} onClick={() => patch({ durationMin: m })}>
            {m} phút
          </Chip>
        ))}
      </div>
      <div className="px-4 mt-4">
        <Button block onClick={() => jump('user', { id: 'UB3', params })}>Tiếp tục</Button>
      </div>
    </Screen>
  );
}

export function UB3({ params }: { params?: Record<string, string> }) {
  const gyms = useAppStore((s) => s.gyms);
  const draft = useAppStore((s) => s.draft);
  const patch = useAppStore((s) => s.patchDraft);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const [openUnlinked, setOpen] = useState(false);
  const linked = gyms.filter((g) => g.linked);
  const other = gyms.filter((g) => !g.linked);
  return (
    <Screen title="Chọn địa điểm" onBack={() => pop('user')}>
      <Bar n={3} onBack={() => pop('user')} />
      <div className="px-4">
        <div className="font-semibold">Phòng gym liên kết — miễn phí cho PT</div>
        {linked.map((g) => (
          <button
            key={g.id}
            type="button"
            className={`app-card mt-2 w-full p-3 text-left ${draft?.gymId === g.id ? 'ring-1 ring-[var(--primary)]' : ''}`}
            onClick={() => patch({ gymId: g.id })}
          >
            {g.name} · Liên kết
          </button>
        ))}
        <button type="button" className="mt-3 type-caption" onClick={() => setOpen(!openUnlinked)}>
          Phòng gym chưa liên kết {openUnlinked ? '▾' : '▸'}
        </button>
        {openUnlinked &&
          other.map((g) => (
            <button
              key={g.id}
              type="button"
              className="app-card mt-2 w-full p-3 text-left"
              onClick={() => patch({ gymId: g.id })}
            >
              {g.name} · có thể phát sinh phí vào cửa
            </button>
          ))}
        <Button className="mt-4" block onClick={() => jump('user', { id: 'UB4', params })}>
          Tiếp tục
        </Button>
      </div>
    </Screen>
  );
}

export function UB4() {
  const draft = useAppStore((s) => s.draft);
  const pt = useAppStore((s) => s.pts.find((p) => p.id === draft?.ptId) ?? s.pts[0]);
  const pack = pt.packages.find((p) => p.id === draft?.packageId) ?? pt.packages[0];
  const gym = useAppStore((s) => s.gyms.find((g) => g.id === draft?.gymId));
  const wallet = useAppStore((s) => s.wallet);
  const patch = useAppStore((s) => s.patchDraft);
  const pay = useAppStore((s) => s.payBooking);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const skipPay = draft?.useExisting;
  return (
    <Screen title="Xác nhận" onBack={() => pop('user')}>
      <Bar n={4} onBack={() => pop('user')} />
      <div className="px-4 space-y-2">
        <div className="app-card p-3">
          {pt.name} · {pack.name} · {draft?.time} · {gym?.name}
        </div>
        <div className="type-caption">Huỷ trước 24 giờ hoàn 100% · trong 24 giờ phí 50% · trong 2 giờ mất buổi.</div>
        {!skipPay && (
          <div className="app-card p-3">
            <div>{brand.walletName}: {vnd(wallet)}</div>
            {wallet < pack.priceVnd && draft?.payMethod === 'wallet' && (
              <Button className="mt-2" onClick={() => jump('user', { id: 'UW1' })}>
                Nạp thêm
              </Button>
            )}
            <div className="mt-2 flex flex-wrap gap-1">
              {(['wallet', 'momo', 'zalopay', 'vnpay', 'card'] as const).map((m) => (
                <Chip key={m} selected={draft?.payMethod === m} onClick={() => patch({ payMethod: m })}>
                  {m}
                </Chip>
              ))}
            </div>
            <div className="mt-2 font-bold">Tổng {vnd(pack.priceVnd)}</div>
          </div>
        )}
        <Button
          block
          onClick={() => {
            const err = pay();
            if (!err) jump('user', { id: 'UB5' });
            if (err && err !== 'WALLET') alert(err);
          }}
        >
          {skipPay ? 'Xác nhận dùng gói' : 'Thanh toán'}
        </Button>
      </div>
    </Screen>
  );
}

export function UB5() {
  const jump = useAppStore((s) => s.jump);
  useEffect(() => {
    const t = window.setTimeout(() => jump('user', { id: 'UB6' }), 900);
    return () => window.clearTimeout(t);
  }, [jump]);
  return (
    <div className="grid h-full place-items-center">
      <div className="type-title">Đang xử lý…</div>
    </div>
  );
}

export function UB6() {
  const jump = useAppStore((s) => s.jump);
  return (
    <div className="grid h-full place-items-center p-6 text-center">
      <div>
        <div className="text-4xl">🎉</div>
        <h1 className="type-title mt-2">Thanh toán thành công!</h1>
        <p className="type-body mt-2">
          Đang chờ PT xác nhận. PT sẽ phản hồi trong vòng 24 giờ — nếu không, bạn được hoàn tiền tự động.
        </p>
        <Button className="mt-4" onClick={() => jump('user', { id: 'UPF1' })}>
          Về trang chủ
        </Button>
      </div>
    </div>
  );
}

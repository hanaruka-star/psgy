import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { ME, useAppStore } from '@/store/appStore';
import { atFull, vnd } from '@/lib/format';

export function UPF1() {
  const contracts = useAppStore((s) => s.contracts);
  const sessions = useAppStore((s) => s.sessions);
  const pts = useAppStore((s) => s.pts);
  const streak = useAppStore((s) => s.streak);
  const weights = useAppStore((s) => s.weights);
  const saved = useAppStore((s) => s.saved);
  const jump = useAppStore((s) => s.jump);
  const next = sessions.find((s) => s.status === 'scheduled' || s.status === 'pendingConfirm' || s.status === 'training');
  const lastW = weights[weights.length - 1];
  const firstW = weights[0];
  return (
    <Screen title=" " padNav>
      <div className="bg-[var(--primary)] px-4 pb-6 pt-4 text-[var(--on-primary)]">
        <div className="flex justify-between">
          <div>
            <div className="type-title">{ME.name}, {ME.age}</div>
            <div className="type-caption">{ME.city}</div>
          </div>
          <button type="button" onClick={() => jump('user', { id: 'UN1' })}>🔔</button>
        </div>
        <Button variant="ghost" className="mt-2 !text-[var(--on-primary)]" onClick={() => jump('user', { id: 'UPF2' })}>
          Chỉnh sửa hồ sơ
        </Button>
      </div>
      <div className="p-4 space-y-3">
        <div className="flex gap-1">{ME.goals.map((g) => <Chip key={g}>{g}</Chip>)}</div>
        <div className="type-caption font-bold">ĐANG TẬP VỚI PT</div>
        <div className="flex gap-3 overflow-x-auto">
          {contracts.filter((c) => c.status === 'active' || c.status === 'pending').map((c) => {
            const pt = pts.find((p) => p.id === c.ptId);
            return (
              <button key={c.id} type="button" className="app-card w-56 shrink-0 p-3 text-left" onClick={() => jump('user', { id: 'UJ2', params: { contractId: c.id } })}>
                <div className="font-bold">{pt?.name}</div>
                <div>{c.packageName} · {c.done}/{c.sessions}</div>
                <Chip>{c.status === 'pending' ? 'Chờ xác nhận' : 'Đang diễn ra'}</Chip>
              </button>
            );
          })}
        </div>
        <button type="button" className="app-card w-full p-3 text-left" onClick={() => jump('user', { id: 'UPF4' })}>
          Thành tích · streak {streak} tuần · Xem chi tiết
        </button>
        <button type="button" className="app-card w-full p-3 text-left" onClick={() => jump('user', { id: 'UPF3' })}>
          Tiến trình {firstW?.kg.toFixed(1)} → {lastW?.kg.toFixed(1)} kg
        </button>
        <div className="grid grid-cols-3 gap-2">
          <Tile onClick={() => jump('user', { id: 'UJ1' })} label="Hợp đồng" />
          <Tile onClick={() => jump('user', { id: 'UL1' })} label="Lịch tập" />
          <Tile onClick={() => jump('user', { id: 'UPY1' })} label="Thanh toán" />
        </div>
        <button type="button" className="app-card w-full p-3" onClick={() => jump('user', { id: 'USV1' })}>
          Đã lưu · PT {saved.pts.length} · Gym {saved.gyms.length} · Spa {saved.spas.length}
        </button>
        <button type="button" className="type-caption" onClick={() => jump('user', { id: 'UST1' })}>
          Cài đặt
        </button>
        {next && (
          <Button onClick={() => jump('user', { id: 'USS1', params: { sessionId: next.id } })}>
            Buổi tiếp theo {atFull(next.startAt)}
          </Button>
        )}
      </div>
    </Screen>
  );
}

function Tile({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <button type="button" className="app-card p-3" onClick={onClick}>
      {label}
    </button>
  );
}

export function UPF2() {
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Chỉnh sửa hồ sơ" onBack={() => pop('user')}>
      <div className="p-4 space-y-2">
        {['Tên', 'Tuổi', 'Giới tính', 'Chiều cao', 'Cân nặng', 'Khu vực'].map((l) => (
          <label key={l} className="block type-caption">
            {l}
            <input className="mt-1 w-full rounded-lg bg-[var(--tag)] px-3 py-2" defaultValue={l === 'Tên' ? ME.name : ''} />
          </label>
        ))}
        <Button onClick={() => pop('user')}>Lưu</Button>
      </div>
    </Screen>
  );
}

export function UPF3() {
  const weights = useAppStore((s) => s.weights);
  const add = useAppStore((s) => s.addWeight);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Tiến trình cơ thể" onBack={() => pop('user')}>
      <div className="p-4">
        {weights.map((w) => (
          <div key={w.at} className="flex justify-between py-1">
            <span>{new Date(w.at).toLocaleDateString('vi')}</span>
            <span>{w.kg} kg</span>
          </div>
        ))}
        <Button className="mt-3" onClick={() => add(73.8)}>+ Cập nhật cân nặng</Button>
      </div>
    </Screen>
  );
}

export function UPF4() {
  const streak = useAppStore((s) => s.streak);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Thành tích" onBack={() => pop('user')}>
      <div className="p-4 grid grid-cols-2 gap-2">
        <div className="app-card p-3">Streak {streak} tuần</div>
        <div className="app-card p-3">7 buổi tháng này</div>
        <div className="app-card p-3">Tổng 15 buổi</div>
        <div className="app-card p-3">12 giờ</div>
      </div>
    </Screen>
  );
}

export function UJ1() {
  const contracts = useAppStore((s) => s.contracts);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const tabs = ['active', 'completed', 'cancelled'] as const;
  return (
    <Screen title="Hợp đồng của tôi" onBack={() => pop('user')}>
      <div className="p-4 space-y-2">
        {tabs.map((t) => (
          <div key={t}>
            <div className="font-bold capitalize">{t}</div>
            {contracts.filter((c) => (t === 'active' ? c.status === 'active' || c.status === 'pending' : c.status === t)).map((c) => (
              <button key={c.id} type="button" className="app-card mt-1 w-full p-3 text-left" onClick={() => jump('user', { id: 'UJ2', params: { contractId: c.id } })}>
                {c.packageName} · {c.done}/{c.sessions} · {c.status}
              </button>
            ))}
          </div>
        ))}
      </div>
    </Screen>
  );
}

export function UJ2({ params }: { params?: Record<string, string> }) {
  const c = useAppStore((s) => s.contracts.find((x) => x.id === params?.contractId) ?? s.contracts[0]);
  const sessionsAll = useAppStore((s) => s.sessions);
  const sessions = sessionsAll.filter((x) => x.contractId === c.id);
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Chi tiết hợp đồng" onBack={() => pop('user')}>
      <div className="p-4">
        <div className="type-title">{c.packageName} · {c.done}/{c.sessions}</div>
        {sessions.map((s) => (
          <button key={s.id} type="button" className="app-card mt-2 w-full p-3 text-left" onClick={() => jump('user', { id: 'USS1', params: { sessionId: s.id } })}>
            Buổi {s.index} · {s.status} · {atFull(s.startAt)}
          </button>
        ))}
      </div>
    </Screen>
  );
}

export function UL1() {
  const sessions = useAppStore((s) => s.sessions);
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Lịch tập" onBack={() => pop('user')}>
      <div className="p-4">
        {sessions.map((s) => (
          <button key={s.id} type="button" className="block w-full py-2 text-left" onClick={() => jump('user', { id: 'USS1', params: { sessionId: s.id } })}>
            {atFull(s.startAt)} · {s.status}
          </button>
        ))}
      </div>
    </Screen>
  );
}

export function UPY1() {
  const tx = useAppStore((s) => s.walletTx);
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Thanh toán" onBack={() => pop('user')}>
      <div className="p-4">
        <Button onClick={() => jump('user', { id: 'UW1' })}>Mở Ví PSGymer</Button>
        {tx.map((t) => (
          <div key={t.id} className="flex justify-between py-2">
            <span>{t.note}</span>
            <span>{vnd(t.amount)}</span>
          </div>
        ))}
      </div>
    </Screen>
  );
}

export function USV1() {
  const saved = useAppStore((s) => s.saved);
  const pts = useAppStore((s) => s.pts);
  const pop = useAppStore((s) => s.pop);
  const openPt = useAppStore((s) => s.openPt);
  return (
    <Screen title="Đã lưu" onBack={() => pop('user')}>
      <div className="p-4">
        {saved.pts.map((id) => {
          const p = pts.find((x) => x.id === id);
          return (
            <button key={id} type="button" className="block py-2" onClick={() => openPt(id)}>
              {p?.name}
            </button>
          );
        })}
      </div>
    </Screen>
  );
}

export function UST1() {
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Cài đặt" onBack={() => pop('user')}>
      <div className="p-4 space-y-3">
        <button type="button" onClick={() => jump('user', { id: 'UW1' })}>Phương thức thanh toán · Ví PSGymer</button>
        <div>Thông báo · Quyền riêng tư · Điều khoản</div>
      </div>
    </Screen>
  );
}

export function UN1() {
  const notisAll = useAppStore((s) => s.notis);
  const notis = notisAll.filter((n) => n.role === 'user');
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Thông báo" onBack={() => pop('user')}>
      <div className="p-4">
        {notis.map((n) => (
          <button key={n.id} type="button" className="app-card mb-2 w-full p-3 text-left" onClick={() => jump('user', { id: n.screen, params: n.params })}>
            <div className="type-caption">{n.group}</div>
            <div className="font-semibold">{n.title}</div>
            <div>{n.body}</div>
          </button>
        ))}
      </div>
    </Screen>
  );
}

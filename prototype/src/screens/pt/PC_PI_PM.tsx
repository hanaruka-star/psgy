import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { vnd } from '@/lib/format';
import { completedCount, interestedLeads } from '@/lib/progress';
import { moneyCheck, useAppStore, useNow } from '@/store/appStore';
import { useState } from 'react';

export function PC1() {
  const [tab, setTab] = useState<'msg' | 'wait' | 'interest'>('msg');
  const greetings = useAppStore((s) => s.greetings);
  const visitsAll = useAppStore((s) => s.visits);
  const contracts = useAppStore((s) => s.contracts);
  const pending = contracts.filter((c) => c.status === 'pending');
  const jump = useAppStore((s) => s.jump);
  const now = useNow();
  const minRevisit = useAppStore((s) => s.business.quick_action_revisit);
  const days = useAppStore((s) => s.business.quick_action_days);
  const leads = interestedLeads(visitsAll, 'pt_01', minRevisit, days, now);
  return (
    <Screen title="Chat" padNav>
      <div className="flex gap-2 px-4">
        <Chip selected={tab === 'msg'} onClick={() => setTab('msg')}>Tin nhắn</Chip>
        <Chip selected={tab === 'wait'} onClick={() => setTab('wait')}>Chờ chấp nhận</Chip>
        <Chip selected={tab === 'interest'} onClick={() => setTab('interest')}>Khách quan tâm</Chip>
      </div>
      <div className="p-4 space-y-2">
        {pending.map((c) => (
          <div key={c.id} className="app-card p-3">
            <div>Hợp đồng mới · {c.packageName}</div>
            <div className="mt-2 flex gap-2">
              <Button onClick={() => useAppStore.getState().confirmContract(c.id)}>Xác nhận</Button>
              <Button variant="outline" onClick={() => useAppStore.getState().rejectContract(c.id)}>Từ chối</Button>
            </div>
          </div>
        ))}
        {tab === 'msg' && (
          <button type="button" className="flex w-full gap-3 p-2 text-left" onClick={() => jump('pt', { id: 'PC2', params: { threadId: 'th_pt_01' } })}>
            <img src="/assets/branding/logo_light.png" alt="" className="h-10 w-10 rounded-full object-cover" />
            <div>
              Minh · Gói 12 buổi
              {greetings.some((g) => g.status === 'pending') && <div className="type-caption">Chờ chấp nhận</div>}
            </div>
          </button>
        )}
        {tab === 'wait' &&
          greetings.filter((g) => g.status === 'pending').map((g) => (
            <div key={g.id} className="app-card p-3">
              Chờ Minh chấp nhận lời chào.
            </div>
          ))}
        {tab === 'interest' && (
          <>
            <p className="type-caption">Những người dùng đã xem profile từ 2 lần trở lên.</p>
            {leads.map((u) => (
              <div key={u.userId} className="app-card p-3">
                {u.userName} · Đã xem profile {u.times} lần
                <Button className="mt-2" onClick={() => jump('pt', { id: 'PC3' })}>Chào hỏi</Button>
              </div>
            ))}
          </>
        )}
      </div>
    </Screen>
  );
}

export function PC3() {
  const pop = useAppStore((s) => s.pop);
  const send = useAppStore((s) => s.sendGreeting);
  const [t, setT] = useState('Chào Minh, mình là Long — mình có gói giảm mỡ 12 buổi, 3 buổi/tuần. Mình rảnh tối Q.1.');
  return (
    <Screen title="Gửi lời chào" onBack={() => pop('pt')}>
      <div className="p-4">
        <textarea maxLength={500} className="h-32 w-full rounded-lg bg-[var(--tag)] p-2" value={t} onChange={(e) => setT(e.target.value)} />
        <div className="mt-2 flex gap-1">
          {['Giảm mỡ', 'Tăng cơ', 'Lịch tập'].map((x) => (
            <Chip key={x} onClick={() => setT((s) => s + ' ' + x)}>{x}</Chip>
          ))}
        </div>
        <Button className="mt-3" onClick={() => { send(t); pop('pt'); }}>Gửi lời chào</Button>
      </div>
    </Screen>
  );
}

export function PC2() {
  const messages = useAppStore((s) => s.messages);
  const msgs = messages.filter((m) => m.threadId === 'th_pt_01');
  const sendCard = useAppStore((s) => s.sendCard);
  const sendText = useAppStore((s) => s.sendText);
  const pop = useAppStore((s) => s.pop);
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const ct = useAppStore((s) => s.contracts.find((c) => c.id === 'ct_active'));
  const sessions = useAppStore((s) => s.sessions);
  const done = ct ? completedCount(sessions, ct.id) : 0;
  const [t, setT] = useState('');
  return (
    <Screen title="Minh" onBack={() => pop('pt')}>
      <div className="px-4 type-caption">{ct ? `${ct.packageName} · Đã tập ${done}` : ''} · Đã chấp nhận</div>
      <div className="flex-1 space-y-2 overflow-y-auto p-3">
        {msgs.map((m) => (
          <div key={m.id} className={`max-w-[80%] rounded-xl p-2 ${m.from === 'pt' ? 'ml-auto bg-[var(--primary)] text-[var(--on-primary)]' : 'bg-[var(--tag)]'}`}>
            {m.text}
            {m.card?.type === 'package' && <div>{m.card.label}</div>}
          </div>
        ))}
      </div>
      <div className="flex flex-wrap gap-1 p-2">
        <Chip onClick={() => sendCard('th_pt_01', 'pt', { type: 'package', packageId: me.packages[3].id, label: `${me.packages[3].name} · ${vnd(me.packages[3].priceVnd)} · ${me.packages[3].perWeek} buổi/tuần` }, 'Xem gói')}>
          Gửi gói tập
        </Chip>
        <Chip onClick={() => sendCard('th_pt_01', 'pt', { type: 'schedule', text: 'Lịch 18:00 T2/T4/T6' })}>Gửi lịch</Chip>
      </div>
      <form
        className="flex gap-2 p-3"
        onSubmit={(e) => {
          e.preventDefault();
          if (t.trim()) sendText('th_pt_01', 'pt', t.trim());
          setT('');
        }}
      >
        <input className="flex-1 rounded-full bg-[var(--tag)] px-3" value={t} onChange={(e) => setT(e.target.value)} />
        <Button>Gửi</Button>
      </form>
    </Screen>
  );
}

export function PI1() {
  const [tab, setTab] = useState<'over' | 'tx' | 'wd'>('over');
  const ledger = useAppStore((s) => s.ledger);
  const mc = moneyCheck(useAppStore.getState());
  const jump = useAppStore((s) => s.jump);
  const features = useAppStore((s) => s.features);
  return (
    <Screen title="Thu nhập" padNav>
      <div className="flex gap-2 px-4">
        <Chip selected={tab === 'over'} onClick={() => setTab('over')}>Tổng quan</Chip>
        <Chip selected={tab === 'tx'} onClick={() => setTab('tx')}>Giao dịch</Chip>
        <Chip selected={tab === 'wd'} onClick={() => setTab('wd')}>Rút tiền</Chip>
      </div>
      {tab === 'over' && (
        <div className="p-4 space-y-3">
          <div className="app-card p-3">Có thể rút {vnd(mc.withdrawable)} <Button variant="text" onClick={() => jump('pt', { id: 'PI3' })}>Rút tiền</Button></div>
          <div className="app-card p-3">App đang giữ {vnd(mc.held)}</div>
          <div className="app-card p-3">Đang xử lý {vnd(mc.processing)}</div>
          <p className="type-caption">Khách thanh toán → App giữ → Buổi xong → Đối soát {useAppStore.getState().business.payout_hold_days} ngày → Có thể rút.</p>
          {features.monetization && <div className="type-caption">Boost đã chi: 0đ (minh hoạ)</div>}
        </div>
      )}
      {tab === 'tx' && (
        <div className="p-4">
          {ledger.map((l) => (
            <button key={l.id} type="button" className="flex w-full justify-between py-2 text-left" onClick={() => jump('pt', { id: 'PI2', params: { txId: l.id } })}>
              <span>{l.userName} · {l.status}</span>
              <span>{vnd(l.net)}</span>
            </button>
          ))}
        </div>
      )}
      {tab === 'wd' && <PI3 />}
    </Screen>
  );
}

export function PI2({ params }: { params?: Record<string, string> }) {
  const l = useAppStore((s) => s.ledger.find((x) => x.id === params?.txId) ?? s.ledger[0]);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Chi tiết giao dịch" onBack={() => pop('pt')}>
      <div className="p-4 space-y-2">
        <div>{vnd(l.amount)} · phí {vnd(l.fee)} · thực nhận {vnd(l.net)}</div>
        <div>Trạng thái: {l.status}</div>
        <ol className="list-decimal pl-5">
          <li>Khách thanh toán</li>
          <li>App giữ</li>
          <li>Buổi hoàn thành</li>
          <li>Đối soát → Có thể rút</li>
        </ol>
      </div>
    </Screen>
  );
}

export function PI3() {
  const mc = moneyCheck(useAppStore.getState());
  const withdraw = useAppStore((s) => s.withdraw);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Rút tiền" onBack={() => pop('pt')}>
      <div className="p-4 space-y-3">
        <div>Số dư {vnd(mc.withdrawable)}</div>
        <div>Vietcombank •••• 1234</div>
        <Button onClick={() => withdraw(mc.withdrawable)}>Rút tất cả</Button>
      </div>
    </Screen>
  );
}

export function PM1() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const jump = useAppStore((s) => s.jump);
  const setAccepting = useAppStore((s) => s.setAccepting);
  const items = [
    ['PM2', 'Thông tin hồ sơ'],
    ['PM3', 'Chứng chỉ'],
    ['PM4', 'Gói tập & giá'],
    ['PM5', 'Lịch làm việc'],
    ['PM6', 'Khu vực & vị trí'],
    ['PM7', 'Ảnh hồ sơ'],
    ['PM8', 'Cấp PT & quyền lợi'],
    ['PM9', 'Thống kê hồ sơ'],
    ['PM10', 'Boost / Nổi bật'],
  ] as const;
  return (
    <Screen padNav>
      <div className="p-4">
        <img src={me.cover} alt="" className="h-28 w-full rounded object-cover" />
        <div className="-mt-8 flex items-end gap-3 px-2">
          <img src={me.avatar} alt="" className="h-16 w-16 rounded-full border-2 border-white object-cover" />
          <div>
            <div className="font-bold">{me.name}</div>
            <div className="type-caption">{me.badge} · Uy tín {me.trust}</div>
          </div>
        </div>
        <button type="button" className="mt-3" onClick={() => setAccepting(!me.accepting)}>
          {me.accepting ? 'Đang nhận khách' : 'Tạm ngưng'}
        </button>
        <Button variant="text" onClick={() => jump('user', { id: 'UP1', params: { ptId: 'pt_01' } })}>
          Xem hồ sơ như khách hàng
        </Button>
        <div className="mt-3 space-y-1">
          {items.map(([id, label]) => (
            <button key={id} type="button" className="flex w-full justify-between py-3" onClick={() => jump('pt', { id })}>
              {label} ›
            </button>
          ))}
        </div>
      </div>
    </Screen>
  );
}

export function PM2() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const updatePt = useAppStore((s) => s.updatePt);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Thông tin hồ sơ" onBack={() => pop('pt')}>
      <div className="p-4 space-y-2">
        <textarea className="w-full rounded-lg bg-[var(--tag)] p-2" defaultValue={me.bio} onBlur={(e) => updatePt('pt_01', { bio: e.target.value, intro: e.target.value })} />
        <Button onClick={() => pop('pt')}>Lưu</Button>
      </div>
    </Screen>
  );
}

export function PM3() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Chứng chỉ" onBack={() => pop('pt')}>
      <div className="p-4">
        {me.certs.map((c) => (
          <div key={c.name} className="app-card mb-2 p-3">{c.name} · {c.status}</div>
        ))}
      </div>
    </Screen>
  );
}

export function PM4() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const updatePt = useAppStore((s) => s.updatePt);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Gói tập & giá" onBack={() => pop('pt')}>
      <div className="p-4">
        {me.packages.map((p) => (
          <div key={p.id} className="app-card mb-2 flex justify-between p-3">
            <span>{p.name} · {p.sessions} buổi/{p.perWeek} tuần</span>
            <input
              className="w-28 bg-transparent text-right"
              defaultValue={p.priceVnd}
              onBlur={(e) =>
                updatePt('pt_01', {
                  packages: me.packages.map((x) =>
                    x.id === p.id ? { ...x, priceVnd: Number(e.target.value) } : x,
                  ),
                  priceFrom: me.packages.find((x) => x.sessions === 1)?.priceVnd ?? me.priceFrom,
                })
              }
            />
          </div>
        ))}
        <p className="type-caption">Không xoá được gói 1 buổi.</p>
      </div>
    </Screen>
  );
}

export function PM5() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Lịch làm việc" onBack={() => pop('pt')}>
      <div className="p-4">
        {me.slots.slice(0, 12).map((sl, i) => (
          <div key={i} className="py-1">T{sl.weekday + 1} {sl.start}–{sl.end}</div>
        ))}
      </div>
    </Screen>
  );
}

export function PM6() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const updatePt = useAppStore((s) => s.updatePt);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Khu vực & vị trí" onBack={() => pop('pt')}>
      <div className="p-4 space-y-2">
        <div>{me.area}</div>
        <label>
          Bán kính km
          <input
            type="number"
            defaultValue={me.radiusKm}
            className="ml-2 w-20 bg-[var(--tag)] px-2"
            onBlur={(e) => updatePt('pt_01', { radiusKm: Number(e.target.value) })}
          />
        </label>
        <p className="type-caption">Kéo ghim: dùng lat/lng demo. Marker User Map cập nhật theo vị trí này.</p>
        <Button
          onClick={() => updatePt('pt_01', { lat: me.lat + 0.002, lng: me.lng + 0.002 })}
        >
          Dịch ghim +200m
        </Button>
      </div>
    </Screen>
  );
}

export function PM7() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const now = useNow();
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Ảnh hồ sơ" onBack={() => pop('pt')}>
      <div className="grid grid-cols-2 gap-2 p-3">
        {me.album.map((p) => {
          const days = Math.ceil((p.expiresAt - now) / 86400000);
          return (
            <div key={p.id} className="relative">
              <img src={p.url} alt="" className="h-32 w-full object-cover rounded" />
              <div className="type-caption">{p.status} · {days > 0 ? `còn ${days} ngày` : 'hết hạn'}</div>
            </div>
          );
        })}
      </div>
    </Screen>
  );
}

export function PM8() {
  const pop = useAppStore((s) => s.pop);
  const cfg = useAppStore((s) => s.business);
  return (
    <Screen title="Cấp PT" onBack={() => pop('pt')}>
      <div className="p-4 space-y-2">
        {(['bronze', 'silver', 'gold', 'platinum'] as const).map((t) => (
          <div
            key={t}
            className="app-card p-3"
            style={{ boxShadow: `inset 0 0 0 2px var(--tier-${t})` }}
          >
            {cfg.tier_names[t]} · phí {cfg.fee_pct[t]}%
          </div>
        ))}
      </div>
    </Screen>
  );
}

export function PM9() {
  const visitsAll = useAppStore((s) => s.visits);
  const visits = visitsAll.filter((v) => v.ptId === 'pt_01');
  const now = useNow();
  const minRevisit = useAppStore((s) => s.business.quick_action_revisit);
  const days = useAppStore((s) => s.business.quick_action_days);
  const leads = interestedLeads(visitsAll, 'pt_01', minRevisit, days, now);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Thống kê hồ sơ" onBack={() => pop('pt')}>
      <div className="p-4 grid grid-cols-2 gap-2">
        <div className="app-card p-3">Hiện Discovery 120</div>
        <div className="app-card p-3">Mở hồ sơ {visits.length}</div>
        <div className="app-card p-3">Quay lại {Math.max(0, visits.length - leads.length)}</div>
        <div className="app-card p-3">Khách quan tâm {leads.length}</div>
      </div>
    </Screen>
  );
}

export function PM10() {
  const features = useAppStore((s) => s.features);
  const pop = useAppStore((s) => s.pop);
  if (!features.monetization) return <Screen title="Boost" onBack={() => pop('pt')}><p className="p-4">Tắt monetization.</p></Screen>;
  return (
    <Screen title="Boost" onBack={() => pop('pt')}>
      <div className="p-4 space-y-2">
        <p>Boost chỉ tăng lượt hiển thị, không ảnh hưởng đánh giá, Uy tín hay cấp bậc.</p>
        <div className="app-card p-3">Boost hồ sơ 7 ngày · 199.000đ minh hoạ</div>
      </div>
    </Screen>
  );
}

export function PN1() {
  const notisAll = useAppStore((s) => s.notis);
  const notis = notisAll.filter((n) => n.role === 'pt');
  const pop = useAppStore((s) => s.pop);
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Thông báo" onBack={() => pop('pt')}>
      <div className="p-4">
        {notis.map((n) => (
          <button key={n.id} type="button" className="app-card mb-2 w-full p-3 text-left" onClick={() => jump('pt', { id: n.screen, params: n.params })}>
            <div className="font-semibold">{n.title}</div>
            <div>{n.body}</div>
          </button>
        ))}
      </div>
    </Screen>
  );
}

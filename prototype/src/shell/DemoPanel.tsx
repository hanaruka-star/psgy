import { useMemo, useState } from 'react';
import { featureLabels, type FeatureFlags } from '@/config/features';
import { brand } from '@/config/brand';
import { screens } from '@/screens/registry';
import { moneyCheck, useAppStore } from '@/store/appStore';
import type { ClockJump } from '@/store/clock';
import type { Role } from '@/domain/types';
import { vnd } from '@/lib/format';

export function DemoPanel({ compact }: { compact?: boolean }) {
  const mobileRole = useAppStore((s) => s.mobileRole);
  const setMobileRole = useAppStore((s) => s.setMobileRole);
  const jump = useAppStore((s) => s.jump);
  const setTab = useAppStore((s) => s.setTab);
  const clockJump = useAppStore((s) => s.clockJump);
  const features = useAppStore((s) => s.features);
  const setFeature = useAppStore((s) => s.setFeature);
  const biz = useAppStore((s) => s.business);
  const setBusiness = useAppStore((s) => s.setBusiness);
  const reset = useAppStore((s) => s.reset);
  const skipOnboarding = useAppStore((s) => s.skipOnboarding);
  const rerunOnboarding = useAppStore((s) => s.rerunOnboarding);
  const rankingWhy = useAppStore((s) => s.rankingWhy);
  const setRankingWhy = useAppStore((s) => s.setRankingWhy);
  const commit = useAppStore((s) => s.commit);
  const emptyWallet = useAppStore((s) => s.emptyWallet);
  const forceLast = useAppStore((s) => s.forceLastSession);
  const muteTimedPopups = useAppStore((s) => s.muteTimedPopups);
  const frozenNow = useAppStore((s) => s.frozenNow);
  const offsetMs = useAppStore((s) => s.offsetMs);
  const ledger = useAppStore((s) => s.ledger);
  const walletTx = useAppStore((s) => s.walletTx);
  const withdrawn = useAppStore((s) => s.withdrawn);
  const now = (frozenNow ?? Date.now()) + offsetMs;
  const mc = moneyCheck({ ...useAppStore.getState(), ledger, walletTx, withdrawn });
  const [q, setQ] = useState('');
  const [tab, setUi] = useState<'nav' | 'time' | 'cfg'>('nav');

  const users = useMemo(
    () => screens.filter((s) => s.role === 'user' && s.id.toLowerCase().includes(q.toLowerCase()) || (s.role === 'user' && s.name.toLowerCase().includes(q.toLowerCase()))),
    [q],
  );
  const pts = useMemo(
    () => screens.filter((s) => s.role === 'pt' && (s.id.toLowerCase().includes(q.toLowerCase()) || s.name.toLowerCase().includes(q.toLowerCase()))),
    [q],
  );

  const go = (id: string, role: Role) => {
    if (role === 'user' && ['UD1', 'UM1', 'UC1', 'UCA1', 'UPF1'].includes(id)) setTab('user', id);
    else if (role === 'pt' && ['PO1', 'PW1', 'PC1', 'PI1', 'PM1'].includes(id)) setTab('pt', id);
    else jump(role, { id });
    if (compact) setMobileRole(role);
  };

  const proxy = useAppStore.getState();
  const ss = proxy.sessions.find((s) => s.id === 'ss_today') ?? proxy.sessions[0];
  const pending = proxy.contracts.find((c) => c.status === 'pending');

  return (
    <aside
      className={`flex flex-col overflow-hidden rounded-2xl border border-white/10 bg-slate-900/90 text-slate-100 ${
        compact ? 'h-full max-h-[80dvh] w-[min(360px,92vw)]' : 'h-[844px] w-[320px]'
      }`}
    >
      <div className="border-b border-white/10 px-4 py-3">
        <div className="text-[11px] font-bold uppercase tracking-wider text-sky-300">Bảng điều khiển</div>
        <div className="text-lg font-bold">{brand.appName}</div>
        <div className="type-caption text-slate-400">{new Date(now).toLocaleString('vi')}</div>
        <div className="mt-2 grid grid-cols-3 gap-1 rounded-lg bg-white/5 p-1">
          {(['nav', 'time', 'cfg'] as const).map((t) => (
            <button key={t} type="button" className={`rounded py-1 text-[11px] ${tab === t ? 'bg-sky-500 text-slate-950' : ''}`} onClick={() => setUi(t)}>
              {t === 'nav' ? 'Màn' : t === 'time' ? 'Tua giờ' : 'Config'}
            </button>
          ))}
        </div>
      </div>
      <div className="no-scrollbar flex-1 overflow-y-auto p-3 text-[12px]">
        {tab === 'nav' && (
          <>
            <div className="mb-2 grid grid-cols-2 gap-1">
              <Btn active={mobileRole === 'user'} onClick={() => setMobileRole('user')}>User</Btn>
              <Btn active={mobileRole === 'pt'} onClick={() => setMobileRole('pt')}>PT Center</Btn>
            </div>
            <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Tìm mã…" className="mb-2 w-full rounded bg-slate-800 px-2 py-1" />
            <div className="mb-1 font-bold text-slate-400">User</div>
            {users.map((s) => (
              <button key={s.id} type="button" className="flex w-full gap-2 py-1 text-left" onClick={() => go(s.id, 'user')}>
                <span className="font-mono text-sky-300">{s.id}</span>
                <span>{s.name}</span>
              </button>
            ))}
            <div className="mb-1 mt-3 font-bold text-slate-400">PT Center</div>
            {pts.map((s) => (
              <button key={s.id} type="button" className="flex w-full gap-2 py-1 text-left" onClick={() => go(s.id, 'pt')}>
                <span className="font-mono text-violet-300">{s.id}</span>
                <span>{s.name}</span>
              </button>
            ))}
          </>
        )}
        {tab === 'time' && (
          <div className="space-y-2">
            {(
              [
                ['plus15', '+15 phút'],
                ['plus60', '+1 giờ'],
                ['remain60', 'Còn 60 phút'],
                ['atTime', 'Đến giờ hẹn'],
                ['plus15after', '+15 phút sau giờ hẹn'],
                ['late8', 'Đến giờ +8 phút (trễ)'],
                ['plus24h', '+24 giờ'],
                ['plus3d', '+3 ngày đối soát'],
                ['real', 'Về giờ thật'],
              ] as [ClockJump, string][]
            ).map(([k, l]) => (
              <button key={k} type="button" className="w-full rounded bg-white/10 py-2" onClick={() => clockJump(k)}>
                {l}
              </button>
            ))}
            <div className="h-px bg-white/10" />
            <button
              type="button"
              className={`w-full rounded py-2 ${muteTimedPopups ? 'bg-amber-400 text-slate-950' : 'bg-white/10'}`}
              onClick={() => commit({ muteTimedPopups: !muteTimedPopups })}
            >
              Tạm tắt popup thời điểm: {muteTimedPopups ? 'đang tắt' : 'đang bật'}
            </button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().openPt('pt_01')}>User xem lại hồ sơ PT Long</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => commit({ aiTrialLeftDays: 0 })}>Hết dùng thử AI</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => setRankingWhy(!rankingWhy)}>Hiện lý do xếp hạng: {rankingWhy ? 'bật' : 'tắt'}</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={skipOnboarding}>Bỏ qua onboarding</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={rerunOnboarding}>Chạy lại onboarding</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={emptyWallet}>Ví hết tiền</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => commit({ ptPendingApproval: true })}>PT chờ duyệt</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={forceLast}>Buổi cuối gói</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => ss && useAppStore.getState().cancelSession(ss.id, 'pt', 'PT bận')}>PT huỷ buổi</button>
            <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => ss && useAppStore.getState().reportNoShowPt(ss.id)}>PT không đến</button>
            <div className="font-bold text-slate-400">Thao tác thay (1 điện thoại)</div>
            {pending && <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().confirmContract(pending.id)}>PT xác nhận HĐ</button>}
            {pending && <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().rejectContract(pending.id)}>PT từ chối HĐ</button>}
            {ss && (
              <>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().arrive(ss.id)}>Tôi đã đến</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().startByPhoto(ss.id)}>Chụp hình bắt đầu</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().requestStart(ss.id)}>Gửi yêu cầu bắt đầu</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().submitSummary(ss.id, { actualMin: 58, muscles: ['Ngực'], progress: 'up', nextNote: 'Tăng tạ' })}>Kết thúc</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => useAppStore.getState().sendGreeting('Chào Minh, mình có thể kèm bạn 3 buổi/tuần.')}>Gửi lời chào</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => {
                  const p = useAppStore.getState().pts.find((x) => x.id === 'pt_01')!.packages[3];
                  useAppStore.getState().sendCard('th_pt_01', 'pt', { type: 'package', packageId: p.id, label: `${p.name} · ${vnd(p.priceVnd)}` }, 'Xem gói');
                }}>Gửi thẻ gói</button>
                <button type="button" className="w-full rounded bg-white/10 py-2" onClick={() => {
                  const g = useAppStore.getState().greetings[0];
                  if (g) useAppStore.getState().answerGreeting(g.id, true);
                }}>User chấp nhận lời chào</button>
              </>
            )}
          </div>
        )}
        {tab === 'cfg' && (
          <div className="space-y-2">
            {(Object.keys(featureLabels) as (keyof FeatureFlags)[]).map((k) => (
              <label key={k} className="flex justify-between gap-2">
                <span>{featureLabels[k]}</span>
                <input type="checkbox" checked={features[k]} onChange={(e) => setFeature(k, e.target.checked)} />
              </label>
            ))}
            {(['media_expire_days', 'upcoming_window', 'no_show_after', 'payout_hold_days', 'pt_response_timeout'] as const).map((k) => (
              <label key={k} className="flex justify-between">
                {k}
                <input
                  type="number"
                  className="w-20 bg-slate-800 px-1"
                  value={biz[k]}
                  onChange={(e) => setBusiness({ [k]: Number(e.target.value) })}
                />
              </label>
            ))}
            <div className={`mt-3 rounded-lg p-3 ${mc.ok ? 'bg-emerald-900/50' : 'bg-red-900/40'}`}>
              <div className="font-bold">Đối soát {mc.ok ? '✓' : '✗'}</div>
              <div>User trả {vnd(mc.paid)}</div>
              <div>Giữ {vnd(mc.held)} · XL {vnd(mc.processing)}</div>
              <div>Rút được {vnd(mc.withdrawable)} · Đã rút {vnd(mc.withdrawn)}</div>
              <div>Phí {vnd(mc.fee)} · Hoàn {vnd(mc.refunded)}</div>
              <div>Tổng phải = {vnd(mc.right)}</div>
            </div>
            <button type="button" className="mt-2 w-full rounded bg-white/10 py-2" onClick={reset}>Reset dữ liệu</button>
          </div>
        )}
      </div>
    </aside>
  );
}

function Btn({ active, onClick, children }: { active: boolean; onClick: () => void; children: string }) {
  return (
    <button type="button" onClick={onClick} className={`rounded py-2 text-[12px] font-semibold ${active ? 'bg-sky-500 text-slate-950' : 'bg-white/10'}`}>
      {children}
    </button>
  );
}

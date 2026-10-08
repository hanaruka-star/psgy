import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { atFull, atTime, minutesBetween, vnd } from '@/lib/format';
import { moneyCheck, sessionView, useAppStore, useNow } from '@/store/appStore';
import { useState } from 'react';

export function PO1() {
  const me = useAppStore((s) => s.pts.find((p) => p.id === 'pt_01')!);
  const allSessions = useAppStore((s) => s.sessions);
  const sessions = allSessions.filter((x) => x.ptId === 'pt_01');
  const now = useNow();
  const cfg = useAppStore((s) => s.business);
  const visits = useAppStore((s) => s.visits);
  const contracts = useAppStore((s) => s.contracts);
  const pendingCt = contracts.filter((c) => c.status === 'pending' && c.ptId === 'pt_01');
  const setAccepting = useAppStore((s) => s.setAccepting);
  const jump = useAppStore((s) => s.jump);
  const sendGreeting = useAppStore((s) => s.sendGreeting);
  const today = sessions.filter((s) => {
    const d = new Date(s.startAt);
    const n = new Date(now);
    return d.toDateString() === n.toDateString();
  });
  const interest = visits.filter((v) => v.ptId === 'pt_01').length >= useAppStore.getState().business.quick_action_revisit;
  const mc = moneyCheck(useAppStore.getState());
  return (
    <Screen padNav>
      <div className="bg-[#1a1a1a] px-4 py-4 text-white">
        <div className="flex justify-between">
          <div className="flex gap-3">
            <img src={me.avatar} alt="" className="h-14 w-14 rounded-full object-cover" />
            <div>
              <div className="font-bold">{me.name} ✎</div>
              <div className="type-caption">GOLD PT · ★ {me.stars.toFixed(1)}</div>
            </div>
          </div>
          <button type="button" onClick={() => jump('pt', { id: 'PN1' })}>🔔</button>
        </div>
        <button type="button" className="mt-2 rounded-full bg-white/10 px-3 py-1" onClick={() => setAccepting(!me.accepting)}>
          {me.accepting ? 'Đang nhận khách ▾' : 'Tạm ngưng'}
        </button>
        <div className="mt-3 flex gap-2 type-caption">
          <span onClick={() => jump('pt', { id: 'PM1' })}>Sửa profile</span>
          <span onClick={() => jump('pt', { id: 'PM7' })}>Đăng ảnh</span>
          <span onClick={() => jump('pt', { id: 'PM5' })}>Lịch dạy</span>
          <span onClick={() => jump('pt', { id: 'PC1' })}>Tin nhắn</span>
        </div>
      </div>
      <div className="p-4 space-y-3">
        <div className="flex justify-between">
          <span className="font-bold">Hôm nay</span>
          <button type="button" onClick={() => jump('pt', { id: 'PW1' })}>Xem toàn bộ</button>
        </div>
        {today.map((s) => (
          <button key={s.id} type="button" className="app-card w-full p-3 text-left" onClick={() => jump('pt', { id: 'PSD1', params: { sessionId: s.id } })}>
            {atTime(s.startAt)} · {s.userName} · Buổi {s.index}/{s.total} · {s.locationLabel}
            <div className="type-caption">{String(sessionView(s, now, cfg))}</div>
          </button>
        ))}
        <div className="grid grid-cols-2 gap-2">
          <div className="app-card p-3">Chờ phản hồi {pendingCt.length}</div>
          <div className="app-card p-3">Đổi lịch {sessions.filter((s) => s.proposedStartAt).length}</div>
          <div className="app-card p-3">Xác nhận hoàn thành {sessions.filter((s) => s.status === 'awaitingUserComplete').length}</div>
          <div className="app-card p-3">Hợp đồng {pendingCt.length}</div>
        </div>
        {interest && (
          <div className="app-card p-3">
            Minh vừa xem lại hồ sơ của bạn lần thứ 2
            <Button className="mt-2" onClick={() => sendGreeting(`Chào ${'Minh'}, mình là Long — mình có thể giúp lịch tập giảm mỡ 3 buổi/tuần.`)}>
              Chào hỏi
            </Button>
          </div>
        )}
        <div className="app-card p-3">
          <div>Có thể rút {vnd(mc.withdrawable)}</div>
          <div className="type-caption">App đang giữ {vnd(mc.held)} · Đang xử lý {vnd(mc.processing)}</div>
          <Button variant="text" onClick={() => jump('pt', { id: 'PI3' })}>Rút tiền</Button>
        </div>
        <div className="app-card p-3">GOLD PT · Còn 7 buổi để lên PLATINUM</div>
        <div className="grid grid-cols-2 gap-2">
          <div className="app-card p-3">Buổi dạy 18</div>
          <div className="app-card p-3">Khách đang tập 4</div>
        </div>
      </div>
    </Screen>
  );
}

export function PW1() {
  const [tab, setTab] = useState<'today' | 'soon' | 'todo'>('today');
  const [cal, setCal] = useState<'list' | 'month' | 'week' | 'day'>('list');
  const [filter, setFilter] = useState(false);
  const [status, setStatus] = useState('all');
  const allSessions = useAppStore((s) => s.sessions);
  const sessions = allSessions.filter((x) => x.ptId === 'pt_01');
  const contracts = useAppStore((s) => s.contracts);
  const pending = contracts.filter((c) => c.status === 'pending');
  const now = useNow();
  const jump = useAppStore((s) => s.jump);
  const today = sessions.filter((s) => new Date(s.startAt).toDateString() === new Date(now).toDateString());
  const filtered = sessions.filter((s) => status === 'all' || s.status === status);
  return (
    <Screen
      title="Công việc"
      padNav
      actions={
        <div className="flex gap-1">
          <button type="button" onClick={() => setCal((c) => (c === 'list' ? 'month' : 'list'))}>📅</button>
          <button type="button" onClick={() => setFilter((v) => !v)}>⚙</button>
        </div>
      }
    >
      <div className="flex gap-2 px-4">
        <Chip selected={tab === 'today'} onClick={() => setTab('today')}>Hôm nay</Chip>
        <Chip selected={tab === 'soon'} onClick={() => setTab('soon')}>Sắp tới</Chip>
        <Chip selected={tab === 'todo'} onClick={() => setTab('todo')}>Cần xử lý</Chip>
      </div>
      {filter && (
        <div className="mx-4 mt-2 app-card p-3">
          <div className="font-semibold mb-2">Bộ lọc</div>
          {['all', 'scheduled', 'training', 'awaitingUserComplete', 'completed', 'cancelled'].map((st) => (
            <Chip key={st} selected={status === st} onClick={() => setStatus(st)} className="mr-1 mb-1">
              {st === 'all' ? 'Tất cả' : st}
            </Chip>
          ))}
          <Button variant="text" onClick={() => { setStatus('all'); setFilter(false); }}>Đặt lại</Button>
        </div>
      )}
      {cal !== 'list' && (
        <div className="flex gap-2 px-4 pt-2">
          {(['month', 'week', 'day'] as const).map((v) => (
            <Chip key={v} selected={cal === v} onClick={() => setCal(v)}>
              {v === 'month' ? 'Tháng' : v === 'week' ? 'Tuần' : 'Ngày'}
            </Chip>
          ))}
        </div>
      )}
      {cal === 'month' && (
        <div className="grid grid-cols-7 gap-1 p-4 text-center type-caption">
          {Array.from({ length: 30 }, (_, i) => {
            const d = new Date(now);
            d.setDate(i + 1);
            const has = sessions.some((s) => new Date(s.startAt).getDate() === i + 1);
            return (
              <div key={i} className={`rounded py-2 ${has ? 'bg-[var(--primary-container)]' : 'bg-[var(--tag)]'}`}>
                {i + 1}
              </div>
            );
          })}
        </div>
      )}
      <div className="p-4 space-y-2">
        {tab === 'today' &&
          today.map((s) => (
            <button key={s.id} type="button" className="app-card w-full p-3 text-left" onClick={() => jump('pt', { id: 'PSD1', params: { sessionId: s.id } })}>
              {atTime(s.startAt)} · {s.userName} · Buổi {s.index}/{s.total}
              <div className="type-caption">{s.status} · {s.locationLabel}</div>
            </button>
          ))}
        {tab === 'soon' && (
          <>
            <div className="type-caption">Tuần này / Tuần sau</div>
            {filtered.filter((s) => s.startAt > now).map((s) => (
              <button key={s.id} type="button" className="app-card w-full p-3 text-left" onClick={() => jump('pt', { id: 'PSD1', params: { sessionId: s.id } })}>
                {atFull(s.startAt)} · {s.userName}
              </button>
            ))}
          </>
        )}
        {tab === 'todo' && (
          <>
            {pending.map((c) => (
              <div key={c.id} className="app-card p-3">
                Hợp đồng mới chờ xác nhận · {c.packageName}
                <div className="mt-2 flex gap-2">
                  <Button onClick={() => useAppStore.getState().confirmContract(c.id)}>Xác nhận</Button>
                  <Button variant="outline" onClick={() => useAppStore.getState().rejectContract(c.id)}>Từ chối</Button>
                </div>
              </div>
            ))}
            {sessions.filter((s) => s.proposedStartAt).map((s) => (
              <div key={s.id} className="app-card p-3">
                Yêu cầu đổi lịch · {s.userName}
                <div className="mt-2 flex gap-2">
                  <Button variant="outline" onClick={() => useAppStore.getState().answerReschedule(s.id, false)}>Từ chối</Button>
                  <Button onClick={() => useAppStore.getState().answerReschedule(s.id, true)}>Đồng ý</Button>
                </div>
              </div>
            ))}
            {sessions.filter((s) => s.status === 'awaitingUserComplete').map((s) => (
              <button key={s.id} type="button" className="app-card w-full p-3 text-left" onClick={() => jump('pt', { id: 'PSD1', params: { sessionId: s.id } })}>
                Buổi cần xác nhận hoàn thành · {s.userName}
              </button>
            ))}
          </>
        )}
      </div>
    </Screen>
  );
}

export function PSD1({ params }: { params?: Record<string, string> }) {
  const s = useAppStore((st) => st.sessions.find((x) => x.id === (params?.sessionId ?? 'ss_today')) ?? st.sessions[0]);
  const now = useNow();
  const pop = useAppStore((st) => st.pop);
  const jump = useAppStore((st) => st.jump);
  const remain = minutesBetween(now, s.startAt);
  const arrived = Boolean(s.arrivedAt);
  const [cam, setCam] = useState(false);
  const [menu, setMenu] = useState(false);
  if (cam) {
    return (
      <Screen title="Chụp hình bắt đầu" onBack={() => setCam(false)}>
        <div className="p-4">
          <div className="relative h-72 overflow-hidden rounded-[var(--radius-lg)] bg-black">
            <img src="/assets/journal/gym-01.jpg" alt="" className="h-full w-full object-cover opacity-80" />
            <div className="absolute inset-10 rounded-full border-2 border-white/70" />
          </div>
          <Button
            className="mt-4"
            block
            onClick={() => {
              useAppStore.getState().startByPhoto(s.id);
              setCam(false);
            }}
          >
            Chụp
          </Button>
        </div>
      </Screen>
    );
  }
  return (
    <Screen
      title="Chi tiết buổi"
      onBack={() => pop('pt')}
      actions={<button type="button" onClick={() => setMenu((v) => !v)}>⋮</button>}
    >
      <div className="p-4 space-y-3">
        <Chip>{s.status}</Chip>
        <div>{remain > 0 ? `Còn ${remain} phút` : arrived ? (s.lateMin ? `Bạn đến trễ ${s.lateMin} phút.` : 'Bạn đã đến địa điểm tập.') : 'Đã đến giờ'}</div>
        <div className="type-title">{atFull(s.startAt)}</div>
        <div>{s.userName} · Buổi {s.index}/{s.total}</div>
        <div className="flex flex-wrap gap-2">
          <Chip onClick={() => jump('pt', { id: 'PC2', params: { threadId: 'th_pt_01' } })}>Nhắn tin</Chip>
          <Chip>Gọi điện</Chip>
          <Chip onClick={() => jump('pt', { id: 'PW1' })}>Đổi lịch</Chip>
          <Chip onClick={() => jump('pt', { id: 'PI1' })}>Xem hợp đồng</Chip>
        </div>
        <div className="app-card p-3">
          {s.locationLabel}
          <div className="mt-2 h-24 rounded bg-[var(--tag)] grid place-items-center type-caption">Bản đồ nhỏ</div>
        </div>
        {menu && (
          <div className="app-card p-3 type-caption space-y-1">
            <div>Thao tác nhanh: Nhắn tin · Gọi · Đổi lịch · Gửi địa điểm · Ghi chú · Huỷ buổi</div>
          </div>
        )}
        {!arrived && s.status === 'scheduled' && (
          <Button onClick={() => useAppStore.getState().arrive(s.id)}>Tôi đã đến</Button>
        )}
        {arrived && s.status === 'scheduled' && (
          <>
            {s.lateMin ? (
              <div className="app-card p-3">Bạn đến trễ {s.lateMin} phút. User đã được thông báo.</div>
            ) : (
              <div className="app-card p-3">Bạn đã đến địa điểm tập.</div>
            )}
            <Button onClick={() => setCam(true)}>Chụp hình với học viên</Button>
            <Button variant="outline" onClick={() => useAppStore.getState().requestStart(s.id)}>
              Gửi yêu cầu xác nhận
            </Button>
          </>
        )}
        {s.status === 'training' && (
          <>
            <div className="app-card p-3">Đang tập · đồng hồ chạy · {s.startPhoto ? 'Đã lưu ảnh bắt đầu' : ''}</div>
            <Button onClick={() => jump('pt', { id: 'PSE1', params: { sessionId: s.id } })}>Kết thúc buổi tập</Button>
          </>
        )}
        {now - s.startAt > 15 * 60000 && s.status === 'scheduled' && (
          <Button variant="outline" onClick={() => useAppStore.getState().reportNoShowUser(s.id)}>
            Báo User không đến
          </Button>
        )}
      </div>
    </Screen>
  );
}

export function PSE1({ params }: { params?: Record<string, string> }) {
  const id = params?.sessionId ?? 'ss_today';
  const pop = useAppStore((s) => s.pop);
  const [muscles, setM] = useState<string[]>(['Ngực']);
  const groups = ['Ngực', 'Lưng', 'Chân', 'Vai', 'Tay', 'Bụng', 'Cardio', 'Toàn thân'];
  return (
    <Screen title="Tổng kết buổi tập" onBack={() => pop('pt')}>
      <div className="p-4 space-y-3">
        <div>Thời lượng thực tế 58 phút</div>
        <div className="flex flex-wrap gap-1">
          {groups.map((g) => (
            <Chip key={g} selected={muscles.includes(g)} onClick={() => setM((x) => (x.includes(g) ? x.filter((i) => i !== g) : [...x, g]))}>
              {g}
            </Chip>
          ))}
        </div>
        <textarea className="w-full rounded-lg bg-[var(--tag)] p-2" defaultValue="Ghi chú buổi sau: tăng tạ nhẹ." />
        <Button
          block
          onClick={() => {
            useAppStore.getState().submitSummary(id, {
              actualMin: 58,
              muscles,
              progress: 'up',
              nextNote: 'Tăng tạ nhẹ buổi sau',
            });
            pop('pt');
          }}
        >
          Gửi tổng kết & kết thúc
        </Button>
      </div>
    </Screen>
  );
}

export function PL1() {
  const jump = useAppStore((s) => s.jump);
  const pending = useAppStore((s) => s.ptPendingApproval);
  return (
    <div className="flex h-full flex-col justify-end p-6">
      <h1 className="type-display mb-4">PT Center</h1>
      <Button block onClick={() => jump('pt', { id: pending ? 'PL2' : 'PO1' })}>
        Tiếp tục với Google
      </Button>
    </div>
  );
}

export function PL2() {
  return (
    <Screen title="Chờ duyệt">
      <div className="p-4 space-y-2">
        {['Ảnh đại diện ✓', 'Chứng chỉ', 'Gói tập ✓', 'Khu vực ✓', 'Tài khoản ngân hàng'].map((x) => (
          <div key={x} className="app-card p-3">{x}</div>
        ))}
        <p className="type-caption">Đội vận hành sẽ duyệt trong 1–2 ngày làm việc.</p>
      </div>
    </Screen>
  );
}

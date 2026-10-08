import { Button } from '@/components/Button';
import { Screen } from '@/components/Screen';
import { brand } from '@/config/brand';
import { vnd } from '@/lib/format';
import { useAppStore } from '@/store/appStore';
import { useState } from 'react';

export function UC1() {
  const threads = useAppStore((s) => s.threads);
  const greetingsAll = useAppStore((s) => s.greetings);
  const greetings = greetingsAll.filter((g) => g.status === 'pending');
  const pts = useAppStore((s) => s.pts);
  const features = useAppStore((s) => s.features);
  const jump = useAppStore((s) => s.jump);
  const answer = useAppStore((s) => s.answerGreeting);
  const ai = useAppStore((s) => s.features.aiAssistant);
  return (
    <Screen title="Chat" padNav>
      <div className="p-3 space-y-2">
        {ai && (
          <button
            type="button"
            className="app-card w-full p-3 text-left ring-1 ring-[var(--primary)]"
            onClick={() => jump('user', { id: 'UAI1' })}
          >
            <div className="font-bold">Trợ lý AI · Online</div>
            <div className="type-caption">Ghim đầu danh sách</div>
          </button>
        )}
        {greetings.map((g) => {
          const pt = pts.find((p) => p.id === g.ptId);
          return (
            <div key={g.id} className="app-card p-3">
              <div className="font-semibold">{pt?.name} muốn gửi lời chào</div>
              <p className="type-body">{g.text}</p>
              <div className="mt-2 flex gap-2">
                <Button onClick={() => answer(g.id, true)}>Chấp nhận</Button>
                <Button variant="outline" onClick={() => answer(g.id, false)}>
                  Bỏ qua
                </Button>
              </div>
            </div>
          );
        })}
        {threads
          .filter((t) => t.kind !== 'ai')
          .map((t) => (
            <button
              key={t.id}
              type="button"
              className="flex w-full items-center gap-3 p-2"
              onClick={() => jump('user', { id: 'UC2', params: { threadId: t.id } })}
            >
              <img src={t.avatar} alt="" className="h-12 w-12 rounded-full object-cover" />
              <div className="text-left">
                <div className="font-semibold">{t.peerName}</div>
                <div className="type-caption">Nhắn tin</div>
              </div>
            </button>
          ))}
        {features.monetization && (
          <div>
            <div className="type-caption mt-4">Đề xuất PT gần bạn · Được tài trợ</div>
            <div className="flex gap-2 overflow-x-auto">
              {pts.slice(0, 4).map((p) => (
                <div key={p.id} className="app-card w-28 p-2">
                  {p.name}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </Screen>
  );
}

export function UC2({ params }: { params?: Record<string, string> }) {
  const threadId = params?.threadId ?? 'th_pt_01';
  const messages = useAppStore((s) => s.messages);
  const msgs = messages.filter((m) => m.threadId === threadId);
  const sendText = useAppStore((s) => s.sendText);
  const startBooking = useAppStore((s) => s.startBooking);
  const pop = useAppStore((s) => s.pop);
  const [t, setT] = useState('');
  const ct = useAppStore((s) => s.contracts.find((c) => c.ptId === 'pt_01' && c.status !== 'cancelled'));
  return (
    <Screen title="Nguyễn Văn Long" onBack={() => pop('user')}>
      <div className="flex h-full flex-col">
        <div className="px-4 type-caption">{ct ? `${ct.packageName} · đã tập ${ct.done}` : ''}</div>
        <div className="no-scrollbar flex-1 space-y-2 overflow-y-auto p-3">
          {msgs.map((m) => {
            const packId = m.card?.type === 'package' ? m.card.packageId : undefined;
            return (
            <div
              key={m.id}
              className={`max-w-[80%] rounded-[var(--radius-md)] p-2 ${m.from === 'user' ? 'ml-auto bg-[var(--primary)] text-[var(--on-primary)]' : 'bg-[var(--tag)]'}`}
            >
              {m.text}
              {packId && (
                <Button className="mt-1" onClick={() => startBooking('pt_01', packId)}>
                  Xem gói
                </Button>
              )}
              {m.card?.type === 'booking' && <div className="type-caption">Booking · tự cập nhật</div>}
              {m.card?.type === 'contract' && <div>Hợp đồng</div>}
            </div>
            );
          })}
        </div>
        <form
          className="flex gap-2 p-3"
          onSubmit={(e) => {
            e.preventDefault();
            if (t.trim()) sendText(threadId, 'user', t.trim());
            setT('');
          }}
        >
          <input className="flex-1 rounded-full bg-[var(--tag)] px-3" value={t} onChange={(e) => setT(e.target.value)} />
          <Button>Gửi</Button>
        </form>
      </div>
    </Screen>
  );
}

export function UAI1() {
  const sendText = useAppStore((s) => s.sendText);
  const messages = useAppStore((s) => s.messages);
  const msgs = messages.filter((m) => m.threadId === 'th_ai');
  const features = useAppStore((s) => s.features);
  const trial = useAppStore((s) => s.aiTrialLeftDays);
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  const qs = ['Gợi ý bữa ăn hôm nay', 'Xem lịch tập hôm nay', 'Tư vấn bài tập', 'Hỏi về phục hồi'];
  return (
    <Screen title="Trợ lý AI · Online" onBack={() => pop('user')}>
      <div className="p-3 space-y-2">
        {msgs.map((m) => (
          <div key={m.id} className={`rounded-[var(--radius-md)] p-3 ${m.from === 'ai' ? 'bg-[var(--tag)]' : 'bg-[var(--primary-container)]'}`}>
            {m.text}
          </div>
        ))}
        {features.monetization && (
          <div className="app-card p-3">
            <div className="type-caption">Được tài trợ</div>
            <div>Gói protein XYZ — giá minh hoạ 390.000đ</div>
          </div>
        )}
        <div className="flex flex-wrap gap-1">
          {qs.map((q) => (
            <button key={q} type="button" className="rounded-full bg-[var(--tag)] px-3 py-1 type-caption" onClick={() => sendText('th_ai', 'user', q)}>
              {q}
            </button>
          ))}
        </div>
        {trial > 0 && !useAppStore.getState().aiSubscribed && (
          <button type="button" className="w-full rounded-xl bg-[var(--primary-container)] p-3" onClick={() => jump('user', { id: 'UAI2' })}>
            Còn {trial} ngày dùng thử
          </button>
        )}
      </div>
    </Screen>
  );
}

export function UAI2() {
  const pop = useAppStore((s) => s.pop);
  const commit = useAppStore((s) => s.commit);
  return (
    <Screen title="Gói Trợ lý AI" onBack={() => pop('user')}>
      <div className="p-4 space-y-3">
        <p className="type-caption">Giá minh hoạ</p>
        <div className="app-card p-3">Tháng · 99.000đ</div>
        <div className="app-card p-3">Năm · 799.000đ</div>
        <Button
          onClick={() => {
            commit({ aiSubscribed: true });
            pop('user');
          }}
        >
          Dùng thử / Mua
        </Button>
      </div>
    </Screen>
  );
}

export function UW1() {
  const wallet = useAppStore((s) => s.wallet);
  const tx = useAppStore((s) => s.walletTx);
  const topup = useAppStore((s) => s.topup);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title={brand.walletName} onBack={() => pop('user')}>
      <div className="p-4">
        <div className="type-display">{vnd(wallet)}</div>
        <div className="mt-3 flex flex-wrap gap-2">
          {[500000, 1000000, 2000000, 5000000].map((n) => (
            <Button key={n} variant="outline" onClick={() => topup(n, 'MoMo')}>
              Nạp {vnd(n)}
            </Button>
          ))}
        </div>
        <div className="mt-4 type-caption">Hoàn tiền mặc định về ví (tức thì).</div>
        {tx.slice(0, 12).map((t) => (
          <div key={t.id} className="flex justify-between border-b py-2 type-body">
            <span>{t.note}</span>
            <span>{vnd(t.amount)}</span>
          </div>
        ))}
      </div>
    </Screen>
  );
}

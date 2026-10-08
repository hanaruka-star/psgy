import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { cancelRefundPct } from '@/config/business';
import { atFull, minutesBetween, vnd } from '@/lib/format';
import { sessionView, useAppStore, useNow } from '@/store/appStore';
import { useState } from 'react';

function currentSession(params?: Record<string, string>) {
  const sessions = useAppStore.getState().sessions;
  return sessions.find((s) => s.id === params?.sessionId) ?? sessions.find((s) => s.id === 'ss_today') ?? sessions[0];
}

export function USS1({ params }: { params?: Record<string, string> }) {
  const s = useAppStore((st) => st.sessions.find((x) => x.id === (params?.sessionId ?? 'ss_today')) ?? st.sessions[0]);
  const pt = useAppStore((st) => st.pts.find((p) => p.id === s.ptId)!);
  const now = useNow();
  const cfg = useAppStore((st) => st.business);
  const pop = useAppStore((st) => st.pop);
  const push = useAppStore((st) => st.push);
  const confirmStart = useAppStore((st) => st.confirmStart);
  const confirmComplete = useAppStore((st) => st.confirmComplete);
  const dispute = useAppStore((st) => st.dispute);
  const view = sessionView(s, now, cfg);
  const remain = Math.max(0, minutesBetween(now, s.startAt));

  return (
    <Screen title="Buổi tập" onBack={() => pop('user')}>
      <div className="p-4 space-y-3">
        <Chip>{String(view)}</Chip>
        <div className="type-title">{pt.name}</div>
        <div>{atFull(s.startAt)} · Buổi {s.index}/{s.total}</div>
        <div className="app-card p-3">{s.locationLabel}</div>

        {view === 'upcoming' && (
          <>
            <div className="app-card p-3">
              <div className="font-semibold">Bản đồ</div>
              <div className="mt-2 h-28 rounded bg-[var(--tag)] grid place-items-center type-caption">
                California Fitness Nguyễn Du
              </div>
            </div>
            <div className="app-card p-3 text-center type-title">Còn {remain} phút</div>
            <div className="app-card p-3">
              <div className="font-semibold">Nhắc nhở</div>
              <p>Nếu chưa ăn, hãy dùng một bữa nhẹ trước khi tập.</p>
            </div>
          </>
        )}
        {view === 'due' && (
          <div className="app-card p-3">
            {s.arrivedAt ? 'Hãy chờ PT xác nhận buổi tập' : 'PT đang di chuyển đến điểm tập'}
          </div>
        )}
        {s.note === 'awaitStart' && (
          <Button onClick={() => confirmStart(s.id)}>Xác nhận bắt đầu</Button>
        )}
        {s.status === 'training' && (
          <div className="app-card p-3">Đang tập · thời gian đã chạy từ {atFull(s.trainedAt ?? now)}</div>
        )}
        {s.status === 'awaitingUserComplete' && s.summary && (
          <div className="app-card p-3 space-y-2">
            <div className="font-semibold">Buổi tập đã kết thúc</div>
            <div>Thời lượng {s.summary.actualMin} phút · {s.summary.muscles.join(', ')}</div>
            <div>{s.summary.nextNote}</div>
            <Button onClick={() => confirmComplete(s.id)}>Xác nhận hoàn thành</Button>
            <Button variant="outline" onClick={() => dispute(s.id, 'Nội dung không đúng')}>
              Báo cáo vấn đề
            </Button>
          </div>
        )}
        {s.proposedStartAt && (
          <div className="app-card p-3">
            PT đề xuất đổi sang {atFull(s.proposedStartAt)}
            <div className="mt-2 flex gap-2">
              <Button onClick={() => useAppStore.getState().answerReschedule(s.id, true)}>Đồng ý</Button>
              <Button variant="outline" onClick={() => useAppStore.getState().answerReschedule(s.id, false)}>
                Từ chối
              </Button>
            </div>
          </div>
        )}
        <div className="flex flex-wrap gap-2">
          {view !== 'due' && view !== 'training' && remain > cfg.reschedule_before && (
            <Button variant="outline" onClick={() => push('user', { id: 'URS1', params: { sessionId: s.id } })}>
              Đổi giờ
            </Button>
          )}
          <Button variant="outline" onClick={() => push('user', { id: 'UCN1', params: { sessionId: s.id } })}>
            Huỷ
          </Button>
          <Button variant="ghost" onClick={() => push('user', { id: 'UC2', params: { threadId: 'th_pt_01' } })}>
            Nhắn PT
          </Button>
          {view === 'due' && !s.arrivedAt && now - s.startAt > cfg.no_show_after * 60000 && (
            <Button variant="outline" onClick={() => useAppStore.getState().reportNoShowPt(s.id)}>
              Báo PT không đến
            </Button>
          )}
        </div>
      </div>
    </Screen>
  );
}

export function UR2({ params }: { params?: Record<string, string> }) {
  const add = useAppStore((s) => s.addReview);
  const jump = useAppStore((s) => s.jump);
  const [level, setLevel] = useState<'unhappy' | 'happy' | 'love'>('happy');
  const tagsBy = {
    unhappy: ['PT không thân thiện', 'PT đến trễ', 'Chuyên môn chưa tốt'],
    happy: ['Đúng giờ', 'Hướng dẫn rõ', 'Buổi tập phù hợp'],
    love: ['Chuyên môn rất tốt', 'Truyền động lực tốt', 'Rất tận tâm'],
  };
  const [tags, setTags] = useState<string[]>([]);
  const id = params?.sessionId ?? 'ss_today';
  return (
    <Screen title="Đánh giá">
      <div className="p-4 space-y-3">
        {(['unhappy', 'happy', 'love'] as const).map((l) => (
          <Chip key={l} selected={level === l} onClick={() => setLevel(l)}>
            {l === 'unhappy' ? 'Không hài lòng' : l === 'happy' ? 'Hài lòng' : 'Rất hài lòng'}
          </Chip>
        ))}
        <div className="flex flex-wrap gap-1">
          {tagsBy[level].map((t) => (
            <Chip key={t} selected={tags.includes(t)} onClick={() => setTags((x) => (x.includes(t) ? x.filter((i) => i !== t) : [...x, t]))}>
              {t}
            </Chip>
          ))}
        </div>
        <Button block onClick={() => add(id, level, tags, '')}>Gửi đánh giá</Button>
        <Button variant="text" onClick={() => jump('user', { id: 'USE1', params: { sessionId: id } })}>
          Để sau
        </Button>
      </div>
    </Screen>
  );
}

export function URS1({ params }: { params?: Record<string, string> }) {
  const id = params?.sessionId ?? 'ss_today';
  const s = useAppStore((st) => st.sessions.find((x) => x.id === id)!);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Đổi lịch" onBack={() => pop('user')}>
      <div className="p-4">
        <p>Lịch hiện tại: {atFull(s.startAt)}</p>
        <Button
          className="mt-3"
          onClick={() => {
            useAppStore.getState().proposeReschedule(id, s.startAt + 86400000, 'user');
            pop('user');
          }}
        >
          Đề xuất +1 ngày cùng giờ
        </Button>
      </div>
    </Screen>
  );
}

export function UCN1({ params }: { params?: Record<string, string> }) {
  const id = params?.sessionId ?? 'ss_today';
  const s = useAppStore((st) => st.sessions.find((x) => x.id === id)!);
  const now = useNow();
  const cfg = useAppStore((st) => st.business);
  const ct = useAppStore((st) => st.contracts.find((c) => c.id === s.contractId));
  const pop = useAppStore((st) => st.pop);
  const hours = (s.startAt - now) / 3600000;
  const pct = cancelRefundPct(hours, cfg);
  const share = ct ? ct.priceVnd / ct.sessions : 0;
  return (
    <Screen title="Huỷ buổi tập" onBack={() => pop('user')}>
      <div className="p-4 space-y-3">
        <div className="app-card p-3">
          Hoàn {pct}% = {vnd((share * pct) / 100)} về Ví PSGymer
        </div>
        <Button
          onClick={() => {
            useAppStore.getState().cancelSession(id, 'user', 'Đổi kế hoạch');
            pop('user');
          }}
        >
          Xác nhận huỷ
        </Button>
      </div>
    </Screen>
  );
}

export function USE1({ params }: { params?: Record<string, string> }) {
  const s = currentSession(params);
  const ct = useAppStore((st) => st.contracts.find((c) => c.id === s.contractId));
  const streak = useAppStore((st) => st.streak);
  const jump = useAppStore((st) => st.jump);
  const startBooking = useAppStore((st) => st.startBooking);
  return (
    <Screen title="Hoàn thành buổi">
      <div className="p-4 text-center space-y-3">
        <div className="type-display">Hoàn thành buổi {ct?.done}/{ct?.sessions}</div>
        <div className="h-2 rounded bg-[var(--tag)]">
          <div className="h-full bg-[var(--highlight)]" style={{ width: `${((ct?.done ?? 0) / (ct?.sessions ?? 1)) * 100}%` }} />
        </div>
        <div>Streak +1 · đang {streak} tuần</div>
        <Button onClick={() => startBooking(s.ptId)}>Đặt buổi tiếp theo</Button>
        <Button variant="text" onClick={() => jump('user', { id: 'UPF3' })}>
          Cập nhật cân nặng
        </Button>
      </div>
    </Screen>
  );
}

export function USE2({ params }: { params?: Record<string, string> }) {
  const s = currentSession(params);
  const startBooking = useAppStore((st) => st.startBooking);
  return (
    <Screen title="Hoàn thành gói">
      <div className="p-4 text-center space-y-3">
        <div className="type-display">Bạn đã hoàn thành gói!</div>
        <p>Tổng buổi · tổng giờ · cân nặng đã cập nhật trong Profile.</p>
        <Button onClick={() => startBooking(s.ptId)}>Gia hạn / mua gói mới</Button>
      </div>
    </Screen>
  );
}

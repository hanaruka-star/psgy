import { useEffect, useRef, type TouchEvent as ReactTouchEvent } from 'react';
import { BottomNav, PT_NAV, USER_NAV } from '@/components/BottomNav';
import { PushBanner } from '@/components/PushBanner';
import { renderScreen } from '@/screens/registry';
import { PT_TABS, USER_TABS, sessionView, useAppStore, useNow } from '@/store/appStore';
import type { Role } from '@/domain/types';
import { StatusBarSafe } from './PhoneFrame';

type Props = { role: Role; framed: boolean };

export function PhoneApp({ role, framed }: Props) {
  const userStack = useAppStore((s) => s.userStack);
  const ptStack = useAppStore((s) => s.ptStack);
  const stack = role === 'user' ? userStack : ptStack;
  const current = stack[stack.length - 1] ?? { id: role === 'user' ? 'UD1' : 'PO1' };
  const pop = useAppStore((s) => s.pop);
  const setTab = useAppStore((s) => s.setTab);
  const userTab = useAppStore((s) => s.userTab);
  const ptTab = useAppStore((s) => s.ptTab);
  const findWhatSeen = useAppStore((s) => s.findWhatSeen);
  const onboardingDone = useAppStore((s) => s.onboardingDone);
  const setMapTab = useAppStore((s) => s.setMapTab);
  const commit = useAppStore((s) => s.commit);
  const pendingApproval = useAppStore((s) => s.ptPendingApproval);
  const jumpedPending = useRef(false);

  const tabs = role === 'user' ? USER_TABS : PT_TABS;
  const showBar = tabs.includes(current.id);
  const key = `${current.id}:${JSON.stringify(current.params ?? {})}:${stack.length}`;

  const onEdgeSwipe = (e: ReactTouchEvent) => {
    if (e.touches[0].clientX > 28) return;
    const startX = e.touches[0].clientX;
    const startY = e.touches[0].clientY;
    const move = (ev: TouchEvent) => {
      const dx = ev.touches[0].clientX - startX;
      const dy = Math.abs(ev.touches[0].clientY - startY);
      if (dx > 72 && dy < 60) {
        cleanup();
        pop(role);
      }
    };
    const cleanup = () => {
      window.removeEventListener('touchmove', move);
      window.removeEventListener('touchend', cleanup);
    };
    window.addEventListener('touchmove', move, { passive: true });
    window.addEventListener('touchend', cleanup);
  };

  useEffect(() => {
    if (role !== 'pt' || !pendingApproval || jumpedPending.current) return;
    if (current.id !== 'PO1') return;
    jumpedPending.current = true;
    queueMicrotask(() => useAppStore.getState().jump('pt', { id: 'PL2' }));
  }, [role, pendingApproval, current.id]);

  return (
    <div data-phone={role} className="phone-canvas relative flex h-full min-h-0 flex-col overflow-hidden" onTouchStart={onEdgeSwipe}>
      {!framed && <StatusBarSafe />}
      <PushBanner role={role} />
      <div className="relative min-h-0 flex-1 overflow-hidden">
        <div className="absolute inset-0" key={key}>
          {renderScreen(current.id, role, current.params)}
        </div>
        {role === 'user' && onboardingDone && !findWhatSeen && current.id === 'UM1' && (
          <div className="absolute inset-0 z-40 grid place-items-center bg-black/50 p-6">
            <div className="w-full rounded-[var(--radius-lg)] bg-[var(--card)] p-4">
              <div className="flex justify-between">
                <div className="font-bold">Bạn muốn tìm gì?</div>
                <button
                  type="button"
                  onClick={() => {
                    commit({ findWhatSeen: true });
                    setMapTab('pt');
                  }}
                >
                  ✕
                </button>
              </div>
              <button
                type="button"
                className="app-card mt-3 w-full p-3 text-left"
                onClick={() => {
                  setMapTab('pt');
                  commit({ findWhatSeen: true });
                }}
              >
                Tìm PT · Huấn luyện cá nhân
              </button>
              <button
                type="button"
                className="app-card mt-2 w-full p-3 text-left"
                onClick={() => {
                  setMapTab('gym');
                  commit({ findWhatSeen: true });
                }}
              >
                Tìm Phòng Gym
              </button>
            </div>
          </div>
        )}
        {role === 'user' && <SessionPop />}
        {role === 'pt' && <PtSoonPop />}
      </div>
      {showBar && (
        <BottomNav
          tabs={role === 'user' ? USER_NAV : PT_NAV}
          activeId={role === 'user' ? userTab : ptTab}
          onSelect={(id) => setTab(role, id)}
        />
      )}
    </div>
  );
}

function SessionPop() {
  const mute = useAppStore((st) => st.muteTimedPopups);
  const now = useNow();
  const cfg = useAppStore((s) => s.business);
  const s = useAppStore((st) => st.sessions.find((x) => x.id === 'ss_today'));
  const seen = useAppStore((st) => st.seenPopup);
  const commit = useAppStore((st) => st.commit);
  const jump = useAppStore((st) => st.jump);
  if (mute || !s) return null;
  const view = sessionView(s, now, cfg);
  const key = `${s.id}_${view}`;
  if (seen[key]) return null;
  if (view !== 'upcoming' && view !== 'due' && s.status !== 'awaitingUserComplete') return null;
  const title =
    s.status === 'awaitingUserComplete'
      ? 'Buổi tập đã kết thúc'
      : view === 'upcoming'
        ? 'Sắp đến giờ tập'
        : s.arrivedAt
          ? 'Hãy chờ PT xác nhận buổi tập'
          : 'PT đang di chuyển đến điểm tập';
  return (
    <div className="absolute inset-0 z-40 grid place-items-end bg-black/40 p-4">
      <div className="w-full rounded-[var(--radius-lg)] bg-[var(--card)] p-4">
        <div className="font-bold">{title}</div>
        <button
          type="button"
          className="mt-3 text-[var(--primary-text)]"
          onClick={() => {
            commit({ seenPopup: { ...seen, [key]: true } });
            jump('user', { id: 'USS1', params: { sessionId: s.id } });
          }}
        >
          Xem buổi tập
        </button>
        <button
          type="button"
          className="ml-4"
          onClick={() => commit({ seenPopup: { ...seen, [key]: true } })}
        >
          Đóng
        </button>
      </div>
    </div>
  );
}

function PtSoonPop() {
  const mute = useAppStore((st) => st.muteTimedPopups);
  const now = useNow();
  const cfg = useAppStore((s) => s.business);
  const s = useAppStore((st) => st.sessions.find((x) => x.id === 'ss_today'));
  const seen = useAppStore((st) => st.seenPopup);
  const commit = useAppStore((st) => st.commit);
  const jump = useAppStore((st) => st.jump);
  if (mute || !s) return null;
  const view = sessionView(s, now, cfg);
  const key = `pt_${s.id}_${view}`;
  if (seen[key] || (view !== 'upcoming' && view !== 'due')) return null;
  return (
    <div className="absolute inset-0 z-40 grid place-items-end bg-black/40 p-4">
      <div className="w-full rounded-[var(--radius-lg)] bg-[var(--card)] p-4">
        <div className="font-bold">{view === 'due' ? 'Đến giờ — hãy di chuyển / Tôi đã đến' : 'Sắp đến giờ dạy'}</div>
        <button
          type="button"
          className="mt-3 text-[var(--primary-text)]"
          onClick={() => {
            commit({ seenPopup: { ...seen, [key]: true } });
            jump('pt', { id: 'PSD1', params: { sessionId: s.id } });
          }}
        >
          Mở buổi
        </button>
        <button type="button" className="ml-4" onClick={() => commit({ seenPopup: { ...seen, [key]: true } })}>
          Đóng
        </button>
      </div>
    </div>
  );
}

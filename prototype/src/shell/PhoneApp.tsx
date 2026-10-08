import { useRef, type TouchEvent as ReactTouchEvent } from 'react';
import { AnimatePresence, motion } from 'motion/react';
import { BottomBar } from '@/components/BottomBar';
import { renderScreen } from '@/screens/registry';
import { useAppStore } from '@/store/appStore';
import type { Role } from '@/types';
import { StatusBarSafe } from './PhoneFrame';

const USER_TAB_ROOTS = new Set(['U07', 'U08', 'U13', 'U14', 'U15', 'U19']);

type Props = {
  role: Role;
  framed: boolean;
};

export function PhoneApp({ role, framed }: Props) {
  const userStack = useAppStore((s) => s.userStack);
  const coachStack = useAppStore((s) => s.coachStack);
  const stack = role === 'user' ? userStack : coachStack;
  const current = stack[stack.length - 1] ?? { id: role === 'user' ? 'U07' : 'C01' };
  const pop = useAppStore((s) => s.pop);
  const setUserTab = useAppStore((s) => s.setUserTab);
  const lastUserTab = useAppStore((s) => s.lastUserTab);
  const features = useAppStore((s) => s.features);
  const dirRef = useRef(1);
  const lenRef = useRef(stack.length);
  if (stack.length !== lenRef.current) {
    dirRef.current = stack.length > lenRef.current ? 1 : -1;
    lenRef.current = stack.length;
  }

  const showUserBar = role === 'user' && USER_TAB_ROOTS.has(current.id);
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

  return (
    <div
      className="phone-canvas relative flex h-full min-h-0 flex-col overflow-hidden"
      onTouchStart={onEdgeSwipe}
    >
      {!framed && <StatusBarSafe />}
      <div className="relative min-h-0 flex-1 overflow-hidden">
        <AnimatePresence initial={false} custom={dirRef.current}>
          <motion.div
            key={key}
            className="absolute inset-0"
            custom={dirRef.current}
            initial={{ x: dirRef.current >= 0 ? '100%' : '-35%' }}
            animate={{ x: 0 }}
            exit={{ x: dirRef.current >= 0 ? '-35%' : '100%' }}
            transition={{ duration: 0.3, ease: [0.32, 0.72, 0, 1] }}
          >
            {renderScreen(current.id, role, current.params)}
          </motion.div>
        </AnimatePresence>
      </div>
      {showUserBar && (
        <BottomBar
          features={features}
          activeId={lastUserTab}
          onSelect={setUserTab}
        />
      )}
    </div>
  );
}

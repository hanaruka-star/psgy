import { useRef, useState, type PointerEvent, type ReactNode } from 'react';

const SNAPS = [0.22, 0.38, 0.78];

type Props = {
  title: string;
  children: ReactNode;
};

export function DraggableSheet({ title, children }: Props) {
  const [snap, setSnap] = useState(0.38);
  const startY = useRef(0);
  const startSnap = useRef(0.38);
  const dragging = useRef(false);

  const onDown = (e: PointerEvent) => {
    dragging.current = true;
    startY.current = e.clientY;
    startSnap.current = snap;
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
  };

  const onMove = (e: PointerEvent) => {
    if (!dragging.current) return;
    const parent = (e.currentTarget as HTMLElement).parentElement;
    const h = parent?.clientHeight ?? 844;
    const dy = startY.current - e.clientY;
    const next = Math.min(0.86, Math.max(0.16, startSnap.current + dy / h));
    setSnap(next);
  };

  const onUp = () => {
    dragging.current = false;
    setSnap((current) =>
      SNAPS.reduce((best, s) =>
        Math.abs(s - current) < Math.abs(best - current) ? s : best,
      ),
    );
  };

  return (
    <div
      className="absolute inset-x-0 bottom-0 z-20 flex flex-col overflow-hidden rounded-t-[var(--radius-xl)] bg-[var(--sheet)] shadow-[0_-8px_24px_rgb(0_0_0/0.12)]"
      style={{ height: `${snap * 100}%` }}
    >
      <div
        className="flex shrink-0 cursor-grab flex-col items-center pt-2 pb-1 active:cursor-grabbing"
        onPointerDown={onDown}
        onPointerMove={onMove}
        onPointerUp={onUp}
        onPointerCancel={onUp}
      >
        <div className="mb-2 h-1.5 w-10 rounded-full bg-[var(--outline-variant)]" />
        <div className="w-full px-4 pb-2 text-[16px] font-semibold text-[var(--sheet-title)]">
          {title}
        </div>
      </div>
      <div className="no-scrollbar min-h-0 flex-1 overflow-y-auto px-4 pb-4">
        {children}
      </div>
    </div>
  );
}

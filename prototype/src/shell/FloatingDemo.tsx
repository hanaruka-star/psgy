import { useRef, useState, type PointerEvent } from 'react';
import { DemoPanel } from './DemoPanel';

export function FloatingDemo() {
  const [open, setOpen] = useState(false);
  const [pos, setPos] = useState({ x: -1, y: 120 });
  const drag = useRef<{ x: number; y: number; px: number; py: number; moved: boolean } | null>(
    null,
  );

  const left = pos.x < 0 ? undefined : pos.x;
  const right = pos.x < 0 ? 12 : undefined;

  const down = (e: PointerEvent) => {
    drag.current = {
      x: pos.x < 0 ? window.innerWidth - 56 : pos.x,
      y: pos.y,
      px: e.clientX,
      py: e.clientY,
      moved: false,
    };
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
  };
  const move = (e: PointerEvent) => {
    if (!drag.current) return;
    const dx = e.clientX - drag.current.px;
    const dy = e.clientY - drag.current.py;
    if (Math.abs(dx) + Math.abs(dy) > 6) drag.current.moved = true;
    setPos({
      x: Math.max(8, Math.min(window.innerWidth - 56, drag.current.x + dx)),
      y: Math.max(8, Math.min(window.innerHeight - 140, drag.current.y + dy)),
    });
  };
  const up = () => {
    const moved = drag.current?.moved;
    drag.current = null;
    if (!moved) setOpen((v) => !v);
  };

  return (
    <>
      {open && (
        <div className="fixed inset-0 z-40 flex items-end justify-end p-3 pb-24">
          <button
            type="button"
            className="absolute inset-0 bg-black/40"
            aria-label="Đóng bảng điều khiển"
            onClick={() => setOpen(false)}
          />
          <div className="relative z-10">
            <DemoPanel compact />
          </div>
        </div>
      )}
      <button
        type="button"
        aria-label="Bảng điều khiển demo"
        className="fixed z-50 grid h-11 w-11 place-items-center rounded-full bg-sky-500/55 text-lg font-bold text-white shadow-lg backdrop-blur"
        style={{ top: pos.y, left, right, bottom: undefined }}
        onPointerDown={down}
        onPointerMove={move}
        onPointerUp={up}
      >
        ⚙
      </button>
    </>
  );
}

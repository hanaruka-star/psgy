import type { ReactNode } from 'react';

type Props = {
  title: string;
  children: ReactNode;
  frame?: 'user' | 'pt';
};

function StatusBar() {
  return (
    <div className="relative z-30 flex h-[54px] shrink-0 items-end justify-between px-6 pb-1.5 text-[12px] font-semibold">
      <span>9:41</span>
      <div
        className="absolute left-1/2 top-[10px] h-[34px] w-[126px] -translate-x-1/2 rounded-full bg-black"
        aria-hidden
      />
      <span className="flex items-center gap-1.5">
        <svg width="16" height="12" viewBox="0 0 16 12" aria-hidden>
          <rect x="0" y="8" width="3" height="4" rx="0.5" fill="currentColor" />
          <rect x="4.2" y="5" width="3" height="7" rx="0.5" fill="currentColor" />
          <rect x="8.4" y="2.5" width="3" height="9.5" rx="0.5" fill="currentColor" />
          <rect x="12.6" y="0" width="3" height="12" rx="0.5" fill="currentColor" />
        </svg>
        <svg width="16" height="12" viewBox="0 0 16 12" aria-hidden>
          <path
            d="M8 10.4a1.2 1.2 0 1 0 0 2.4 1.2 1.2 0 0 0 0-2.4Zm0-3.2a4 4 0 0 1 2.8 1.15l-1.1 1.1A2.5 2.5 0 0 0 8 7.8a2.5 2.5 0 0 0-1.7.65L5.2 7.35A4 4 0 0 1 8 7.2Zm0-3.2a7.2 7.2 0 0 1 5.1 2.1l-1.1 1.1A5.7 5.7 0 0 0 8 4.6a5.7 5.7 0 0 0-4 1.6L2.9 5.1A7.2 7.2 0 0 1 8 4Z"
            fill="currentColor"
          />
        </svg>
        <svg width="24" height="12" viewBox="0 0 24 12" aria-hidden>
          <rect x="0.5" y="1" width="20" height="10" rx="2.5" stroke="currentColor" fill="none" />
          <rect x="2" y="2.5" width="16" height="7" rx="1.2" fill="currentColor" />
          <rect x="21.2" y="4" width="2" height="4" rx="0.8" fill="currentColor" />
        </svg>
      </span>
    </div>
  );
}

export function PhoneFrame({ title, children, frame }: Props) {
  return (
    <div className="flex flex-col items-center">
      <div className="mb-2 text-[13px] font-semibold tracking-wide text-slate-300">
        {title}
      </div>
      <div
        data-frame={frame}
        className="relative overflow-hidden rounded-[44px] bg-black p-[10px] shadow-[0_24px_60px_rgb(0_0_0/0.45)]"
        style={{ width: 390, height: 844 }}
      >
        <div className="phone-canvas relative flex h-full w-full flex-col overflow-hidden rounded-[34px]">
          <StatusBar />
          <div className="relative min-h-0 flex-1">{children}</div>
          <div className="pointer-events-none absolute bottom-1.5 left-1/2 z-30 h-[5px] w-[128px] -translate-x-1/2 rounded-full bg-black/70" />
        </div>
      </div>
    </div>
  );
}

export function StatusBarSafe() {
  return (
    <div
      className="shrink-0"
      style={{ height: 'max(12px, env(safe-area-inset-top))' }}
    />
  );
}

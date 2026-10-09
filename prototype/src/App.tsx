import { Component, useEffect, useState, type ErrorInfo, type ReactNode } from 'react';
import { DemoPanel } from '@/shell/DemoPanel';
import { FloatingDemo } from '@/shell/FloatingDemo';
import { PhoneApp } from '@/shell/PhoneApp';
import { PhoneFrame } from '@/shell/PhoneFrame';
import { useAppearance } from '@/store/appearanceStore';
import { useAppStore } from '@/store/appStore';
import { applyAppearance } from '@/theme/appearance';
import { applyTheme } from '@/theme/presets';

function forceDesk() {
  const q = new URLSearchParams(window.location.search);
  if (q.get('desk') === '1') return true;
  if (q.get('desk') === '0') return false;
  return window.innerWidth >= 1100;
}

function useNarrow() {
  const [narrow, setNarrow] = useState(() => !forceDesk() && window.innerWidth < 900);
  useEffect(() => {
    const onResize = () => {
      const next = !forceDesk() && window.innerWidth < 900;
      setNarrow((prev) => (prev === next ? prev : next));
    };
    window.addEventListener('resize', onResize);
    return () => window.removeEventListener('resize', onResize);
  }, []);
  return narrow;
}

class ErrorBoundary extends Component<{ children: ReactNode }, { err: string | null }> {
  state = { err: null as string | null };
  static getDerivedStateFromError(e: Error) {
    return { err: `${e.message}\n${e.stack ?? ''}` };
  }
  componentDidCatch(e: Error, info: ErrorInfo) {
    console.error(e, info);
  }
  render() {
    if (this.state.err) {
      return (
        <pre className="whitespace-pre-wrap bg-red-950 p-6 text-sm text-red-100">{this.state.err}</pre>
      );
    }
    return this.props.children;
  }
}

export default function App() {
  const narrow = useNarrow();
  const mobileRole = useAppStore((s) => s.mobileRole);
  const style = useAppStore((s) => s.style);
  const mode = useAppStore((s) => s.mode);
  const slice = useAppearance((s) => s.slices[style]?.[mode] ?? s.slices.fresh.light);

  useEffect(() => {
    applyTheme(style, mode);
    applyAppearance(slice);
    (window as unknown as { __psgy: typeof useAppStore }).__psgy = useAppStore;
  }, [style, mode, slice]);

  if (narrow) {
    return (
      <ErrorBoundary>
        <div className="relative h-dvh w-full overflow-hidden">
          <PhoneApp role={mobileRole} framed={false} />
          <FloatingDemo />
        </div>
      </ErrorBoundary>
    );
  }

  return (
    <ErrorBoundary>
      <div className="desk flex min-h-dvh flex-nowrap items-start justify-center gap-6 overflow-auto p-6">
        <PhoneFrame title="PSGymer User" frame="user">
          <PhoneApp role="user" framed />
        </PhoneFrame>
        <PhoneFrame title="PSGymer PT Center" frame="pt">
          <PhoneApp role="pt" framed />
        </PhoneFrame>
        <DemoPanel />
      </div>
    </ErrorBoundary>
  );
}

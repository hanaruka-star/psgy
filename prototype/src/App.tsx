import { useEffect, useState } from 'react';
import { DemoPanel } from '@/shell/DemoPanel';
import { FloatingDemo } from '@/shell/FloatingDemo';
import { PhoneApp } from '@/shell/PhoneApp';
import { PhoneFrame } from '@/shell/PhoneFrame';
import { useAppStore } from '@/store/appStore';

function useNarrow() {
  const [narrow, setNarrow] = useState(
    () =>
      window.innerWidth < 900 ||
      window.matchMedia('(display-mode: standalone)').matches ||
      Boolean((navigator as Navigator & { standalone?: boolean }).standalone),
  );
  useEffect(() => {
    const onResize = () => {
      const standalone =
        window.matchMedia('(display-mode: standalone)').matches ||
        Boolean((navigator as Navigator & { standalone?: boolean }).standalone);
      setNarrow(window.innerWidth < 900 || standalone);
    };
    window.addEventListener('resize', onResize);
    return () => window.removeEventListener('resize', onResize);
  }, []);
  return narrow;
}

export default function App() {
  const narrow = useNarrow();
  const mobileRole = useAppStore((s) => s.mobileRole);

  if (narrow) {
    return (
      <div className="relative h-dvh w-full overflow-hidden">
        <PhoneApp role={mobileRole} framed={false} />
        <FloatingDemo />
      </div>
    );
  }

  return (
    <div className="desk flex min-h-dvh flex-nowrap items-start justify-center gap-6 overflow-auto p-6">
      <PhoneFrame title="PSGymer User">
        <PhoneApp role="user" framed />
      </PhoneFrame>
      <PhoneFrame title="PSGymer Coach">
        <PhoneApp role="coach" framed />
      </PhoneFrame>
      <DemoPanel />
    </div>
  );
}

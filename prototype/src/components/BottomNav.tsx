import { useAppearance } from '@/store/appearanceStore';
import { useAppStore } from '@/store/appStore';
import { Icon } from './Icon';

export type TabItem = { id: string; label: string; icon: string };

type Props = {
  tabs: TabItem[];
  activeId: string;
  onSelect: (id: string) => void;
};

export function BottomNav({ tabs, activeId, onSelect }: Props) {
  const style = useAppStore((s) => s.style);
  const mode = useAppStore((s) => s.mode);
  const tab = useAppearance((s) => s.slices[style]?.[mode]?.tab);
  const showLabel = (tab?.label ?? 'iconText') === 'iconText';
  const glass = tab?.navBg === 'glass';
  const iconPx = tab?.iconSize ?? 24;

  return (
    <nav
      className={`bottom-nav relative z-20 flex w-full shrink-0 items-end justify-around px-1 pb-[max(6px,env(safe-area-inset-bottom))] ${
        glass ? '' : 'shadow-[var(--elev-nav)]'
      }`}
      style={{
        height: 'var(--nav-height)',
        background: glass ? undefined : 'var(--nav-bar)',
        borderTop: '1px solid var(--outline-variant)',
      }}
    >
      {tabs.map((t) => {
        const active = activeId === t.id;
        const color = active ? 'var(--tab-active)' : 'var(--tab-inactive)';
        return (
          <button
            key={t.id}
            type="button"
            onClick={() => onSelect(t.id)}
            className="press flex min-w-[56px] flex-1 flex-col items-center justify-center gap-0.5"
            style={{ height: 'calc(var(--nav-height) - 10px)' }}
          >
            <Icon name={t.icon} filled={active} size={iconPx} style={{ color }} />
            {showLabel && (
              <span className="tab-label type-caption font-medium" style={{ color }}>
                {t.label}
              </span>
            )}
          </button>
        );
      })}
    </nav>
  );
}

export const USER_NAV: TabItem[] = [
  { id: 'UD1', label: 'Discovery', icon: 'auto_awesome' },
  { id: 'UM1', label: 'Map', icon: 'map' },
  { id: 'UC1', label: 'Chat', icon: 'chat' },
  { id: 'UCA1', label: 'Camera AI', icon: 'photo_camera' },
  { id: 'UPF1', label: 'Profile', icon: 'person' },
];

export const PT_NAV: TabItem[] = [
  { id: 'PO1', label: 'Tổng quan', icon: 'dashboard' },
  { id: 'PW1', label: 'Công việc', icon: 'event' },
  { id: 'PC1', label: 'Chat', icon: 'chat' },
  { id: 'PI1', label: 'Thu nhập', icon: 'payments' },
  { id: 'PM1', label: 'Tôi', icon: 'person' },
];

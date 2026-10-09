import type { FeatureFlags } from '@/config/features';
import { useAppearance } from '@/store/appearanceStore';
import { useAppStore } from '@/store/appStore';
import { Icon } from './Icon';

type Tab = {
  id: string;
  label: string;
  icon: string;
};

const TAB_META: Record<string, { label: string; icon: string; feature?: keyof FeatureFlags }> = {
  UD1: { label: 'Discovery', icon: 'auto_awesome' },
  UM1: { label: 'Map', icon: 'map' },
  UC1: { label: 'Chat', icon: 'chat' },
  UCA1: { label: 'Camera AI', icon: 'photo_camera', feature: 'cameraAiPreview' },
  UPF1: { label: 'Profile', icon: 'person' },
};

export function tabsFor(
  features: FeatureFlags,
  order: string[],
): Tab[] {
  return order
    .map((id) => {
      const meta = TAB_META[id];
      if (!meta) return null;
      if (meta.feature && !features[meta.feature]) return null;
      return { id, label: meta.label, icon: meta.icon };
    })
    .filter((t): t is Tab => t != null);
}

type Props = {
  features: FeatureFlags;
  activeId: string;
  onSelect: (id: string) => void;
};

export function BottomBar({ features, activeId, onSelect }: Props) {
  const style = useAppStore((s) => s.style);
  const mode = useAppStore((s) => s.mode);
  const tab = useAppearance((s) => s.slices[style]?.[mode]?.tab ?? s.slices.fresh.light.tab);
  const tabs = tabsFor(features, tab.order);
  const mid = Math.floor(tabs.length / 2);
  const showLabel = tab.label === 'iconText';
  const navBg =
    tab.navBg === 'glass'
      ? 'bg-[color-mix(in_srgb,var(--nav-bar)_72%,transparent)] backdrop-blur-xl'
      : tab.navBg === 'transparent'
        ? 'bg-transparent shadow-none'
        : 'bg-[var(--nav-bar)] shadow-[var(--elev-nav)]';

  return (
    <nav
      className={`relative z-20 flex w-full items-end justify-around px-1 pb-[max(6px,env(safe-area-inset-bottom))] ${navBg}`}
      style={{ height: 'var(--nav-height)' }}
    >
      {tabs.map((item, i) => {
        const raised = tab.layout === 'raised' && i === mid;
        const active = activeId === item.id;
        const iconName = raised ? tab.fabIcon : item.icon;
        const color = active ? 'var(--tab-active)' : 'var(--tab-inactive)';

        if (raised) {
          return (
            <button
              key={item.id}
              type="button"
              onClick={() => onSelect(item.id)}
              className="press relative flex w-16 flex-col items-center"
              style={{ top: 'calc(var(--fab-lift) * -1)' }}
            >
              <span
                className="grid place-items-center rounded-full text-[var(--on-highlight)] shadow-[var(--shadow-pin)]"
                style={{
                  width: 'var(--fab-size)',
                  height: 'var(--fab-size)',
                  background: 'var(--fab)',
                }}
              >
                <Icon name={iconName} filled size={28} />
              </span>
              {showLabel && (
                <span
                  className="type-caption mt-0.5 font-medium"
                  style={{ color }}
                >
                  {item.label}
                </span>
              )}
            </button>
          );
        }

        return (
          <button
            key={item.id}
            type="button"
            onClick={() => onSelect(item.id)}
            className="press flex min-w-[56px] flex-1 flex-col items-center justify-center gap-0.5"
            style={{ height: 'calc(var(--nav-height) - 10px)' }}
          >
            <Icon
              name={item.icon}
              filled={active}
              size={tab.iconSize}
              style={{ color, fontSize: 'var(--nav-icon)' }}
            />
            {showLabel && (
              <span className="type-caption font-medium" style={{ color }}>
                {item.label}
              </span>
            )}
          </button>
        );
      })}
    </nav>
  );
}

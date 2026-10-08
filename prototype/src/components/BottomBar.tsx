import type { FeatureFlags } from '@/config/features';
import { Icon } from './Icon';

type Tab = {
  id: string;
  label: string;
  icon: string;
  fab?: boolean;
};

function tabsFor(features: FeatureFlags): Tab[] {
  const items: Tab[] = [{ id: 'U07', label: 'Bản đồ', icon: 'map' }];
  if (features.journal) {
    items.push({ id: 'U14', label: 'Nhật ký', icon: 'auto_stories' });
  }
  if (features.ptAi) {
    items.push({ id: 'U19', label: 'PT AI', icon: 'smart_toy', fab: true });
  }
  if (features.journal) {
    items.push({ id: 'U15', label: 'Cộng đồng', icon: 'groups' });
  }
  items.push({ id: 'U13', label: 'Lịch sử', icon: 'receipt_long' });
  return items;
}

type Props = {
  features: FeatureFlags;
  activeId: string;
  onSelect: (id: string) => void;
};

export function BottomBar({ features, activeId, onSelect }: Props) {
  const tabs = tabsFor(features);

  return (
    <nav
      className="relative z-20 flex h-16 shrink-0 items-end justify-around bg-[var(--nav-bar)] px-1 pb-[max(6px,env(safe-area-inset-bottom))] shadow-[var(--elev-nav)]"
    >
      {tabs.map((tab) => {
        if (tab.fab) {
          const active = activeId === tab.id;
          return (
            <button
              key={tab.id}
              type="button"
              onClick={() => onSelect(tab.id)}
              className="press relative -top-4 flex w-16 flex-col items-center"
            >
              <span
                className="grid h-[60px] w-[60px] place-items-center rounded-full bg-[var(--highlight)] text-[var(--on-highlight)] shadow-[0_4px_12px_rgb(0_0_0/0.25)]"
              >
                <Icon name={tab.icon} filled size={28} />
              </span>
              <span
                className="mt-0.5 text-[10px] font-medium"
                style={{ color: active ? 'var(--tab-active)' : 'var(--tab-inactive)' }}
              >
                {tab.label}
              </span>
            </button>
          );
        }
        const active = activeId === tab.id;
        return (
          <button
            key={tab.id}
            type="button"
            onClick={() => onSelect(tab.id)}
            className="press flex h-14 min-w-[56px] flex-1 flex-col items-center justify-center gap-0.5"
          >
            <Icon
              name={tab.icon}
              filled={active}
              size={24}
              style={{ color: active ? 'var(--tab-active)' : 'var(--tab-inactive)' }}
            />
            <span
              className="text-[10px] font-medium"
              style={{ color: active ? 'var(--tab-active)' : 'var(--tab-inactive)' }}
            >
              {tab.label}
            </span>
          </button>
        );
      })}
    </nav>
  );
}

export { tabsFor };

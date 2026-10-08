import { create } from 'zustand';
import { defaultFeatures, type FeatureFlags } from '@/config/features';
import { applyTheme, type ModeId, type StyleId } from '@/theme/presets';
import type { Booking, NavEntry, Role } from '@/types';
import seed from '@/data/coach_session.json';

const STORAGE_KEY = 'psgy-proto-v1';
const LOCATION_CYCLE = [
  'Quận 2, TP.HCM',
  'Quận 1, TP.HCM',
  'Quận 7, TP.HCM',
  'Thủ Đức, TP.HCM',
];

export type MapLayer = 'coach' | 'gym';

type Persisted = {
  features: FeatureFlags;
  style: StyleId;
  mode: ModeId;
  mobileRole: Role;
  userStack: NavEntry[];
  coachStack: NavEntry[];
  lastUserTab: string;
  bookings: Booking[];
  isAvailableNow: boolean;
  locationIndex: number;
  mapLayer: MapLayer;
};

function seedBookings(): Booking[] {
  return (seed.bookings as Booking[]).map((b) => ({
    ...b,
    coachId: b.coachId || 'coach_01',
    coachName: b.coachName || 'Nguyễn Văn Long',
  }));
}

const initial: Persisted = {
  features: { ...defaultFeatures },
  style: 'minimal',
  mode: 'light',
  mobileRole: 'user',
  userStack: [{ id: 'U07' }],
  coachStack: [{ id: 'C01' }],
  lastUserTab: 'U07',
  bookings: seedBookings(),
  isAvailableNow: true,
  locationIndex: 0,
  mapLayer: 'coach',
};

function load(): Persisted {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return { ...initial, bookings: seedBookings() };
    const parsed = JSON.parse(raw) as Partial<Persisted>;
    return {
      ...initial,
      ...parsed,
      features: { ...defaultFeatures, ...parsed.features },
      bookings: parsed.bookings?.length ? parsed.bookings : seedBookings(),
      userStack: parsed.userStack?.length ? parsed.userStack : [{ id: 'U07' }],
      coachStack: parsed.coachStack?.length ? parsed.coachStack : [{ id: 'C01' }],
      lastUserTab: parsed.lastUserTab ?? 'U07',
    };
  } catch {
    return { ...initial, bookings: seedBookings() };
  }
}

type Store = Persisted & {
  push: (role: Role, entry: NavEntry) => void;
  pop: (role: Role) => void;
  jump: (role: Role, entry: NavEntry) => void;
  setUserTab: (id: string) => void;
  setStyle: (style: StyleId) => void;
  setMode: (mode: ModeId) => void;
  setMobileRole: (role: Role) => void;
  setFeature: (key: keyof FeatureFlags, value: boolean) => void;
  setMapLayer: (layer: MapLayer) => void;
  toggleAvailable: () => void;
  cycleLocation: () => void;
  reset: () => void;
};

function persist(s: Persisted) {
  try {
    localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify({
        features: s.features,
        style: s.style,
        mode: s.mode,
        mobileRole: s.mobileRole,
        userStack: s.userStack,
        coachStack: s.coachStack,
        lastUserTab: s.lastUserTab,
        bookings: s.bookings,
        isAvailableNow: s.isAvailableNow,
        locationIndex: s.locationIndex,
        mapLayer: s.mapLayer,
      } satisfies Persisted),
    );
  } catch {
    /* ignore quota */
  }
}

export const useAppStore = create<Store>((set, get) => {
  const boot = load();
  queueMicrotask(() => applyTheme(boot.style, boot.mode));

  const commit = (patch: Partial<Persisted>) => {
    set(patch);
    persist({ ...get() });
  };

  return {
    ...boot,
    push: (role, entry) => {
      const key = role === 'user' ? 'userStack' : 'coachStack';
      commit({ [key]: [...get()[key], entry] });
    },
    pop: (role) => {
      const key = role === 'user' ? 'userStack' : 'coachStack';
      const stack = get()[key];
      if (stack.length <= 1) return;
      commit({ [key]: stack.slice(0, -1) });
    },
    jump: (role, entry) => {
      const key = role === 'user' ? 'userStack' : 'coachStack';
      const tabIds = new Set(['U07', 'U13', 'U14', 'U15', 'U19']);
      commit({
        [key]: [entry],
        ...(role === 'user' && tabIds.has(entry.id)
          ? { lastUserTab: entry.id }
          : {}),
      });
    },
    setUserTab: (id) => commit({ userStack: [{ id }], lastUserTab: id }),
    setStyle: (style) => {
      applyTheme(style, get().mode);
      commit({ style });
    },
    setMode: (mode) => {
      applyTheme(get().style, mode);
      commit({ mode });
    },
    setMobileRole: (mobileRole) => commit({ mobileRole }),
    setFeature: (key, value) =>
      commit({ features: { ...get().features, [key]: value } }),
    setMapLayer: (mapLayer) => commit({ mapLayer }),
    toggleAvailable: () => commit({ isAvailableNow: !get().isAvailableNow }),
    cycleLocation: () =>
      commit({
        locationIndex: (get().locationIndex + 1) % LOCATION_CYCLE.length,
      }),
    reset: () => {
      const next = { ...initial, bookings: seedBookings() };
      applyTheme(next.style, next.mode);
      set({ ...next });
      persist(next);
    },
  };
});

export function locationLabel(index: number) {
  return LOCATION_CYCLE[index] ?? LOCATION_CYCLE[0];
}

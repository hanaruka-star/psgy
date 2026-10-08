import { create } from 'zustand';
import {
  cloneSlices,
  resolvedDefaults,
  type AppearanceSlice,
  type AppearanceSlices,
} from '@/theme/appearance';
import { useAppStore } from './appStore';

const STORAGE_KEY = 'psgy-proto-appearance-v1';

function load(): AppearanceSlices {
  const base = resolvedDefaults();
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return base;
    const parsed = JSON.parse(raw) as AppearanceSlices;
    return mergeSlices(base, parsed);
  } catch {
    return base;
  }
}

function mergeSlices(base: AppearanceSlices, over: AppearanceSlices): AppearanceSlices {
  const out = cloneSlices(base);
  (Object.keys(out) as (keyof AppearanceSlices)[]).forEach((style) => {
    (['light', 'dark'] as const).forEach((mode) => {
      const src = over?.[style]?.[mode];
      if (src) out[style][mode] = { ...out[style][mode], ...src, colors: { ...out[style][mode].colors, ...src.colors }, type: { ...out[style][mode].type, ...src.type }, tab: { ...out[style][mode].tab, ...src.tab } };
    });
  });
  return out;
}

function persist(slices: AppearanceSlices) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(slices));
  } catch {
    /* ignore */
  }
}

type Store = {
  slices: AppearanceSlices;
  projectBaseline: AppearanceSlices;
  patchCurrent: (patch: DeepPatch<AppearanceSlice>) => void;
  setCurrent: (slice: AppearanceSlice) => void;
  restoreDefaults: () => void;
  markProjectSaved: (slices: AppearanceSlices) => void;
};

type DeepPatch<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPatch<T[K]> & Partial<T[K]> : T[K];
};

function patchObj<T extends object>(base: T, patch: DeepPatch<T>): T {
  const next = { ...base };
  for (const key of Object.keys(patch) as (keyof T)[]) {
    const val = patch[key];
    if (val == null) continue;
    const cur = next[key];
    if (typeof cur === 'object' && cur && !Array.isArray(cur) && typeof val === 'object' && !Array.isArray(val)) {
      next[key] = { ...(cur as object), ...(val as object) } as T[keyof T];
    } else {
      next[key] = val as T[keyof T];
    }
  }
  return next;
}

export const useAppearance = create<Store>((set, get) => {
  const boot = load();
  const baseline = resolvedDefaults();
  return {
    slices: boot,
    projectBaseline: baseline,
    patchCurrent: (patch) => {
      const { style, mode } = useAppStore.getState();
      const current = get().slices[style][mode];
      const nextSlice = patchObj(current, patch);
      const slices = cloneSlices(get().slices);
      slices[style][mode] = nextSlice;
      persist(slices);
      set({ slices });
    },
    setCurrent: (slice) => {
      const { style, mode } = useAppStore.getState();
      const slices = cloneSlices(get().slices);
      slices[style][mode] = slice;
      persist(slices);
      set({ slices });
    },
    restoreDefaults: () => {
      const slices = cloneSlices(get().projectBaseline);
      persist(slices);
      set({ slices });
    },
    markProjectSaved: (slices) => {
      persist(slices);
      set({ slices: cloneSlices(slices), projectBaseline: cloneSlices(slices) });
    },
  };
});

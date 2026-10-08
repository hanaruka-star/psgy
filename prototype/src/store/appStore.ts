import { create } from 'zustand';
import { defaultBusiness, type BusinessConfig } from '@/config/business';
import { defaultFeatures, type FeatureFlags } from '@/config/features';
import type { ModeId, StyleId } from '@/theme/presets';
import {
  seedContracts,
  seedGyms,
  seedPts,
  seedReviews,
  seedSessions,
  seedSpas,
  seedWeights,
  ME,
} from '@/data/seed';
import type {
  ChatMsg,
  Contract,
  Greeting,
  Gym,
  LedgerTx,
  NavEntry,
  Noti,
  PT,
  PushToast,
  Review,
  ReviewLevel,
  Role,
  Session,
  SessionSummary,
  Spa,
  Thread,
  Visit,
  WalletTx,
  WeightPoint,
} from '@/domain/types';
import { uid, vnd } from '@/lib/format';
import { applyJump, type ClockJump } from './clock';

const KEY = 'psgy-proto-v2';

export type MapTab = 'all' | 'pt' | 'gym' | 'spa';

type BookingDraft = {
  ptId: string;
  packageId: string;
  useExisting?: boolean;
  dateMs?: number;
  time?: string;
  durationMin: number;
  gymId?: string;
  customPlace?: string;
  payMethod: 'wallet' | 'momo' | 'zalopay' | 'vnpay' | 'card';
  returnToPay?: boolean;
};

type Persist = {
  offsetMs: number;
  frozenNow: number | null;
  features: FeatureFlags;
  business: BusinessConfig;
  pts: PT[];
  gyms: Gym[];
  spas: Spa[];
  contracts: Contract[];
  sessions: Session[];
  reviews: Review[];
  weights: WeightPoint[];
  wallet: number;
  walletTx: WalletTx[];
  ledger: LedgerTx[];
  withdrawn: number;
  threads: Thread[];
  messages: ChatMsg[];
  greetings: Greeting[];
  notis: Noti[];
  saved: { pts: string[]; gyms: string[]; spas: string[] };
  hiddenPts: string[];
  visits: Visit[];
  userStack: NavEntry[];
  ptStack: NavEntry[];
  userTab: string;
  ptTab: string;
  mobileRole: Role;
  style: StyleId;
  mode: ModeId;
  mapTab: MapTab;
  onboardingDone: boolean;
  findWhatSeen: boolean;
  rankingWhy: boolean;
  ptPendingApproval: boolean;
  aiTrialLeftDays: number;
  aiSubscribed: boolean;
  streak: number;
  draft: BookingDraft | null;
  seenPopup: Record<string, boolean>;
};

function boot(now: number): Persist {
  const pts = seedPts(now);
  const sessions = seedSessions(now);
  const contracts = seedContracts(now);
  const price = contracts[0].priceVnd;
  const per = price / 12;
  const feePct = defaultBusiness.fee_pct.gold / 100;
  const ledger: LedgerTx[] = sessions
    .filter((s) => s.status === 'completed')
    .map((s, i) => ({
      id: `ld_${s.id}`,
      sessionId: s.id,
      contractId: s.contractId,
      userName: 'Minh',
      amount: per,
      fee: per * feePct,
      net: per * (1 - feePct),
      status: i < 5 ? 'withdrawable' : 'processing',
      at: s.completedAt ?? now,
      processingUntil: (s.completedAt ?? now) + 3 * 86400000,
    }));
  const heldSessions = 5;
  ledger.push({
    id: 'ld_held_pkg',
    contractId: 'ct_active',
    userName: 'Minh',
    amount: per * heldSessions,
    fee: 0,
    net: per * heldSessions,
    status: 'held',
    at: now,
  });
  return {
    offsetMs: 0,
    frozenNow: now,
    features: { ...defaultFeatures },
    business: { ...defaultBusiness },
    pts,
    gyms: seedGyms(),
    spas: seedSpas(),
    contracts,
    sessions,
    reviews: seedReviews(now),
    weights: seedWeights(now),
    wallet: 8_000_000,
    walletTx: [
      { id: 'w1', kind: 'topup', amount: 12_000_000, note: 'Nạp MoMo', at: now - 60 * 86400000 },
      { id: 'w2', kind: 'pay', amount: -price, note: 'Gói 12 buổi · Nguyễn Văn Long', at: now - 50 * 86400000 },
    ],
    ledger,
    withdrawn: 0,
    threads: [
      { id: 'th_ai', peerId: 'ai', peerName: 'Trợ lý AI', avatar: '/assets/brand/icon_ta.png', kind: 'ai', unread: 1 },
      { id: 'th_pt_01', peerId: 'pt_01', peerName: 'Nguyễn Văn Long', avatar: '/assets/avatars/coach_01.png', kind: 'pt', unread: 0 },
    ],
    messages: [
      {
        id: 'm_ai_1',
        threadId: 'th_ai',
        from: 'ai',
        text: `Chào buổi sáng ${ME.name}! Hôm nay bạn có lịch tập lúc còn ~45 phút với PT Nguyễn Văn Long. Mình có thể giúp gì?`,
        at: now - 60000,
      },
    ],
    greetings: [],
    notis: [],
    saved: { pts: [], gyms: [], spas: [] },
    hiddenPts: [],
    visits: [],
    userStack: [{ id: 'UD1' }],
    ptStack: [{ id: 'PO1' }],
    userTab: 'UD1',
    ptTab: 'PO1',
    mobileRole: 'user',
    style: 'minimal',
    mode: 'light',
    mapTab: 'pt',
    onboardingDone: true,
    findWhatSeen: true,
    rankingWhy: false,
    ptPendingApproval: false,
    aiTrialLeftDays: 2,
    aiSubscribed: false,
    streak: 6,
    draft: null,
    seenPopup: {},
  };
}

function load(): Persist {
  const now = Date.now();
  try {
    const raw = localStorage.getItem(KEY);
    if (!raw) return boot(now);
    const parsed = JSON.parse(raw) as Partial<Persist> & { mobileRole?: string; coachStack?: NavEntry[] };
    const legacyRole = parsed.mobileRole as string | undefined;
    if (legacyRole === 'coach') parsed.mobileRole = 'pt';
    if (!parsed.ptStack && parsed.coachStack) parsed.ptStack = parsed.coachStack;
    return { ...boot(now), ...parsed, mobileRole: parsed.mobileRole === 'pt' ? 'pt' : 'user' };
  } catch {
    return boot(now);
  }
}

function persist(s: Persist) {
  try {
    localStorage.setItem(KEY, JSON.stringify(s));
  } catch {
    /* ignore */
  }
}

export function nowOf(s: { offsetMs: number; frozenNow: number | null }) {
  return (s.frozenNow ?? Date.now()) + s.offsetMs;
}

type Store = Persist & {
  now: () => number;
  toast: PushToast | null;
  setToast: (t: PushToast | null) => void;
  commit: (p: Partial<Persist>) => void;
  push: (role: Role, e: NavEntry) => void;
  pop: (role: Role) => void;
  jump: (role: Role, e: NavEntry) => void;
  setTab: (role: Role, id: string) => void;
  setMobileRole: (r: Role) => void;
  setStyle: (s: StyleId) => void;
  setMode: (m: ModeId) => void;
  setFeature: (k: keyof FeatureFlags, v: boolean) => void;
  setBusiness: (p: Partial<BusinessConfig>) => void;
  setMapTab: (t: MapTab) => void;
  clockJump: (j: ClockJump) => void;
  reset: () => void;
  skipOnboarding: () => void;
  rerunOnboarding: () => void;
  markFindWhat: () => void;
  openPt: (ptId: string) => void;
  toggleSavePt: (id: string) => void;
  hidePt: (id: string) => void;
  undoHide: (id: string) => void;
  setAccepting: (v: boolean) => void;
  setRankingWhy: (v: boolean) => void;
  startBooking: (ptId: string, packageId?: string, useExisting?: boolean) => void;
  patchDraft: (p: Partial<BookingDraft>) => void;
  payBooking: () => string | null;
  confirmContract: (id: string) => void;
  rejectContract: (id: string) => void;
  arrive: (sessionId: string) => void;
  startByPhoto: (sessionId: string) => void;
  requestStart: (sessionId: string) => void;
  confirmStart: (sessionId: string) => void;
  submitSummary: (sessionId: string, sum: SessionSummary) => void;
  confirmComplete: (sessionId: string) => void;
  dispute: (sessionId: string, reason: string) => void;
  addReview: (sessionId: string, level: ReviewLevel, tags: string[], comment: string) => void;
  proposeReschedule: (sessionId: string, startAt: number, by: Role) => void;
  answerReschedule: (sessionId: string, yes: boolean) => void;
  cancelSession: (sessionId: string, by: Role, reason: string) => void;
  reportNoShowPt: (sessionId: string) => void;
  reportNoShowUser: (sessionId: string) => void;
  sendGreeting: (text: string) => void;
  answerGreeting: (id: string, yes: boolean) => void;
  sendCard: (threadId: string, from: 'user' | 'pt', card: ChatMsg['card'], text?: string) => void;
  sendText: (threadId: string, from: 'user' | 'pt' | 'ai', text: string) => void;
  topup: (amount: number, source: string) => void;
  withdraw: (amount: number) => void;
  emptyWallet: () => void;
  forceLastSession: () => void;
  notify: (n: Omit<Noti, 'id' | 'at' | 'read'>) => void;
  tickTimeouts: () => void;
  updatePt: (id: string, patch: Partial<PT>) => void;
  addWeight: (kg: number) => void;
};

function liveStatus(s: Session, now: number, cfg: BusinessConfig): Session['status'] | 'upcoming' | 'due' {
  if (s.status !== 'scheduled') return s.status;
  if (now >= s.startAt) return 'due';
  if (now >= s.startAt - cfg.upcoming_window * 60000) return 'upcoming';
  return 'scheduled';
}

export const useAppStore = create<Store>((set, get) => {
  const init = load();

  const commit = (p: Partial<Persist>) => {
    set(p);
    persist({ ...get() });
  };

  const notify = (n: Omit<Noti, 'id' | 'at' | 'read'>) => {
    const item: Noti = { ...n, id: uid('nt'), at: get().now(), read: false };
    commit({ notis: [item, ...get().notis] });
    set({
      toast: {
        id: item.id,
        role: n.role,
        title: n.title,
        body: n.body,
        screen: n.screen,
        params: n.params,
      },
    });
    window.setTimeout(() => {
      if (get().toast?.id === item.id) set({ toast: null });
    }, 4200);
  };

  const refundWallet = (amount: number, note: string) => {
    commit({
      wallet: get().wallet + amount,
      walletTx: [
        { id: uid('w'), kind: 'refund', amount, note, at: get().now() },
        ...get().walletTx,
      ],
    });
  };

  return {
    ...init,
    toast: null,
    setToast: (toast) => set({ toast }),
    now: () => nowOf(get()),
    commit,
    push: (role, e) => {
      const k = role === 'user' ? 'userStack' : 'ptStack';
      commit({ [k]: [...get()[k], e] });
    },
    pop: (role) => {
      const k = role === 'user' ? 'userStack' : 'ptStack';
      const st = get()[k];
      if (st.length <= 1) return;
      commit({ [k]: st.slice(0, -1) });
    },
    jump: (role, e) => {
      const k = role === 'user' ? 'userStack' : 'ptStack';
      const tabs = role === 'user' ? USER_TABS : PT_TABS;
      commit({
        [k]: [e],
        ...(tabs.includes(e.id)
          ? role === 'user'
            ? { userTab: e.id }
            : { ptTab: e.id }
          : {}),
      });
    },
    setTab: (role, id) => {
      if (role === 'user') commit({ userTab: id, userStack: [{ id }] });
      else commit({ ptTab: id, ptStack: [{ id }] });
    },
    setMobileRole: (mobileRole) => commit({ mobileRole }),
    setStyle: (style) => commit({ style }),
    setMode: (mode) => commit({ mode }),
    setFeature: (k, v) => commit({ features: { ...get().features, [k]: v } }),
    setBusiness: (p) => commit({ business: { ...get().business, ...p } }),
    setMapTab: (mapTab) => commit({ mapTab }),
    clockJump: (j) => {
      const today = get().sessions.find((s) => s.id === 'ss_today' || s.status === 'scheduled' || s.status === 'training');
      const next = applyJump(get().now(), Date.now(), today?.startAt ?? null, j);
      const frozen = get().frozenNow ?? Date.now();
      commit({ offsetMs: next - frozen, frozenNow: frozen });
      queueMicrotask(() => get().tickTimeouts());
    },
    reset: () => {
      const next = boot(Date.now());
      set({ ...next, toast: null });
      persist(next);
    },
    skipOnboarding: () => commit({ onboardingDone: true, findWhatSeen: true, userStack: [{ id: 'UD1' }], userTab: 'UD1' }),
    rerunOnboarding: () =>
      commit({
        onboardingDone: false,
        findWhatSeen: false,
        userStack: [{ id: 'UO1' }],
        userTab: 'UD1',
      }),
    markFindWhat: () => commit({ findWhatSeen: true }),
    openPt: (ptId) => {
      const now = get().now();
      const visits = [...get().visits, { ptId, at: now }];
      commit({ visits });
      get().push('user', { id: 'UP1', params: { ptId } });
    },
    toggleSavePt: (id) => {
      const pts = get().saved.pts.includes(id)
        ? get().saved.pts.filter((x) => x !== id)
        : [...get().saved.pts, id];
      commit({ saved: { ...get().saved, pts } });
    },
    hidePt: (id) => commit({ hiddenPts: [...get().hiddenPts, id] }),
    undoHide: (id) => commit({ hiddenPts: get().hiddenPts.filter((x) => x !== id) }),
    setAccepting: (v) =>
      commit({
        pts: get().pts.map((p) => (p.id === 'pt_01' ? { ...p, accepting: v } : p)),
      }),
    setRankingWhy: (rankingWhy) => commit({ rankingWhy }),
    startBooking: (ptId, packageId, useExisting) => {
      const now = get().now();
      commit({
        draft: {
          ptId,
          packageId: packageId ?? get().pts.find((p) => p.id === ptId)?.packages[0].id ?? '',
          useExisting,
          durationMin: 60,
          payMethod: 'wallet',
          dateMs: now + 2 * 86400000,
          time: '18:00',
        },
      });
      get().push('user', { id: 'UB1', params: { ptId } });
    },
    patchDraft: (p) => commit({ draft: { ...(get().draft as BookingDraft), ...p } }),
    payBooking: () => {
      const d = get().draft;
      if (!d) return 'Thiếu thông tin đặt lịch';
      const pt = get().pts.find((p) => p.id === d.ptId);
      const pack = pt?.packages.find((x) => x.id === d.packageId);
      if (!pt || !pack) return 'Thiếu gói';
      if (d.useExisting) {
        const ct = get().contracts.find((c) => c.ptId === d.ptId && c.status === 'active');
        if (!ct) return 'Không có gói đang có';
        addPendingSession(get, commit, notify, ct, d);
        return null;
      }
      if (d.payMethod === 'wallet' && get().wallet < pack.priceVnd) {
        commit({ draft: { ...d, returnToPay: true } });
        get().push('user', { id: 'UW1' });
        return 'WALLET';
      }
      const now = get().now();
      if (d.payMethod === 'wallet') {
        commit({
          wallet: get().wallet - pack.priceVnd,
          walletTx: [
            { id: uid('w'), kind: 'pay', amount: -pack.priceVnd, note: `${pack.name} · ${pt.name}`, at: now },
            ...get().walletTx,
          ],
        });
      }
      const ct: Contract = {
        id: uid('ct'),
        kind: 'pt',
        ptId: pt.id,
        userName: ME.name,
        packageName: pack.name,
        sessions: pack.sessions,
        done: 0,
        priceVnd: pack.priceVnd,
        perWeek: pack.perWeek,
        status: 'pending',
        createdAt: now,
      };
      const fee = 0;
      commit({
        contracts: [ct, ...get().contracts],
        ledger: [
          {
            id: uid('ld'),
            contractId: ct.id,
            userName: ME.name,
            amount: pack.priceVnd,
            fee,
            net: pack.priceVnd,
            status: 'held',
            at: now,
          },
          ...get().ledger,
        ],
      });
      addPendingSession(get, commit, notify, ct, d);
      notify({
        role: 'pt',
        group: 'Booking',
        title: 'Hợp đồng mới',
        body: `${ME.name} đặt ${pack.name}`,
        screen: 'PC1',
      });
      notify({
        role: 'user',
        group: 'Thanh toán',
        title: 'Thanh toán thành công',
        body: 'Đang chờ PT xác nhận trong 24 giờ.',
        screen: 'UB6',
      });
      return null;
    },
    confirmContract: (id) => {
      const ct = get().contracts.find((c) => c.id === id);
      if (!ct) return;
      commit({
        contracts: get().contracts.map((c) => (c.id === id ? { ...c, status: 'active' } : c)),
        sessions: get().sessions.map((s) =>
          s.contractId === id && s.status === 'pendingConfirm' ? { ...s, status: 'scheduled' } : s,
        ),
      });
      notify({
        role: 'user',
        group: 'Booking',
        title: 'PT đã xác nhận',
        body: 'Lịch tập của bạn đã được xác nhận.',
        screen: 'USS1',
        params: { sessionId: get().sessions.find((s) => s.contractId === id)?.id ?? '' },
      });
      get().jump('pt', { id: 'PC2', params: { threadId: `th_${ct.ptId}` } });
    },
    rejectContract: (id) => {
      const ct = get().contracts.find((c) => c.id === id);
      if (!ct) return;
      commit({
        contracts: get().contracts.map((c) => (c.id === id ? { ...c, status: 'cancelled' } : c)),
        sessions: get().sessions.map((s) =>
          s.contractId === id ? { ...s, status: 'cancelled', cancelBy: 'pt', cancelReason: 'Từ chối' } : s,
        ),
        ledger: get().ledger.map((l) =>
          l.contractId === id && l.status === 'held' ? { ...l, status: 'refunded' } : l,
        ),
      });
      refundWallet(ct.priceVnd, `Hoàn ${ct.packageName}`);
      notify({
        role: 'user',
        group: 'Booking',
        title: 'PT từ chối hợp đồng',
        body: `Đã hoàn ${vnd(ct.priceVnd)} vào ${'Ví PSGymer'}.`,
        screen: 'UW1',
      });
    },
    arrive: (sessionId) => {
      const s = get().sessions.find((x) => x.id === sessionId);
      if (!s) return;
      const late = Math.max(0, Math.round((get().now() - s.startAt) / 60000));
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, arrivedAt: get().now(), lateMin: late } : x,
        ),
      });
      notify({
        role: 'user',
        group: 'Buổi tập',
        title: late ? `PT đến trễ ${late} phút` : 'PT đã đến',
        body: 'Hãy chờ PT xác nhận buổi tập.',
        screen: 'USS1',
        params: { sessionId },
      });
    },
    startByPhoto: (sessionId) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId
            ? { ...x, status: 'training', trainedAt: get().now(), startPhoto: '/assets/journal/gym-01.jpg' }
            : x,
        ),
      });
    },
    requestStart: (sessionId) => {
      notify({
        role: 'user',
        group: 'Buổi tập',
        title: 'Yêu cầu bắt đầu buổi tập',
        body: 'PT Nguyễn Văn Long gửi yêu cầu bắt đầu.',
        screen: 'USS1',
        params: { sessionId },
      });
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, note: 'awaitStart' } : x,
        ),
      });
    },
    confirmStart: (sessionId) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, status: 'training', trainedAt: get().now(), note: undefined } : x,
        ),
      });
    },
    submitSummary: (sessionId, sum) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, status: 'awaitingUserComplete', summary: sum } : x,
        ),
      });
      notify({
        role: 'user',
        group: 'Buổi tập',
        title: 'Buổi tập đã kết thúc',
        body: 'Xem tổng kết của PT và xác nhận hoàn thành.',
        screen: 'USS1',
        params: { sessionId },
      });
    },
    confirmComplete: (sessionId) => {
      completeSession(get, commit, notify, sessionId);
      get().push('user', { id: 'UR2', params: { sessionId } });
    },
    dispute: (sessionId, reason) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, status: 'disputed', cancelReason: reason } : x,
        ),
        ledger: get().ledger.map((l) =>
          l.sessionId === sessionId ? { ...l, status: 'disputed' } : l,
        ),
      });
    },
    addReview: (sessionId, level, tags, comment) => {
      const s = get().sessions.find((x) => x.id === sessionId);
      if (!s) return;
      commit({
        reviews: [
          {
            id: uid('rv'),
            ptId: s.ptId,
            sessionId,
            level,
            tags,
            comment,
            at: get().now(),
            reviewer: ME.name,
          },
          ...get().reviews,
        ],
      });
      const ct = get().contracts.find((c) => c.id === s.contractId);
      const last = ct && ct.done >= ct.sessions;
      get().jump('user', { id: last ? 'USE2' : 'USE1', params: { sessionId } });
    },
    proposeReschedule: (sessionId, startAt, by) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, proposedStartAt: startAt, note: `reschedule:${by}` } : x,
        ),
      });
      notify({
        role: by === 'user' ? 'pt' : 'user',
        group: 'Đổi lịch',
        title: 'Đề xuất đổi lịch',
        body: 'Có yêu cầu đổi giờ buổi tập.',
        screen: by === 'user' ? 'PW1' : 'USS1',
        params: { sessionId },
      });
    },
    answerReschedule: (sessionId, yes) => {
      const s = get().sessions.find((x) => x.id === sessionId);
      if (!s) return;
      if (yes && s.proposedStartAt) {
        commit({
          sessions: get().sessions.map((x) =>
            x.id === sessionId
              ? { ...x, startAt: s.proposedStartAt!, proposedStartAt: undefined, status: 'scheduled', note: undefined }
              : x,
          ),
        });
      } else {
        commit({
          sessions: get().sessions.map((x) =>
            x.id === sessionId ? { ...x, proposedStartAt: undefined, note: undefined } : x,
          ),
        });
      }
    },
    cancelSession: (sessionId, by, reason) => {
      const s = get().sessions.find((x) => x.id === sessionId);
      if (!s) return;
      const hours = (s.startAt - get().now()) / 3600000;
      const cfg = get().business;
      const pct = by === 'pt' ? 100 : hours >= cfg.cancel_full_refund_hours ? 100 : hours >= cfg.cancel_forfeit_hours ? 50 : 0;
      const ct = get().contracts.find((c) => c.id === s.contractId);
      const share = ct ? ct.priceVnd / ct.sessions : 0;
      const refund = (share * pct) / 100;
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId
            ? { ...x, status: 'cancelled', cancelBy: by, cancelReason: reason, refundPct: pct }
            : x,
        ),
      });
      if (refund > 0) {
        refundWallet(refund, `Hoàn buổi ${s.index}/${s.total}`);
        commit({
          ledger: get().ledger.map((l) => {
            if (l.contractId === s.contractId && l.status === 'held') {
              return { ...l, amount: l.amount - refund, net: l.net - refund };
            }
            return l;
          }),
        });
      }
      if (by === 'pt') {
        commit({
          pts: get().pts.map((p) =>
            p.id === s.ptId ? { ...p, trust: Math.max(0, p.trust - cfg.pt_cancel_trust_penalty) } : p,
          ),
        });
        notify({
          role: 'user',
          group: 'Buổi tập',
          title: 'PT đã huỷ buổi tập',
          body: `Hoàn ${pct}% (${vnd(refund)}) về ví.`,
          screen: 'UW1',
        });
      }
    },
    reportNoShowPt: (sessionId) => {
      const s = get().sessions.find((x) => x.id === sessionId);
      if (!s) return;
      get().cancelSession(sessionId, 'pt', 'PT không đến');
      commit({
        sessions: get().sessions.map((x) => (x.id === sessionId ? { ...x, status: 'noShowPt' } : x)),
      });
    },
    reportNoShowUser: (sessionId) => {
      commit({
        sessions: get().sessions.map((x) =>
          x.id === sessionId ? { ...x, status: 'noShowUser', cancelBy: 'pt', cancelReason: 'User không đến' } : x,
        ),
      });
      notify({
        role: 'user',
        group: 'Buổi tập',
        title: 'PT báo bạn không đến',
        body: 'Buổi tập bị tính no-show. Bạn có thể báo cáo nếu sai.',
        screen: 'USS1',
        params: { sessionId },
      });
    },
    sendGreeting: (text) => {
      const g: Greeting = { id: uid('gr'), ptId: 'pt_01', text, status: 'pending' };
      commit({ greetings: [g, ...get().greetings] });
      notify({
        role: 'user',
        group: 'Chat',
        title: 'PT muốn gửi lời chào',
        body: text,
        screen: 'UC1',
      });
    },
    answerGreeting: (id, yes) => {
      commit({
        greetings: get().greetings.map((g) =>
          g.id === id ? { ...g, status: yes ? 'accepted' : 'skipped' } : g,
        ),
      });
      if (yes) get().jump('user', { id: 'UC2', params: { threadId: 'th_pt_01' } });
    },
    sendCard: (threadId, from, card, text) => {
      commit({
        messages: [
          ...get().messages,
          { id: uid('m'), threadId, from, card, text, at: get().now() },
        ],
      });
    },
    sendText: (threadId, from, text) => {
      commit({
        messages: [...get().messages, { id: uid('m'), threadId, from, text, at: get().now() }],
      });
      if (from === 'user' && threadId === 'th_ai') {
        const sponsored = get().features.monetization
          ? '\n\n—'
          : '';
        commit({
          messages: [
            ...get().messages,
            {
              id: uid('m'),
              threadId,
              from: 'ai',
              text:
                'Mình gợi ý: uống đủ nước, ăn nhẹ trước buổi 45–60 phút, khởi động 5 phút. (Câu trả lời mẫu.)' +
                sponsored,
              at: get().now() + 400,
            },
          ],
        });
      }
    },
    topup: (amount, source) => {
      commit({
        wallet: get().wallet + amount,
        walletTx: [
          { id: uid('w'), kind: 'topup', amount, note: `Nạp ${source}`, at: get().now() },
          ...get().walletTx,
        ],
      });
      const d = get().draft;
      if (d?.returnToPay) {
        get().pop('user');
        commit({ draft: { ...d, returnToPay: false } });
      }
    },
    withdraw: (amount) => {
      const avail = get().ledger.filter((l) => l.status === 'withdrawable').reduce((a, l) => a + l.net, 0);
      if (amount > avail || amount < get().business.min_withdraw) return;
      commit({
        withdrawn: get().withdrawn + amount,
        ledger: get().ledger.map((l) => (l.status === 'withdrawable' ? { ...l, status: 'withdrawn' } : l)),
      });
      notify({
        role: 'pt',
        group: 'Thanh toán',
        title: 'Rút tiền thành công',
        body: `Dự kiến nhận ${vnd(amount)} trong 1–2 ngày làm việc.`,
        screen: 'PI3',
      });
    },
    emptyWallet: () => commit({ wallet: 0 }),
    forceLastSession: () => {
      const ct = get().contracts.find((c) => c.id === 'ct_active');
      if (!ct) return;
      commit({
        contracts: get().contracts.map((c) => (c.id === 'ct_active' ? { ...c, done: 11 } : c)),
        sessions: get().sessions.map((s) => (s.id === 'ss_today' ? { ...s, index: 12 } : s)),
      });
    },
    notify,
    tickTimeouts: () => {
      const now = get().now();
      const cfg = get().business;
      for (const ct of get().contracts) {
        if (ct.status === 'pending' && now - ct.createdAt > cfg.pt_response_timeout * 60000) {
          commit({
            contracts: get().contracts.map((c) => (c.id === ct.id ? { ...c, status: 'cancelled' } : c)),
            sessions: get().sessions.map((s) =>
              s.contractId === ct.id ? { ...s, status: 'cancelled', cancelReason: 'Quá 24 giờ' } : s,
            ),
            ledger: get().ledger.map((l) =>
              l.contractId === ct.id && l.status === 'held' ? { ...l, status: 'refunded' } : l,
            ),
          });
          refundWallet(ct.priceVnd, 'Tự huỷ — PT không phản hồi 24 giờ');
          notify({
            role: 'user',
            group: 'Booking',
            title: 'Hợp đồng tự huỷ',
            body: 'PT không xác nhận trong 24 giờ. Đã hoàn ví.',
            screen: 'UW1',
          });
        }
      }
      for (const s of get().sessions) {
        if (
          s.status === 'awaitingUserComplete' &&
          now - (s.trainedAt ?? s.startAt) > cfg.completion_confirm_timeout * 60000
        ) {
          completeSession(get, commit, notify, s.id, true);
        }
      }
      const due = get().ledger.filter(
        (l) => l.status === 'processing' && l.processingUntil && now >= l.processingUntil,
      );
      if (due.length) {
        commit({
          ledger: get().ledger.map((l) =>
            l.status === 'processing' && l.processingUntil && now >= l.processingUntil
              ? { ...l, status: 'withdrawable' as const }
              : l,
          ),
        });
        notify({
          role: 'pt',
          group: 'Thanh toán',
          title: 'Tiền có thể rút',
          body: `${vnd(due.reduce((a, l) => a + l.net, 0))} đã qua đối soát.`,
          screen: 'PI1',
        });
      }
      commit({
        pts: get().pts.map((p) => ({
          ...p,
          album: p.album.map((ph) =>
            ph.expiresAt < now && ph.status === 'approved' ? { ...ph, status: 'expired' as const } : ph,
          ),
        })),
      });
    },
    updatePt: (id, patch) => commit({ pts: get().pts.map((p) => (p.id === id ? { ...p, ...patch } : p)) }),
    addWeight: (kg) => commit({ weights: [...get().weights, { at: get().now(), kg }] }),
  };
});

export const USER_TABS = ['UD1', 'UM1', 'UC1', 'UCA1', 'UPF1'];
export const PT_TABS = ['PO1', 'PW1', 'PC1', 'PI1', 'PM1'];

function addPendingSession(
  get: () => Store,
  commit: (p: Partial<Persist>) => void,
  _notify: Store['notify'],
  ct: Contract,
  d: BookingDraft,
) {
  const start = d.dateMs && d.time
    ? new Date(d.dateMs)
    : new Date(get().now() + 2 * 86400000);
  if (d.time) {
    const [h, m] = d.time.split(':').map(Number);
    start.setHours(h, m, 0, 0);
  }
  const gym = get().gyms.find((g) => g.id === d.gymId);
  const ss: Session = {
    id: uid('ss'),
    contractId: ct.id,
    ptId: ct.ptId,
    userName: ME.name,
    index: ct.done + 1,
    total: ct.sessions,
    startAt: start.getTime(),
    durationMin: d.durationMin,
    locationLabel: gym?.name ?? d.customPlace ?? 'Địa điểm đã chọn',
    gymId: d.gymId,
    status: ct.status === 'active' ? 'scheduled' : 'pendingConfirm',
  };
  commit({ sessions: [ss, ...get().sessions] });
}

function completeSession(
  get: () => Store,
  commit: (p: Partial<Persist>) => void,
  notify: Store['notify'],
  sessionId: string,
  auto = false,
) {
  const s = get().sessions.find((x) => x.id === sessionId);
  if (!s || s.status === 'completed') return;
  const ct = get().contracts.find((c) => c.id === s.contractId);
  const per = ct ? ct.priceVnd / ct.sessions : 0;
  const pt = get().pts.find((p) => p.id === s.ptId);
  const pct = (pt ? get().business.fee_pct[pt.tier] : 12) / 100;
  const now = get().now();
  commit({
    sessions: get().sessions.map((x) =>
      x.id === sessionId ? { ...x, status: 'completed', completedAt: now } : x,
    ),
    contracts: get().contracts.map((c) =>
      c.id === s.contractId
        ? { ...c, done: Math.min(c.sessions, c.done + 1), status: c.done + 1 >= c.sessions ? 'completed' : c.status }
        : c,
    ),
    streak: get().streak + 1,
    ledger: [
      {
        id: uid('ld'),
        sessionId,
        contractId: s.contractId,
        userName: ME.name,
        amount: per,
        fee: per * pct,
        net: per * (1 - pct),
        status: 'processing',
        at: now,
        processingUntil: now + get().business.payout_hold_days * 86400000,
      },
      ...get().ledger.map((l) =>
        l.contractId === s.contractId && l.status === 'held'
          ? { ...l, amount: Math.max(0, l.amount - per), net: Math.max(0, l.net - per) }
          : l,
      ),
    ],
  });
  if (!auto) {
    notify({
      role: 'pt',
      group: 'Buổi tập',
      title: 'Khách xác nhận hoàn thành',
      body: 'Tiền buổi chuyển sang Đang xử lý.',
      screen: 'PI1',
    });
  }
}

export function moneyCheck(s: Persist) {
  const paid = s.walletTx.filter((t) => t.kind === 'pay').reduce((a, t) => a - t.amount, 0);
  const held = s.ledger.filter((l) => l.status === 'held').reduce((a, l) => a + l.amount, 0);
  const processing = s.ledger.filter((l) => l.status === 'processing').reduce((a, l) => a + l.net, 0);
  const withdrawable = s.ledger.filter((l) => l.status === 'withdrawable').reduce((a, l) => a + l.net, 0);
  const withdrawn = s.ledger.filter((l) => l.status === 'withdrawn').reduce((a, l) => a + l.net, 0);
  const fee = s.ledger.filter((l) => l.status !== 'held' && l.status !== 'refunded').reduce((a, l) => a + l.fee, 0);
  const refunded = s.walletTx.filter((t) => t.kind === 'refund').reduce((a, t) => a + t.amount, 0);
  const right = held + processing + withdrawable + withdrawn + fee + refunded;
  return { paid, held, processing, withdrawable, withdrawn, fee, refunded, right, ok: Math.abs(paid - right) < 2 };
}

export function sessionView(s: Session, now: number, cfg: BusinessConfig) {
  return liveStatus(s, now, cfg);
}

/** Stable clock for React subscribe — never call `s.now()` inside a selector. */
export function useNow() {
  const frozenNow = useAppStore((s) => s.frozenNow);
  const offsetMs = useAppStore((s) => s.offsetMs);
  return (frozenNow ?? Date.now()) + offsetMs;
}

export { ME };

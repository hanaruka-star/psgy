import { useMemo, useState } from 'react';
import { Chip } from '@/components/Chip';
import { DraggableSheet } from '@/components/Sheet';
import { LeafletMap, type LeafletMarker } from '@/components/LeafletMap';
import { tilesFor } from '@/config/map';
import { useAppStore } from '@/store/appStore';
import type { PT } from '@/domain/types';

export function UM1_Map() {
  const pts = useAppStore((s) => s.pts);
  const gyms = useAppStore((s) => s.gyms);
  const spas = useAppStore((s) => s.spas);
  const tab = useAppStore((s) => s.mapTab);
  const setMapTab = useAppStore((s) => s.setMapTab);
  const features = useAppStore((s) => s.features);
  const pending = useAppStore((s) => s.ptPendingApproval);
  const mode = useAppStore((s) => s.mode);
  const style = useAppStore((s) => s.style);
  const hidden = useAppStore((s) => s.hiddenPts);
  const openPt = useAppStore((s) => s.openPt);
  const push = useAppStore((s) => s.push);
  const [cluster, setCluster] = useState<string | null>(null);
  const [pick, setPick] = useState<PT | null>(null);
  const palette = mode === 'dark' || style === 'night' ? 'dark' : 'light';
  const tiles = tilesFor(palette);

  const visiblePts = pts.filter((p) => p.approved && !hidden.includes(p.id) && !(pending && p.id === 'pt_01'));
  const showSpa = features.spa;
  const tabs = [
    ['all', 'All'],
    ['pt', 'PT'],
    ['gym', 'Gym'],
    ...(showSpa ? [['spa', 'Spa'] as const] : []),
  ] as const;

  const markers: LeafletMarker[] = useMemo(() => {
    const list: LeafletMarker[] = [];
    const addPt = (p: PT) =>
      list.push({
        id: p.id,
        lat: p.lat,
        lng: p.lng,
        html: `<div class="coach-pin"><img src="${p.avatar}" alt=""/></div>`,
        iconSize: [40, 40],
        iconAnchor: [20, 40],
        onClick: () => setPick(p),
      });
    if (tab === 'all' || tab === 'pt') visiblePts.forEach(addPt);
    if (tab === 'all' || tab === 'gym') {
      gyms.forEach((g) =>
        list.push({
          id: g.id,
          lat: g.lat,
          lng: g.lng,
          html: `<div class="gym-pin ${g.linked ? 'partner' : 'collected'}"><span class="material-symbols-outlined" style="font-size:16px">fitness_center</span></div>`,
          iconSize: [26, 26],
          iconAnchor: [13, 26],
          onClick: () => push('user', { id: 'UG1', params: { gymId: g.id } }),
        }),
      );
    }
    if (showSpa && (tab === 'all' || tab === 'spa')) {
      spas.forEach((s) =>
        list.push({
          id: s.id,
          lat: s.lat,
          lng: s.lng,
          html: `<div class="gym-pin partner"><span class="material-symbols-outlined" style="font-size:16px">spa</span></div>`,
          iconSize: [26, 26],
          iconAnchor: [13, 26],
          onClick: () => push('user', { id: 'US1', params: { spaId: s.id } }),
        }),
      );
    }
    if (list.length >= 4 && tab !== 'gym') {
      const cell = new Map<string, typeof list>();
      for (const m of list.filter((x) => x.id.startsWith('pt_'))) {
        const k = `${m.lat.toFixed(2)}_${m.lng.toFixed(2)}`;
        const arr = cell.get(k) ?? [];
        arr.push(m);
        cell.set(k, arr);
      }
      const clustered: LeafletMarker[] = [];
      const rest = list.filter((x) => !x.id.startsWith('pt_'));
      cell.forEach((arr, k) => {
        if (arr.length >= 3) {
          clustered.push({
            id: `cl_${k}`,
            lat: arr[0].lat,
            lng: arr[0].lng,
            html: `<div style="width:44px;height:44px;border-radius:99px;background:var(--primary);color:var(--on-primary);display:grid;place-items:center;font-weight:700">${arr.length}</div>`,
            iconSize: [44, 44],
            iconAnchor: [22, 22],
            onClick: () => setCluster(`Cụm ${arr.length} — ${arr.length} PT ở gần nhau`),
          });
        } else clustered.push(...arr);
      });
      return [...clustered, ...rest];
    }
    return list;
  }, [tab, visiblePts, gyms, spas, showSpa, push]);

  const cards =
    tab === 'gym' ? gyms : tab === 'spa' ? spas : visiblePts.slice().sort((a, b) => (b.featured ? 1 : 0) - (a.featured ? 1 : 0));

  return (
    <div className="relative h-full">
      <div className="pointer-events-none absolute inset-x-0 top-0 z-30 p-3">
        <div className="pointer-events-auto">
          <div className="type-title">Tìm Gym/PT</div>
          <div className="mt-2 flex gap-1">
            {tabs.map(([id, label]) => (
              <Chip key={id} selected={tab === id} onClick={() => setMapTab(id)}>
                {label}
              </Chip>
            ))}
          </div>
          <div className="mt-2 flex gap-1 overflow-x-auto">
            <Chip>Bán kính 3 km ▾</Chip>
            {tab === 'pt' && (
              <Chip bg="var(--success-container)" fg="var(--success-on)">
                Còn lịch hôm nay
              </Chip>
            )}
            {tab === 'gym' && <Chip>Còn chỗ trống</Chip>}
          </div>
        </div>
      </div>
      <LeafletMap
        className="absolute inset-0 z-0 h-full w-full"
        center={[10.7769, 106.7009]}
        zoom={12.2}
        tileUrl={tiles.url}
        attribution={tiles.attribution}
        markers={markers}
      />
      {cluster && (
        <button
          type="button"
          className="absolute left-1/2 top-40 z-30 -translate-x-1/2 rounded-full bg-[var(--nav-bar)] px-4 py-2 type-body shadow-[var(--shadow-card)]"
          onClick={() => setCluster(null)}
        >
          {cluster}
        </button>
      )}
      {pick && (
        <div className="absolute inset-x-3 bottom-40 z-30 app-card p-3">
          {features.monetization && pick.featured && (
            <div className="mb-1"><span className="pill-featured">Nổi bật</span></div>
          )}
          <div className="font-bold">{pick.name} · ★ {pick.stars.toFixed(1)}</div>
          <div className="type-caption">{pick.distanceKm} km · Hoạt động quanh khu vực này</div>
          {!pick.accepting && <div className="type-caption mt-1">Tạm ngưng nhận khách</div>}
          <div className="mt-2 flex gap-2">
            <button
              type="button"
              className="flex-1 rounded-[var(--radius-md)] border py-2"
              onClick={() => openPt(pick.id)}
            >
              Xem profile
            </button>
            <button
              type="button"
              disabled={!pick.accepting}
              className="flex-1 rounded-[var(--radius-md)] bg-[var(--primary)] py-2 text-[var(--on-primary)] disabled:opacity-40"
              onClick={() => pick.accepting && useAppStore.getState().startBooking(pick.id)}
            >
              {pick.accepting ? 'Đặt lịch' : 'Tạm ngưng'}
            </button>
          </div>
          <button type="button" className="mt-1 type-caption" onClick={() => setPick(null)}>
            Đóng
          </button>
        </div>
      )}
      <DraggableSheet title={`${visiblePts.length} PT quanh bạn`}>
        <div className="flex gap-3 overflow-x-auto pb-2">
          {tab !== 'gym' && tab !== 'spa'
            ? (cards as PT[]).map((p) => (
                <button
                  key={p.id}
                  type="button"
                  className="app-card w-40 shrink-0 p-2 text-left"
                  onClick={() => setPick(p)}
                >
                  <img src={p.avatar} alt="" className="h-24 w-full rounded-[var(--radius-sm)] object-cover" />
                  {features.monetization && p.featured && (
                    <div className="mt-1"><span className="pill-featured">Nổi bật</span></div>
                  )}
                  <div className="font-semibold">{p.name}</div>
                  <div className="type-caption">★ {p.stars.toFixed(1)} · {p.distanceKm} km</div>
                  {!p.accepting && <div className="type-caption" style={{ color: 'var(--danger-on)' }}>Tạm ngưng nhận khách</div>}
                </button>
              ))
            : tab === 'gym'
              ? gyms.map((g) => (
                  <button
                    key={g.id}
                    type="button"
                    className="app-card w-40 shrink-0 p-2 text-left"
                    onClick={() => push('user', { id: 'UG1', params: { gymId: g.id } })}
                  >
                    <img src={g.photo} alt="" className="h-24 w-full rounded object-cover" />
                    <div className="font-semibold">{g.name}</div>
                    <div className="type-caption">{g.openNow ? 'Đang mở cửa' : 'Đóng cửa'}</div>
                  </button>
                ))
              : spas.map((s) => (
                  <button
                    key={s.id}
                    type="button"
                    className="app-card w-40 shrink-0 p-2 text-left"
                    onClick={() => push('user', { id: 'US1', params: { spaId: s.id } })}
                  >
                    <img src={s.photo} alt="" className="h-24 w-full rounded object-cover" />
                    <div className="font-semibold">{s.name}</div>
                    <div className="type-caption">{s.offer}</div>
                  </button>
                ))}
        </div>
      </DraggableSheet>
    </div>
  );
}

export function UG1_Gym({ params }: { params?: Record<string, string> }) {
  const gym = useAppStore((s) => s.gyms.find((g) => g.id === params?.gymId) ?? s.gyms[0]);
  const pop = useAppStore((s) => s.pop);
  return (
    <div className="p-4">
      <button type="button" onClick={() => pop('user')}>←</button>
      <img src={gym.photo} alt="" className="mt-2 h-40 w-full rounded-[var(--radius-md)] object-cover" />
      <h1 className="type-title mt-2">{gym.name}</h1>
      {gym.featured && <Chip>Nổi bật</Chip>}
      <p className="type-body">{gym.address}</p>
      <p className="type-caption">{gym.hours} · ★ {gym.rating.toFixed(1)}</p>
      <div className="mt-2 flex flex-wrap gap-1">
        {gym.amenities.map((a) => (
          <Chip key={a}>{a}</Chip>
        ))}
      </div>
      {gym.memberships.map((m) => (
        <div key={m.name} className="app-card mt-2 p-3">
          {m.name} · {m.priceVnd.toLocaleString('vi-VN')}đ
        </div>
      ))}
    </div>
  );
}

export function US1_Spa({ params }: { params?: Record<string, string> }) {
  const spa = useAppStore((s) => s.spas.find((g) => g.id === params?.spaId) ?? s.spas[0]);
  const pop = useAppStore((s) => s.pop);
  return (
    <div className="p-4">
      <button type="button" onClick={() => pop('user')}>←</button>
      <img src={spa.photo} alt="" className="mt-2 h-40 w-full rounded object-cover" />
      <h1 className="type-title mt-2">{spa.name}</h1>
      <p>{spa.offer}</p>
      {spa.services.map((s) => (
        <div key={s.name} className="app-card mt-2 p-3">
          {s.name} · {s.priceVnd.toLocaleString('vi-VN')}đ
        </div>
      ))}
    </div>
  );
}

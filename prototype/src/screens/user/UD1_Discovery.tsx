import { useMemo, useRef, useState } from 'react';
import { Chip } from '@/components/Chip';
import { Icon } from '@/components/Icon';
import { ME, useAppStore, useNow } from '@/store/appStore';
import type { PT } from '@/domain/types';

function visiblePhotos(pt: PT, now: number) {
  return pt.album.filter((p) => p.status === 'approved' && p.expiresAt > now);
}

export function UD1_Discovery() {
  const pts = useAppStore((s) => s.pts);
  const hidden = useAppStore((s) => s.hiddenPts);
  const now = useNow();
  const features = useAppStore((s) => s.features);
  const rankingWhy = useAppStore((s) => s.rankingWhy);
  const pending = useAppStore((s) => s.ptPendingApproval);
  const openPt = useAppStore((s) => s.openPt);
  const toggleSavePt = useAppStore((s) => s.toggleSavePt);
  const saved = useAppStore((s) => s.saved.pts);
  const hidePt = useAppStore((s) => s.hidePt);
  const undoHide = useAppStore((s) => s.undoHide);
  const push = useAppStore((s) => s.push);
  const [menu, setMenu] = useState<string | null>(null);
  const [undo, setUndo] = useState<string | null>(null);
  const [photoI, setPhotoI] = useState<Record<string, number>>({});
  const scroller = useRef<HTMLDivElement>(null);

  const feed = useMemo(() => {
    const list = pts.filter((p) => p.approved && p.id !== (pending ? 'pt_01' : '') && !hidden.includes(p.id));
    const bands = [
      list.filter((p) => p.distanceKm <= 3),
      list.filter((p) => p.distanceKm > 3 && p.distanceKm <= 7),
      list.filter((p) => p.distanceKm > 7),
    ];
    return bands.flat();
  }, [pts, hidden, pending]);

  const sponsored = features.monetization ? feed.find((p) => p.boosted) : null;

  return (
    <div className="relative h-full bg-black">
      <div ref={scroller} className="h-full snap-y snap-mandatory overflow-y-auto">
        {sponsored && (
          <div className="px-4 py-2 text-center text-[11px] text-white/80">Được tài trợ</div>
        )}
        {feed.map((pt) => {
          const photos = visiblePhotos(pt, now);
          const i = photoI[pt.id] ?? 0;
          const photo = photos[i] ?? { url: pt.avatar };
          const why =
            pt.distanceKm <= 3 ? 'Nhóm ≤ 3 km · chưa xem' : pt.distanceKm <= 7 ? 'Nhóm 3–7 km' : 'Nhóm > 7 km';
          return (
            <section key={pt.id} className="relative h-full snap-start">
              <img src={photo.url} alt="" className="h-full w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/30" />
              <div className="absolute top-10 left-0 right-0 flex justify-center gap-1">
                {photos.map((_, idx) => (
                  <span
                    key={idx}
                    className="h-1 w-6 rounded-full"
                    style={{ background: idx === i ? 'white' : 'rgb(255 255 255 / 0.35)' }}
                  />
                ))}
              </div>
              <button
                type="button"
                className="absolute left-2 top-1/2 -translate-y-1/2 text-white"
                onClick={() => setPhotoI((s) => ({ ...s, [pt.id]: Math.max(0, i - 1) }))}
              >
                <Icon name="chevron_left" size={36} />
              </button>
              <button
                type="button"
                className="absolute right-2 top-1/2 -translate-y-1/2 text-white"
                onClick={() =>
                  setPhotoI((s) => ({ ...s, [pt.id]: Math.min(photos.length - 1, i + 1) }))
                }
              >
                <Icon name="chevron_right" size={36} />
              </button>
              <div className="absolute bottom-24 left-4 right-16 text-white">
                <button type="button" className="flex items-center gap-2" onClick={() => openPt(pt.id)}>
                  <img src={pt.avatar} alt="" className="h-12 w-12 rounded-full object-cover" />
                  <div className="text-left">
                    <div className="flex items-center gap-1 font-bold">
                      {pt.name} {pt.verified && <Icon name="verified" size={16} />}
                    </div>
                    <div className="text-[12px] opacity-80">PT · {pt.distanceKm} km</div>
                  </div>
                </button>
                {rankingWhy && <div className="mt-2 text-[11px] text-lime-200">{why}</div>}
                {!pt.accepting && (
                  <Chip className="mt-2" bg="var(--danger-container)" fg="var(--danger-on)">
                    Tạm ngưng nhận khách
                  </Chip>
                )}
              </div>
              <div className="absolute bottom-24 right-3 flex flex-col gap-3 text-white">
                <button type="button" onClick={() => toggleSavePt(pt.id)}>
                  <Icon name="favorite" filled={saved.includes(pt.id)} size={28} />
                  <div className="text-[10px]">Lưu PT</div>
                </button>
                <button type="button" onClick={() => setMenu(pt.id)}>
                  <Icon name="more_vert" size={28} />
                </button>
              </div>
            </section>
          );
        })}
      </div>
      {menu && (
        <div className="absolute inset-0 z-40 bg-black/40" onClick={() => setMenu(null)}>
          <div
            className="absolute inset-x-0 bottom-0 space-y-2 rounded-t-[var(--radius-xl)] bg-[var(--sheet)] p-4"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              type="button"
              className="w-full py-3 text-left font-semibold"
              onClick={() => {
                push('user', { id: 'UR1', params: { ptId: menu } });
                setMenu(null);
              }}
            >
              Báo cáo
            </button>
            <button
              type="button"
              className="w-full py-3 text-left font-semibold"
              onClick={() => {
                hidePt(menu);
                setUndo(menu);
                setMenu(null);
              }}
            >
              Không thích PT này
            </button>
            <button type="button" className="w-full py-3 text-left" onClick={() => setMenu(null)}>
              Huỷ
            </button>
          </div>
        </div>
      )}
      {undo && (
        <div className="absolute inset-x-3 bottom-28 z-40 flex items-center justify-between rounded-xl bg-[var(--on-surface)] px-3 py-2 text-[var(--bg)]">
          <span>Đã ẩn PT. {ME.name} sẽ ít thấy hơn.</span>
          <button
            type="button"
            className="font-bold"
            onClick={() => {
              undoHide(undo);
              setUndo(null);
            }}
          >
            Hoàn tác
          </button>
        </div>
      )}
    </div>
  );
}

export function UR1_Report({ params }: { params?: Record<string, string> }) {
  const pop = useAppStore((s) => s.pop);
  const [sent, setSent] = useState(false);
  const reasons = [
    'Hình ảnh không phù hợp',
    'Thông tin sai sự thật',
    'Có hành vi quấy rối',
    'Lừa đảo / Trục lợi',
    'Giả mạo',
    'Khác',
  ];
  const [r, setR] = useState(reasons[0]);
  if (sent) {
    return (
      <div className="grid h-full place-items-center p-6 text-center">
        <div>
          <div className="type-title">Cảm ơn bạn đã báo cáo</div>
          <button type="button" className="mt-4 text-[var(--primary-text)]" onClick={() => pop('user')}>
            Đóng
          </button>
        </div>
      </div>
    );
  }
  return (
    <div className="p-4">
      <div className="type-title mb-3">Báo cáo PT này {params?.ptId ?? ''}</div>
      {reasons.map((x) => (
        <label key={x} className="mb-2 flex gap-2">
          <input type="radio" checked={r === x} onChange={() => setR(x)} />
          {x}
        </label>
      ))}
      <button
        type="button"
        className="mt-4 h-12 w-full rounded-[var(--radius-md)] bg-[var(--primary)] text-[var(--on-primary)]"
        onClick={() => setSent(true)}
      >
        Gửi báo cáo
      </button>
    </div>
  );
}

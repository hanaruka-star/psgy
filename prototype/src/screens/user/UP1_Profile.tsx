import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { useAppStore, useNow } from '@/store/appStore';
import { vnd } from '@/lib/format';
import { useState } from 'react';

export function UP1_Profile({ params }: { params?: Record<string, string> }) {
  const pt = useAppStore((s) => s.pts.find((p) => p.id === (params?.ptId ?? 'pt_01')) ?? s.pts[0]);
  const pop = useAppStore((s) => s.pop);
  const startBooking = useAppStore((s) => s.startBooking);
  const push = useAppStore((s) => s.push);
  const toggleSavePt = useAppStore((s) => s.toggleSavePt);
  const features = useAppStore((s) => s.features);
  const now = useNow();
  const reviewsAll = useAppStore((s) => s.reviews);
  const reviews = reviewsAll.filter((r) => r.ptId === pt.id);
  const [tab, setTab] = useState<'info' | 'img'>('info');
  const photos = pt.album.filter((p) => p.status === 'approved' && p.expiresAt > now);

  return (
    <Screen
      title={pt.name}
      onBack={() => pop('user')}
      actions={
        <>
          <button type="button" className="px-2" onClick={() => toggleSavePt(pt.id)}>
            ❤
          </button>
          <button type="button" className="px-2" onClick={() => push('user', { id: 'UR1', params: { ptId: pt.id } })}>
            ⋮
          </button>
        </>
      }
      footer={
        <div className="flex items-center gap-2 border-t px-3 py-3">
          <div className="flex-1 type-caption">Từ {vnd(pt.priceFrom)} / buổi</div>
          <button type="button" className="h-11 w-11 rounded-full bg-[var(--tag)]" onClick={() => push('user', { id: 'UC2', params: { threadId: `th_${pt.id}` } })}>
            💬
          </button>
          <Button
            disabled={!pt.accepting}
            onClick={() => startBooking(pt.id)}
          >
            {pt.accepting ? 'Đặt lịch ngay' : 'Tạm ngưng'}
          </Button>
        </div>
      }
    >
      <div className="flex gap-3 px-4 pt-2">
        <img src={pt.avatar} alt="" className="h-28 w-28 rounded-[var(--radius-md)] object-cover" />
        <div>
          <div className="type-title">{pt.name}</div>
          <Chip>PT {pt.badge}</Chip>
          <div className="type-caption mt-1">Uy tín {pt.trust}/100 · Cách bạn {pt.distanceKm} km</div>
        </div>
      </div>
      <div className="mt-3 flex flex-wrap gap-1 px-4">
        {pt.specialties.map((s) => (
          <Chip key={s}>{s}</Chip>
        ))}
      </div>
      <div className="px-4 type-body mt-2">Từ {vnd(pt.priceFrom)}/buổi · Còn lịch hôm nay 18:00</div>
      <div className="mt-3 flex gap-2 px-4">
        <Chip selected={tab === 'info'} onClick={() => setTab('info')}>Thông tin</Chip>
        <Chip selected={tab === 'img'} onClick={() => setTab('img')}>Hình ảnh</Chip>
      </div>
      {tab === 'info' ? (
        <div className="space-y-3 p-4">
          <Block title="Phù hợp với ai" body={pt.fitFor.map((x) => `• ${x}`).join('\n')} />
          <div className="app-card p-3">
            <div className="font-semibold mb-2">Gói tập / Dịch vụ</div>
            {pt.packages.filter((p) => features.groupPackages || p.kind === 'personal').map((p) => (
              <button
                key={p.id}
                type="button"
                className="flex w-full justify-between py-2"
                onClick={() => startBooking(pt.id, p.id)}
              >
                <span>{p.name}</span>
                <span>{vnd(p.priceVnd)}</span>
              </button>
            ))}
          </div>
          <Block title="Uy tín & Hoạt động" body={`Đã xác minh · ${pt.sessionsTaught} buổi · ${pt.onTimePct}% đúng lịch`} />
          <div className="app-card p-3">
            <div className="font-semibold">Đánh giá khách hàng</div>
            <div>★ {pt.stars.toFixed(1)} / {pt.reviewCount} đánh giá</div>
            {reviews.map((r) => (
              <div key={r.id} className="mt-2 type-caption">
                {r.reviewer}: {r.level} · {r.tags.join(', ')}
                <div>{r.comment}</div>
              </div>
            ))}
          </div>
          <Block title="Kinh nghiệm & Chứng chỉ" body={pt.certs.map((c) => c.name).join(' · ')} />
          <Block title="Giới thiệu" body={pt.intro} />
          {features.studentResults &&
            pt.studentResults.map((r) => (
              <div key={r.label} className="app-card p-3">
                <div className="font-semibold">{r.label}</div>
                <div className="grid grid-cols-2 gap-2 mt-1">
                  <img src={r.before} alt="" className="h-24 w-full object-cover rounded" />
                  <img src={r.after} alt="" className="h-24 w-full object-cover rounded" />
                </div>
                <p className="type-caption mt-1">{r.summary}</p>
              </div>
            ))}
        </div>
      ) : (
        <div className="grid grid-cols-3 gap-1 p-2">
          {photos.map((p) => (
            <img key={p.id} src={p.url} alt="" className="h-28 w-full object-cover" />
          ))}
        </div>
      )}
    </Screen>
  );
}

function Block({ title, body }: { title: string; body: string }) {
  return (
    <div className="app-card p-3">
      <div className="font-semibold">{title} ›</div>
      <p className="type-body whitespace-pre-line text-[var(--on-surface-variant)]">{body}</p>
    </div>
  );
}

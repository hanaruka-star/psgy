import { useMemo, useState } from 'react';
import { AppBar } from '@/components/AppBar';
import { Button } from '@/components/Button';
import { Card } from '@/components/Card';
import { Chip } from '@/components/Chip';
import { Icon } from '@/components/Icon';
import {
  coachById,
  formatReviewDate,
  reviewsFor,
  tagStyle,
  vnWeekday,
} from '@/data/catalog';
import { useAppStore } from '@/store/appStore';
import type { Role } from '@/types';

type Props = { role: Role; params?: Record<string, string> };

export function U09_CoachDetail({ role, params }: Props) {
  const coach = coachById(params?.coachId ?? 'coach_01');
  const reviews = reviewsFor(coach.id);
  const pop = useAppStore((s) => s.pop);
  const push = useAppStore((s) => s.push);
  const features = useAppStore((s) => s.features);
  const stack = useAppStore((s) => s.userStack);
  const [slide, setSlide] = useState(0);
  const [tab, setTab] = useState<'svc' | 'pkg'>('svc');
  const [serviceId, setServiceId] = useState(coach.services[0]?.id);
  const [lightbox, setLightbox] = useState<string | null>(null);
  const photos = coach.photoUrls?.length ? coach.photoUrls : [coach.avatarAsset];

  const avg = coach.rating;
  const bars = useMemo(() => {
    const counts = [0, 0, 0, 0, 0];
    for (const r of reviews) counts[r.rating - 1] += 1;
    return counts;
  }, [reviews]);
  const maxBar = Math.max(1, ...bars);

  const slotsByDay = useMemo(() => {
    const map = new Map<number, { startTime: string; endTime: string }[]>();
    for (let i = 0; i < 7; i++) map.set(i, []);
    for (const s of coach.weeklyAvailability) {
      const list = map.get(s.offsetDays) ?? [];
      list.push(s);
      map.set(s.offsetDays, list);
    }
    return map;
  }, [coach]);

  return (
    <div className="relative flex h-full flex-col">
      <AppBar title={coach.name} onBack={stack.length > 1 ? () => pop(role) : undefined} />
      <div className="no-scrollbar min-h-0 flex-1 overflow-y-auto pb-4">
        <div className="relative h-[240px] bg-[var(--tag)]">
          <img
            src={photos[slide]}
            alt=""
            className="h-full w-full object-cover"
          />
          <div className="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5">
            {photos.map((_, i) => (
              <button
                key={i}
                type="button"
                aria-label={`${i + 1}/${photos.length}`}
                onClick={() => setSlide(i)}
                className="h-2 w-2 rounded-full"
                style={{
                  background: i === slide ? 'var(--primary)' : 'rgb(255 255 255 / 0.7)',
                }}
              />
            ))}
          </div>
        </div>

        <div className="space-y-5 px-4 pt-4">
          <div>
            <h1 className="text-[24px] font-bold leading-[1.25] tracking-[-0.3px]">
              {coach.name}
            </h1>
            <div className="mt-1 flex items-center gap-1 text-[12px] text-[var(--on-surface-variant)]">
              <Icon name="star" filled size={14} style={{ color: 'var(--highlight)' }} />
              {avg.toFixed(1)} · {reviews.length} đánh giá · {coach.yearsExperience} năm
              kinh nghiệm · {coach.totalBookings} lượt booking
            </div>
          </div>

          <section>
            <h2 className="mb-1 text-[16px] font-semibold">Về tôi</h2>
            <p className="text-[14px] leading-[1.45] text-[var(--on-surface-variant)]">
              {coach.bio}
            </p>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Mục tiêu</h2>
            <div className="flex flex-wrap gap-2">
              {coach.goals.map((g) => (
                <Chip key={g} bg={tagStyle[g]?.bg} fg={tagStyle[g]?.fg}>
                  {g}
                </Chip>
              ))}
            </div>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Đối tượng</h2>
            <div className="flex flex-wrap gap-2">
              {coach.targetAudience.map((g) => (
                <Chip key={g} bg={tagStyle[g]?.bg} fg={tagStyle[g]?.fg}>
                  {g}
                </Chip>
              ))}
            </div>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Hình thức</h2>
            <div className="flex flex-wrap gap-2">
              {coach.trainingFormats.map((g) => (
                <Chip key={g} bg="var(--tag)" fg="var(--on-surface)">
                  {g}
                </Chip>
              ))}
            </div>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Lịch trống</h2>
            <div className="grid grid-cols-7 gap-1">
              {Array.from({ length: 7 }, (_, i) => {
                const slots = slotsByDay.get(i) ?? [];
                return (
                  <div
                    key={i}
                    className="rounded-[var(--radius-sm)] bg-[var(--tag)] px-1 py-2 text-center"
                  >
                    <div className="text-[11px] font-semibold">{vnWeekday(i)}</div>
                    {slots.length === 0 ? (
                      <div className="mt-1 text-[10px] text-[var(--on-surface-variant)]">
                        —
                      </div>
                    ) : (
                      slots.map((s) => (
                        <div
                          key={`${s.startTime}-${s.endTime}`}
                          className="mt-1 text-[9px] font-semibold leading-tight text-[var(--highlight)]"
                        >
                          {s.startTime}–{s.endTime}
                        </div>
                      ))
                    )}
                  </div>
                );
              })}
            </div>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Chọn dịch vụ</h2>
            <div className="mb-3 flex gap-2">
              <Chip selected={tab === 'svc'} onClick={() => setTab('svc')}>
                Dịch vụ
              </Chip>
              {features.packages && (
                <Chip selected={tab === 'pkg'} onClick={() => setTab('pkg')}>
                  Gói
                </Chip>
              )}
            </div>
            {tab === 'svc' &&
              coach.services.map((s) => (
                <label
                  key={s.id}
                  className="app-card mb-2 flex cursor-pointer items-start gap-3 p-3"
                >
                  <input
                    type="radio"
                    name="svc"
                    checked={serviceId === s.id}
                    onChange={() => setServiceId(s.id)}
                    className="mt-1"
                  />
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <span className="font-semibold">{s.name}</span>
                      {features.promoRibbon && s.promoLabel && (
                        <span className="rounded-[8px] bg-[var(--primary)] px-2 py-0.5 text-[10px] font-bold text-[var(--on-primary)]">
                          {s.promoLabel}
                        </span>
                      )}
                    </div>
                    <div className="text-[12px] text-[var(--on-surface-variant)]">
                      {s.priceLabel} · {s.durationMinutes} phút
                    </div>
                  </div>
                </label>
              ))}
            {tab === 'pkg' && features.packages && (
              <>
                {coach.packages.length === 0 && (
                  <p className="text-[14px] text-[var(--on-surface-variant)]">
                    Coach này chưa có gói.
                  </p>
                )}
                {coach.packages.map((p) => {
                  const per = p.totalPriceVnd / p.sessionCount;
                  const single = coach.services[0]?.priceVnd ?? per;
                  const save = Math.round((1 - per / single) * 100);
                  return (
                    <Card key={p.id} className="mb-2">
                      <div className="flex items-center gap-2">
                        <span className="font-semibold">{p.name}</span>
                        {features.promoRibbon && save > 0 && (
                          <span className="rounded-[8px] bg-[var(--primary)] px-2 py-0.5 text-[10px] font-bold text-[var(--on-primary)]">
                            Tiết kiệm {save}%
                          </span>
                        )}
                      </div>
                      <div className="text-[12px] text-[var(--on-surface-variant)]">
                        {p.sessionCount} buổi · {p.priceLabel}
                      </div>
                      <p className="mt-1 text-[13px]">{p.description}</p>
                      <Button variant="outline" className="mt-2">
                        Mua
                      </Button>
                    </Card>
                  );
                })}
              </>
            )}
          </section>

          <p className="text-[14px] font-medium">
            {coach.gymFeeIncluded
              ? 'Đã bao gồm chi phí phòng gym'
              : `Chưa bao gồm chi phí phòng gym${
                  coach.membershipFeeLabel ? ` · ${coach.membershipFeeLabel}` : ''
                }`}
          </p>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Địa điểm tập</h2>
            {coach.trainingLocations.map((loc) => (
              <Card key={loc.name + loc.address} className="mb-2">
                <Chip bg="var(--tag)" className="mb-1">
                  {loc.type}
                </Chip>
                <div className="font-semibold">{loc.name}</div>
                <div className="text-[12px] text-[var(--on-surface-variant)]">
                  {loc.address}
                </div>
              </Card>
            ))}
          </section>

          {features.studentResults && coach.studentResults.length > 0 && (
            <section>
              <h2 className="mb-2 text-[16px] font-semibold">Kết quả học viên</h2>
              {coach.studentResults.map((r, i) => (
                <Card key={r.studentLabel} className="mb-3">
                  <div className="grid grid-cols-2 gap-2">
                    <figure>
                      <img
                        src={r.beforeImageUrl}
                        alt="Trước"
                        className="h-28 w-full rounded-[var(--radius-sm)] object-cover"
                      />
                      <figcaption className="mt-1 text-center text-[11px]">
                        Trước
                      </figcaption>
                    </figure>
                    <figure>
                      <img
                        src={r.afterImageUrl}
                        alt="Sau"
                        className="h-28 w-full rounded-[var(--radius-sm)] object-cover"
                      />
                      <figcaption className="mt-1 text-center text-[11px]">
                        Sau
                      </figcaption>
                    </figure>
                  </div>
                  <div className="mt-2 font-semibold">{r.studentLabel}</div>
                  <p className="text-[13px] text-[var(--on-surface-variant)]">
                    {r.summary}
                  </p>
                  <Button
                    variant="text"
                    onClick={() =>
                      push(role, {
                        id: 'U18',
                        params: { coachId: coach.id, resultIndex: String(i) },
                      })
                    }
                  >
                    Xem chi tiết
                  </Button>
                </Card>
              ))}
            </section>
          )}

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Certification</h2>
            <div className="flex flex-wrap gap-2">
              {coach.certifications.map((c, i) => (
                <Chip
                  key={c}
                  onClick={() =>
                    setLightbox(
                      coach.certificationPhotos?.[i] ??
                        coach.certificationPhotos?.[0] ??
                        photos[0],
                    )
                  }
                >
                  {c}
                </Chip>
              ))}
            </div>
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Đánh giá</h2>
            {reviews.length === 0 ? (
              <p className="text-[14px] text-[var(--on-surface-variant)]">
                Chưa có đánh giá.
              </p>
            ) : (
              <>
                <p className="mb-2 text-[14px]">
                  {avg.toFixed(1)}/5 · {reviews.length} đánh giá
                </p>
                {[5, 4, 3, 2, 1].map((star) => (
                  <div key={star} className="mb-1 flex items-center gap-2 text-[12px]">
                    <span className="w-6">{star}★</span>
                    <div className="h-2 flex-1 overflow-hidden rounded-full bg-[var(--tag)]">
                      <div
                        className="h-full bg-[var(--highlight)]"
                        style={{ width: `${(bars[star - 1] / maxBar) * 100}%` }}
                      />
                    </div>
                    <span className="w-6 text-right">{bars[star - 1]}</span>
                  </div>
                ))}
              </>
            )}
          </section>

          <section>
            <h2 className="mb-2 text-[16px] font-semibold">Bình luận khách hàng</h2>
            {reviews.map((r) => (
              <Card key={r.id} className="mb-2">
                <div className="flex items-center justify-between">
                  <span className="font-semibold">{r.reviewerName}</span>
                  <span className="text-[12px] text-[var(--on-surface-variant)]">
                    {formatReviewDate(r.date)}
                  </span>
                </div>
                <div className="my-1 flex">
                  {Array.from({ length: 5 }, (_, i) => (
                    <Icon
                      key={i}
                      name="star"
                      filled={i < r.rating}
                      size={14}
                      style={{
                        color: i < r.rating ? 'var(--highlight)' : 'var(--outline-variant)',
                      }}
                    />
                  ))}
                </div>
                <p className="text-[13px]">{r.comment}</p>
              </Card>
            ))}
          </section>

          <section className="pb-4">
            <h2 className="mb-1 text-[16px] font-semibold">
              Chính sách booking/cancellation
            </h2>
            <p className="text-[14px] text-[var(--on-surface-variant)]">
              {coach.bookingCancellationPolicy}
            </p>
          </section>
        </div>
      </div>

      <div className="shrink-0 border-t border-[var(--outline-variant)]/40 bg-[var(--nav-bar)] px-4 py-3">
        <Button
          block
          onClick={() =>
            push(role, {
              id: 'U10',
              params: { coachId: coach.id, serviceId: serviceId ?? '' },
            })
          }
        >
          Chọn HLV
        </Button>
      </div>

      {lightbox && (
        <button
          type="button"
          className="absolute inset-0 z-40 flex items-center justify-center bg-black/80 p-4"
          onClick={() => setLightbox(null)}
        >
          <img
            src={lightbox}
            alt="Certification"
            className="max-h-full max-w-full object-contain"
          />
        </button>
      )}
    </div>
  );
}

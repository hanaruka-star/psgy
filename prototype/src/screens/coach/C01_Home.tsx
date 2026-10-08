import { AppBar } from '@/components/AppBar';
import { Avatar } from '@/components/Avatar';
import { Button } from '@/components/Button';
import { Card } from '@/components/Card';
import { Chip } from '@/components/Chip';
import { Icon } from '@/components/Icon';
import { coachSession, statusChip } from '@/data/catalog';
import { locationLabel, useAppStore } from '@/store/appStore';
import type { Role } from '@/types';

type Props = { role: Role; params?: Record<string, string> };

export function C01_Home({ role }: Props) {
  const push = useAppStore((s) => s.push);
  const bookings = useAppStore((s) => s.bookings);
  const isAvailableNow = useAppStore((s) => s.isAvailableNow);
  const toggleAvailable = useAppStore((s) => s.toggleAvailable);
  const locationIndex = useAppStore((s) => s.locationIndex);
  const cycleLocation = useAppStore((s) => s.cycleLocation);
  const features = useAppStore((s) => s.features);
  const profile = coachSession.profile;
  const hours = profile.hoursLabel;
  const pending = bookings.filter((b) => b.status === 'pending');
  const active = bookings.filter(
    (b) =>
      b.status === 'inProgress' ||
      b.status === 'confirmed' ||
      b.status === 'awaitingUserConfirmation',
  );

  return (
    <div className="flex h-full flex-col">
      <AppBar
        logoSrc="/assets/brand/gymps_logo_coach.svg"
        actions={
          <>
            <button
              type="button"
              title="Chỉnh sửa hồ sơ"
              className="press grid h-11 w-11 place-items-center"
              onClick={() => push(role, { id: 'C06' })}
            >
              <Icon name="edit" />
            </button>
            {features.journal && (
              <button
                type="button"
                title="Nhật ký học viên"
                className="press grid h-11 w-11 place-items-center"
                onClick={() => push(role, { id: 'C07' })}
              >
                <Icon name="auto_stories" />
              </button>
            )}
            <button
              type="button"
              title="Dịch vụ"
              className="press grid h-11 w-11 place-items-center"
              onClick={() => push(role, { id: 'C05' })}
            >
              <Icon name="fitness_center" />
            </button>
          </>
        }
      />
      <div className="no-scrollbar flex-1 overflow-y-auto px-4 pb-6">
        <div className="flex items-center gap-3">
          <Avatar src="/assets/avatars/coach_01.png" initials="NL" size={72} />
          <div>
            <h1 className="text-[20px] font-bold">{profile.name}</h1>
            <div className="flex items-center gap-1 text-[13px] text-[var(--on-surface-variant)]">
              <Icon name="star" filled size={14} style={{ color: 'var(--highlight)' }} />
              {profile.ratingAvg} · {profile.ratingCount} đánh giá
            </div>
          </div>
        </div>
        <Button
          variant="text"
          icon={<Icon name="edit" size={18} />}
          className="mt-1"
          onClick={() => push(role, { id: 'C06' })}
        >
          Chỉnh sửa hồ sơ
        </Button>

        <Card className="mt-4">
          <div className="flex items-center justify-between gap-3">
            <div>
              <div className="font-semibold">Đang rảnh</div>
              <div className="text-[13px] text-[var(--on-surface-variant)]">
                Khung giờ {hours}
              </div>
            </div>
            <button
              type="button"
              role="switch"
              aria-checked={isAvailableNow}
              className={`switch ${isAvailableNow ? 'on' : ''}`}
              onClick={toggleAvailable}
            >
              <i />
            </button>
          </div>
          <div className="my-3 h-px bg-[var(--outline-variant)]/50" />
          <div className="text-[16px] font-semibold">Vị trí hiện tại</div>
          <p className="mt-1 text-[16px]">{locationLabel(locationIndex)}</p>
          <Button
            variant="outline"
            className="mt-3"
            icon={<Icon name="my_location" size={18} />}
            onClick={cycleLocation}
          >
            Cập nhật vị trí
          </Button>
        </Card>

        {active.length > 0 && (
          <>
            <h2 className="mb-2 mt-6 text-[16px] font-semibold">Booking đang diễn ra</h2>
            {active.map((b) => (
              <button
                key={b.id}
                type="button"
                className="press mb-2 w-full text-left"
                onClick={() =>
                  push(role, { id: b.status === 'pending' ? 'C03' : 'C02', params: { bookingId: b.id } })
                }
              >
                <BookingRow
                  initials={b.userAvatarInitials}
                  name={b.userName}
                  meta={`${b.serviceName} · ${b.priceLabel}`}
                  time={b.requestedTimeLabel}
                  status={b.status}
                  statusLabel={b.statusLabel}
                />
              </button>
            ))}
          </>
        )}

        <h2 className="mb-2 mt-6 text-[16px] font-semibold">
          Booking mới cần xác nhận
        </h2>
        {pending.length === 0 ? (
          <p className="text-[14px] text-[var(--on-surface-variant)]">
            Không có yêu cầu mới.
          </p>
        ) : (
          pending.map((b) => (
            <button
              key={b.id}
              type="button"
              className="press mb-2 w-full text-left"
              onClick={() => push(role, { id: 'C03', params: { bookingId: b.id } })}
            >
              <BookingRow
                initials={b.userAvatarInitials}
                name={b.userName}
                meta={`${b.serviceName} · ${b.priceLabel}`}
                time={b.requestedTimeLabel}
                status={b.status}
                statusLabel={b.statusLabel}
              />
            </button>
          ))
        )}
      </div>
    </div>
  );
}

function BookingRow({
  initials,
  name,
  meta,
  time,
  status,
  statusLabel,
}: {
  initials: string;
  name: string;
  meta: string;
  time: string;
  status: string;
  statusLabel: string;
}) {
  const chip = statusChip(status);
  return (
    <Card className="flex items-center gap-3">
      <Avatar initials={initials} size={40} />
      <div className="min-w-0 flex-1">
        <div className="flex items-center justify-between gap-2">
          <span className="truncate font-semibold">{name}</span>
          <Chip bg={chip.bg} fg={chip.fg}>
            {statusLabel}
          </Chip>
        </div>
        <div className="text-[13px] text-[var(--on-surface-variant)]">{meta}</div>
        <div className="text-[12px] text-[var(--on-surface-variant)]">{time}</div>
      </div>
    </Card>
  );
}

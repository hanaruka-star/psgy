import { useMemo, useState } from 'react';
import { AppBar } from '@/components/AppBar';
import { Chip } from '@/components/Chip';
import { Avatar } from '@/components/Avatar';
import { DraggableSheet } from '@/components/Sheet';
import { Icon } from '@/components/Icon';
import { LeafletMap, type LeafletMarker } from '@/components/LeafletMap';
import { tilesFor } from '@/config/map';
import { coaches, gyms, mapsDirUrl } from '@/data/catalog';
import { useAppStore } from '@/store/appStore';
import type { Gym, Role } from '@/types';

const CENTER: [number, number] = [10.7769, 106.7009];

function openDirections(lat: number, lng: number) {
  window.open(mapsDirUrl(lat, lng), '_blank', 'noopener,noreferrer');
}

function GymCard({ gym, onDirections }: { gym: Gym; onDirections: () => void }) {
  return (
    <div className="app-card mb-3 flex gap-3 p-3">
      <div className="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-[var(--tag)]">
        <Icon name="fitness_center" />
      </div>
      <div className="min-w-0 flex-1">
        <div className="font-semibold">{gym.name}</div>
        <div className="text-[12px] text-[var(--on-surface-variant)]">{gym.address}</div>
        <div className="mt-1 flex items-center gap-2">
          <Chip
            bg={
              gym.gymSourceType === 'hệ thống'
                ? 'color-mix(in srgb, var(--highlight) 18%, transparent)'
                : 'var(--tag)'
            }
            fg={
              gym.gymSourceType === 'hệ thống'
                ? 'var(--highlight)'
                : 'var(--on-surface-variant)'
            }
          >
            {gym.gymSourceType}
          </Chip>
          <button
            type="button"
            className="press inline-flex items-center gap-1 text-[12px] font-semibold text-[var(--primary-text)]"
            onClick={onDirections}
          >
            <Icon name="directions" size={16} />
            Chỉ đường
          </button>
        </div>
      </div>
    </div>
  );
}

export function U07_Map({ role }: { role: Role; params?: Record<string, string> }) {
  const features = useAppStore((s) => s.features);
  const layer = useAppStore((s) => s.mapLayer);
  const setMapLayer = useAppStore((s) => s.setMapLayer);
  const push = useAppStore((s) => s.push);
  const mode = useAppStore((s) => s.mode);
  const style = useAppStore((s) => s.style);
  const showGymFilter = features.gymFilter;
  const effectiveLayer = showGymFilter ? layer : 'coach';
  const [selectedGym, setSelectedGym] = useState<string | null>(null);
  const palette = mode === 'dark' || style === 'dark' ? 'dark' : 'light';
  const tiles = tilesFor(palette);
  const selected = gyms.find((g) => g.id === selectedGym);

  const markers: LeafletMarker[] = useMemo(() => {
    if (effectiveLayer === 'coach') {
      return coaches.map((c) => ({
        id: c.id,
        lat: c.lat,
        lng: c.lng,
        html: `<div class="coach-pin"><img src="${c.avatarAsset}" alt="" /></div>`,
        iconSize: [40, 40] as [number, number],
        iconAnchor: [20, 40] as [number, number],
        onClick: () => push(role, { id: 'U09', params: { coachId: c.id } }),
      }));
    }
    return gyms.map((g) => {
      const cls = g.gymSourceType === 'hệ thống' ? 'partner' : 'collected';
      return {
        id: g.id,
        lat: g.lat,
        lng: g.lng,
        html: `<div class="gym-pin ${cls}"><span class="material-symbols-outlined" style="font-size:16px">fitness_center</span></div>`,
        iconSize: [26, 26] as [number, number],
        iconAnchor: [13, 26] as [number, number],
        onClick: () => setSelectedGym(g.id),
      };
    });
  }, [effectiveLayer, push, role]);

  return (
    <div className="relative flex h-full flex-col">
      <div className="pointer-events-none absolute inset-x-0 top-0 z-30">
        <div className="pointer-events-auto">
          <AppBar logoSrc="/assets/brand/gymps_logo.svg" />
          {showGymFilter && (
            <div className="flex gap-2 px-4 pb-2">
              <Chip
                selected={effectiveLayer === 'coach'}
                onClick={() => {
                  setMapLayer('coach');
                  setSelectedGym(null);
                }}
              >
                Coach
              </Chip>
              <Chip
                selected={effectiveLayer === 'gym'}
                onClick={() => setMapLayer('gym')}
              >
                Phòng gym
              </Chip>
            </div>
          )}
          {effectiveLayer === 'gym' && (
            <div className="mx-4 mb-2 rounded-[var(--radius-sm)] bg-[var(--nav-bar)]/90 px-3 py-2 text-[11px] leading-snug shadow-sm backdrop-blur">
              <div className="flex items-center gap-2">
                <span className="inline-block h-3 w-3 rounded-[3px] bg-[var(--highlight)]" />
                Hệ thống — đối tác PSgy
              </div>
              <div className="mt-1 flex items-center gap-2">
                <span className="inline-block h-3 w-3 rounded-[3px] bg-[var(--tab-inactive)]" />
                Thu thập — chỉ tham khảo
              </div>
            </div>
          )}
        </div>
      </div>

      <LeafletMap
        className="absolute inset-0 z-0 h-full w-full"
        center={CENTER}
        zoom={12.2}
        tileUrl={tiles.url}
        attribution={tiles.attribution}
        markers={markers}
      />
      <div className="pointer-events-none absolute right-2 z-20 max-w-[70%] rounded bg-[var(--nav-bar)]/85 px-1.5 py-0.5 text-[9px] leading-tight text-[var(--on-surface-variant)] backdrop-blur"
        style={{ bottom: '41%' }}
      >
        © Stadia Maps, © OpenMapTiles, © OpenStreetMap
      </div>

      <DraggableSheet
        title={effectiveLayer === 'coach' ? 'Coach gần bạn' : 'Phòng gym'}
      >
        {effectiveLayer === 'coach'
          ? coaches.map((c) => (
              <button
                key={c.id}
                type="button"
                className="press app-card mb-3 flex w-full items-center gap-3 p-3 text-left"
                onClick={() => push(role, { id: 'U09', params: { coachId: c.id } })}
              >
                <Avatar src={c.avatarAsset} initials={c.initials} size={56} />
                <div className="min-w-0 flex-1">
                  <div className="font-semibold">{c.name}</div>
                  <div className="flex items-center gap-1 text-[12px] text-[var(--on-surface-variant)]">
                    <Icon
                      name="star"
                      filled
                      size={14}
                      style={{ color: 'var(--highlight)' }}
                    />
                    {c.rating.toFixed(1)} · {c.distanceKm.toFixed(1)} km
                  </div>
                  <div className="mt-1">
                    <Chip bg="var(--tag)" fg="var(--highlight)">
                      {c.nextSlotLabel}
                    </Chip>
                  </div>
                </div>
              </button>
            ))
          : gyms.map((g) => (
              <GymCard
                key={g.id}
                gym={g}
                onDirections={() => openDirections(g.lat, g.lng)}
              />
            ))}
        {selected && effectiveLayer === 'gym' && (
          <div className="mb-3 rounded-[var(--radius-md)] border border-[var(--primary)] p-1">
            <GymCard
              gym={selected}
              onDirections={() => openDirections(selected.lat, selected.lng)}
            />
          </div>
        )}
      </DraggableSheet>
    </div>
  );
}

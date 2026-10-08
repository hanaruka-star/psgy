export type MapPalette = 'light' | 'dark';

const ATTRIBUTION =
  '&copy; <a href="https://stadiamaps.com/" target="_blank" rel="noreferrer">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/" target="_blank" rel="noreferrer">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noreferrer">OpenStreetMap</a>';

function withOptionalKey(url: string) {
  const key = (import.meta.env.VITE_MAP_TILE_KEY as string | undefined)?.trim();
  if (!key) return url;
  const join = url.includes('?') ? '&' : '?';
  return `${url}${join}api_key=${encodeURIComponent(key)}`;
}

/** Stadia Alidade Smooth — tối giản (đường + tên đường/phường). Localhost không cần key. */
export const mapConfig = {
  provider: 'stadia' as const,
  needsKeyOffLocalhost: true,
  attribution: ATTRIBUTION,
  light: {
    url: withOptionalKey(
      'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
    ),
  },
  dark: {
    url: withOptionalKey(
      'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
    ),
  },
};

export function tilesFor(palette: MapPalette) {
  const pack = palette === 'dark' ? mapConfig.dark : mapConfig.light;
  return { url: pack.url, attribution: mapConfig.attribution };
}

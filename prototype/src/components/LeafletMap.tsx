import { useEffect, useRef } from 'react';
import L from 'leaflet';

export type LeafletMarker = {
  id: string;
  lat: number;
  lng: number;
  html: string;
  iconSize: [number, number];
  iconAnchor: [number, number];
  onClick?: () => void;
};

type Props = {
  center: [number, number];
  zoom: number;
  tileUrl: string;
  attribution: string;
  markers: LeafletMarker[];
  className?: string;
};

export function LeafletMap({
  center,
  zoom,
  tileUrl,
  attribution,
  markers,
  className,
}: Props) {
  const elRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<L.Map | null>(null);
  const tilesRef = useRef<L.TileLayer | null>(null);
  const groupRef = useRef<L.LayerGroup | null>(null);

  useEffect(() => {
    const el = elRef.current;
    if (!el) return;
    const map = L.map(el, {
      center,
      zoom,
      zoomControl: false,
      attributionControl: false,
    });
    mapRef.current = map;
    groupRef.current = L.layerGroup().addTo(map);
    const t = window.setTimeout(() => map.invalidateSize(), 80);
    const t2 = window.setTimeout(() => map.invalidateSize(), 400);
    return () => {
      window.clearTimeout(t);
      window.clearTimeout(t2);
      map.remove();
      mapRef.current = null;
      tilesRef.current = null;
      groupRef.current = null;
    };
  }, []);

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;
    if (tilesRef.current) map.removeLayer(tilesRef.current);
    tilesRef.current = L.tileLayer(tileUrl, { attribution }).addTo(map);
  }, [tileUrl, attribution]);

  useEffect(() => {
    const group = groupRef.current;
    if (!group) return;
    group.clearLayers();
    for (const m of markers) {
      const marker = L.marker([m.lat, m.lng], {
        icon: L.divIcon({
          className: '',
          html: m.html,
          iconSize: m.iconSize,
          iconAnchor: m.iconAnchor,
        }),
      });
      if (m.onClick) marker.on('click', m.onClick);
      group.addLayer(marker);
    }
  }, [markers]);

  return <div ref={elRef} className={className} />;
}

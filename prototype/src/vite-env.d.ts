/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_MAP_TILE_KEY?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

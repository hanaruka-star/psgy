/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_MAP_TILE_KEY?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

declare module '*.json' {
  const value: Record<string, unknown>;
  export default value;
}

import type { CSSProperties } from 'react';

type Props = {
  name: string;
  filled?: boolean;
  size?: number;
  className?: string;
  style?: CSSProperties;
};

export function Icon({ name, filled, size = 24, className, style }: Props) {
  return (
    <span
      className={`material-symbols-outlined ${filled ? 'fill' : ''} ${className ?? ''}`}
      style={{ fontSize: size, lineHeight: 1, ...style }}
      aria-hidden
    >
      {name}
    </span>
  );
}

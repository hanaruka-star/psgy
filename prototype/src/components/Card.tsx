import type { HTMLAttributes } from 'react';

export function Card({
  className,
  ...rest
}: HTMLAttributes<HTMLDivElement>) {
  return <div className={`app-card p-4 ${className ?? ''}`} {...rest} />;
}

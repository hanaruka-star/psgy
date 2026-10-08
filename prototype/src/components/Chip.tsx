import type { ButtonHTMLAttributes, CSSProperties } from 'react';

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
  selected?: boolean;
  bg?: string;
  fg?: string;
};

export function Chip({
  selected,
  bg,
  fg,
  className,
  style,
  onClick,
  ...rest
}: Props) {
  const colors: CSSProperties = {
    background: bg ?? (selected ? 'var(--primary)' : 'var(--tag)'),
    color: fg ?? (selected ? 'var(--on-primary)' : 'var(--on-surface)'),
    ...style,
  };
  const cls = `inline-flex items-center rounded-[var(--radius-sm)] px-3 py-1.5 text-[12px] font-semibold tracking-[0.03em] ${onClick ? 'press' : ''} ${className ?? ''}`;
  if (!onClick) {
    return (
      <span className={cls} style={colors}>
        {rest.children}
      </span>
    );
  }
  return (
    <button type="button" className={cls} style={colors} onClick={onClick} {...rest} />
  );
}

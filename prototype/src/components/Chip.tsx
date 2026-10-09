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
    background: bg ?? (selected ? 'var(--brand-soft)' : 'var(--tag)'),
    color: fg ?? (selected ? 'var(--brand-text)' : 'var(--on-surface)'),
    boxShadow: selected && !bg ? 'inset 0 0 0 1.5px var(--brand)' : undefined,
    ...style,
  };
  const cls = `inline-flex items-center rounded-[var(--radius-sm)] px-3 py-1.5 type-caption font-semibold tracking-[0.03em] ${onClick ? 'press' : ''} ${className ?? ''}`;
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

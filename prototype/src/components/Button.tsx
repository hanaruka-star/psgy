import type { ButtonHTMLAttributes, ReactNode } from 'react';

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: 'primary' | 'outline' | 'ghost' | 'text';
  icon?: ReactNode;
  block?: boolean;
};

export function Button({
  variant = 'primary',
  icon,
  block,
  className,
  children,
  ...rest
}: Props) {
  const base =
    'press inline-flex items-center justify-center gap-1.5 font-semibold tracking-[0.02em] disabled:opacity-40 type-body';
  const styles = {
    primary:
      'h-12 px-5 rounded-[var(--radius-md)] bg-[var(--primary)] text-[var(--on-primary)]',
    outline:
      'h-11 px-4 rounded-[var(--radius-md)] border border-[var(--outline-variant)] text-[var(--on-surface)] bg-transparent',
    ghost:
      'h-10 px-3 rounded-[var(--radius-sm)] text-[var(--primary-text)] bg-transparent',
    text: 'h-9 px-2 rounded-[var(--radius-sm)] text-[var(--primary-text)] bg-transparent font-semibold',
  }[variant];
  return (
    <button
      type="button"
      className={`${base} ${styles} ${block ? 'w-full' : ''} ${className ?? ''}`}
      {...rest}
    >
      {icon}
      {children}
    </button>
  );
}

import type { ReactNode } from 'react';
import { Icon } from './Icon';

type Props = {
  title?: ReactNode;
  onBack?: () => void;
  backLabel?: string;
  actions?: ReactNode;
  logoSrc?: string;
};

export function AppBar({ title, onBack, backLabel = 'Quay lại', actions, logoSrc }: Props) {
  return (
    <header className="flex h-14 shrink-0 items-center gap-1 px-2 bg-transparent text-[var(--on-surface)]">
      {onBack ? (
        <button
          type="button"
          aria-label={backLabel}
          title={backLabel}
          onClick={onBack}
          className="press grid h-11 w-11 place-items-center rounded-full"
        >
          <Icon name="arrow_back_ios_new" size={20} />
        </button>
      ) : (
        <div className="w-2" />
      )}
      <div className="min-w-0 flex-1">
        {logoSrc ? (
          <img src={logoSrc} alt="PSGymer" className="h-8 object-contain object-left" />
        ) : (
          <div className="type-title truncate">{title}</div>
        )}
      </div>
      <div className="flex items-center">{actions}</div>
    </header>
  );
}

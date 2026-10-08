import type { ReactNode } from 'react';
import { AppBar } from './AppBar';

export function Screen({
  title,
  onBack,
  actions,
  children,
  footer,
  padNav,
}: {
  title?: ReactNode;
  onBack?: () => void;
  actions?: ReactNode;
  children: ReactNode;
  footer?: ReactNode;
  padNav?: boolean;
}) {
  return (
    <div className="flex h-full flex-col">
      {title != null && <AppBar title={title} onBack={onBack} actions={actions} />}
      <div className={`no-scrollbar min-h-0 flex-1 overflow-y-auto ${padNav ? 'pad-nav' : 'pb-4'}`}>
        {children}
      </div>
      {footer}
    </div>
  );
}

import { AppBar } from '@/components/AppBar';
import { Button } from '@/components/Button';
import { privacy } from '@/data/catalog';
import { useAppStore } from '@/store/appStore';
import type { Role } from '@/types';

type Props = {
  id: string;
  name: string;
  role: Role;
};

export function PlaceholderScreen({ id, name, role }: Props) {
  const pop = useAppStore((s) => s.pop);
  const push = useAppStore((s) => s.push);
  const stack = useAppStore((s) => (role === 'user' ? s.userStack : s.coachStack));
  const canBack = stack.length > 1;

  return (
    <div className="flex h-full flex-col bg-transparent">
      <AppBar
        title={name}
        onBack={canBack ? () => pop(role) : undefined}
      />
      <div className="flex flex-1 flex-col gap-3 overflow-y-auto px-5 py-4">
        <div className="text-[12px] font-semibold tracking-wide text-[var(--primary-text)]">
          {id}
        </div>
        <h1 className="text-[24px] font-bold leading-tight">{name}</h1>
        <p className="text-[14px] text-[var(--on-surface-variant)]">
          Màn này sẽ dựng ở Bước 3
        </p>
        {id === 'U02' && (
          <div className="app-card mt-2 space-y-3 p-4 text-[14px] leading-relaxed">
            <p className="font-semibold">{privacy.title}</p>
            <p>{privacy.intro}</p>
            <ul className="list-disc space-y-2 pl-4">
              {privacy.bullets.map((b) => (
                <li key={b}>{b}</li>
              ))}
            </ul>
            <Button block>{privacy.cta}</Button>
            <button
              type="button"
              className="press text-[14px] font-semibold text-[var(--primary-text)]"
              onClick={() => push(role, { id: 'U02', params: { full: '1' } })}
            >
              {privacy.policyLink}
            </button>
            <p className="text-[12px] text-[var(--on-surface-variant)]">
              {privacy.note}
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

import { useAppStore } from '@/store/appStore';

export function PushBanner({ role }: { role: 'user' | 'pt' }) {
  const toast = useAppStore((s) => s.toast);
  const setToast = useAppStore((s) => s.setToast);
  const jump = useAppStore((s) => s.jump);
  if (!toast || toast.role !== role) return null;
  return (
    <button
      type="button"
      className="absolute inset-x-3 top-14 z-50 rounded-[var(--radius-md)] bg-[var(--on-surface)] px-3 py-2.5 text-left text-[var(--bg)] shadow-lg"
      onClick={() => {
        jump(role, { id: toast.screen, params: toast.params });
        setToast(null);
      }}
    >
      <div className="type-caption opacity-70">{toast.title}</div>
      <div className="type-body font-semibold">{toast.body}</div>
    </button>
  );
}

type Props = {
  src?: string;
  initials?: string;
  size?: number;
  className?: string;
};

export function Avatar({ src, initials, size = 56, className }: Props) {
  return (
    <div
      className={`overflow-hidden rounded-full bg-[var(--primary-container)] text-[var(--on-primary-container)] shrink-0 flex items-center justify-center font-bold ${className ?? ''}`}
      style={{ width: size, height: size, fontSize: size * 0.32 }}
    >
      {src ? (
        <img src={src} alt="" className="h-full w-full object-cover" />
      ) : (
        initials ?? '?'
      )}
    </div>
  );
}

import { AppBar } from '@/components/AppBar';
import { Card } from '@/components/Card';
import { coachById } from '@/data/catalog';
import { useAppStore } from '@/store/appStore';
import type { Role } from '@/types';

type Props = { role: Role; params?: Record<string, string> };

export function U18_StudentResult({ role, params }: Props) {
  const coach = coachById(params?.coachId ?? 'coach_01');
  const idx = Number(params?.resultIndex ?? 0);
  const result = coach.studentResults[idx] ?? coach.studentResults[0];
  const pop = useAppStore((s) => s.pop);

  if (!result) {
    return (
      <div className="flex h-full flex-col">
        <AppBar title="Kết quả học viên" onBack={() => pop(role)} />
        <p className="p-4">Chưa có kết quả.</p>
      </div>
    );
  }

  return (
    <div className="flex h-full flex-col">
      <AppBar title={result.studentLabel} onBack={() => pop(role)} />
      <div className="no-scrollbar flex-1 overflow-y-auto px-4 py-3 space-y-4">
        <div className="grid grid-cols-2 gap-2">
          <figure>
            <img
              src={result.beforeImageUrl}
              alt="Trước"
              className="h-40 w-full rounded-[var(--radius-md)] object-cover"
            />
            <figcaption className="mt-1 text-center text-[13px] font-semibold">
              Trước
            </figcaption>
          </figure>
          <figure>
            <img
              src={result.afterImageUrl}
              alt="Sau"
              className="h-40 w-full rounded-[var(--radius-md)] object-cover"
            />
            <figcaption className="mt-1 text-center text-[13px] font-semibold">
              Sau
            </figcaption>
          </figure>
        </div>
        <section>
          <h2 className="mb-1 text-[16px] font-semibold">Tóm tắt</h2>
          <p className="text-[14px] leading-relaxed">{result.summary}</p>
        </section>
        <section>
          <h2 className="mb-2 text-[16px] font-semibold">Nhật ký tiến độ</h2>
          {result.timeline.map((t) => (
            <Card key={t.dateLabel + t.note} className="mb-2">
              <div className="text-[12px] font-semibold text-[var(--primary-text)]">
                {t.dateLabel}
              </div>
              <p className="text-[14px]">{t.note}</p>
            </Card>
          ))}
        </section>
      </div>
    </div>
  );
}

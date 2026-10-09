import { Button } from '@/components/Button';
import { Chip } from '@/components/Chip';
import { Screen } from '@/components/Screen';
import { useAppStore } from '@/store/appStore';
import { useState } from 'react';

export function UCA1() {
  const jump = useAppStore((s) => s.jump);
  const preview = useAppStore((s) => s.features.cameraAiPreview);
  const [angle, setAngle] = useState('Mặt trước');
  return (
    <Screen title="Camera AI" padNav>
      <div className="p-4">
        <div className="relative h-72 overflow-hidden rounded-[var(--radius-lg)] bg-black">
          <img src="/assets/journal/gym-01.jpg" alt="" className="h-full w-full object-cover opacity-80" />
          <div className="absolute inset-8 rounded-[40%] border-2 border-white/70" />
        </div>
        <div className="mt-3 flex gap-2">
          {['Mặt trước', 'Mặt bên', 'Mặt sau'].map((a) => (
            <Chip key={a} selected={angle === a} onClick={() => setAngle(a)}>
              {a}
            </Chip>
          ))}
        </div>
        <Button className="mt-4" block onClick={() => jump('user', { id: 'UCA2' })}>
          Chụp
        </Button>
        <Button variant="outline" className="mt-2" block onClick={() => jump('user', { id: 'UCA2' })}>
          Chọn ảnh có sẵn
        </Button>
        <Button variant="text" onClick={() => jump('user', { id: 'UCA3' })}>
          Lịch sử ảnh
        </Button>
        {preview && <div className="type-caption mt-2">PT AI kịch bản cũ (cờ bật)</div>}
      </div>
    </Screen>
  );
}

export function UCA2() {
  const jump = useAppStore((s) => s.jump);
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Kết quả phân tích" onBack={() => pop('user')}>
      <div className="p-4 space-y-3">
        <p className="type-caption">Kết quả minh hoạ — AI phân tích thật sẽ có ở phiên bản sau</p>
        <img src="/assets/journal/gym-02.jpg" alt="" className="h-40 w-full rounded object-cover" />
        <div className="app-card p-3">Ước tính mỡ ~18% · vùng bụng / vai cần cải thiện</div>
        <ul className="list-disc pl-5 type-body">
          <li>Squat 3×8</li>
          <li>Plank 3×40s</li>
          <li>Cardio 20 phút</li>
        </ul>
        <Button onClick={() => jump('user', { id: 'UPF3' })}>Lưu vào Tiến trình</Button>
        <Button variant="outline" onClick={() => jump('user', { id: 'UAI1' })}>
          Hỏi Trợ lý AI
        </Button>
      </div>
    </Screen>
  );
}

export function UCA3() {
  const pop = useAppStore((s) => s.pop);
  return (
    <Screen title="Lịch sử ảnh" onBack={() => pop('user')}>
      <div className="grid grid-cols-2 gap-2 p-3">
        <img src="/assets/journal/gym-03.jpg" alt="" className="h-32 object-cover rounded" />
        <img src="/assets/journal/gym-04.jpg" alt="" className="h-32 object-cover rounded" />
      </div>
    </Screen>
  );
}

export function UO1() {
  const jump = useAppStore((s) => s.jump);
  return (
    <div className="grid h-full place-items-center bg-[var(--bg)]">
      <div className="text-center">
        <img src="/assets/brand/gymps_logo.svg" alt="PSGymer" className="mx-auto h-10" />
        <div className="mt-6 h-1 w-40 overflow-hidden rounded bg-[var(--tag)]">
          <div className="h-full w-2/3 bg-[var(--primary)]" />
        </div>
        <button type="button" className="mt-8 text-[var(--primary-text)]" onClick={() => jump('user', { id: 'UO2' })}>
          Tiếp
        </button>
      </div>
    </div>
  );
}

export function UO2() {
  const jump = useAppStore((s) => s.jump);
  return (
    <div className="flex h-full flex-col justify-end p-6">
      <h1 className="type-display mb-6">Đăng nhập</h1>
      <Button block onClick={() => jump('user', { id: 'UO3' })}>
        Tiếp tục với Google
      </Button>
      <Button className="mt-2" variant="outline" block onClick={() => jump('user', { id: 'UO3' })}>
        Tiếp tục với Apple
      </Button>
      <p className="type-caption mt-4">Điều khoản & Quyền riêng tư</p>
    </div>
  );
}

export function UO3() {
  const jump = useAppStore((s) => s.jump);
  return (
    <Screen title="Thiết lập nhanh" actions={<button type="button" onClick={() => jump('user', { id: 'UO4' })}>Bỏ qua</button>}>
      <div className="p-4 space-y-3">
        <input className="w-full rounded-lg bg-[var(--tag)] px-3 py-2" defaultValue="Minh" />
        <div className="flex flex-wrap gap-2">
          {['Giảm mỡ', 'Tăng cơ', 'Cải thiện sức khỏe', 'Tăng sức bền'].map((g) => (
            <Chip key={g}>{g}</Chip>
          ))}
        </div>
        <Button block onClick={() => jump('user', { id: 'UO4' })}>
          Tiếp
        </Button>
      </div>
    </Screen>
  );
}

export function UO4() {
  const skip = useAppStore((s) => s.skipOnboarding);
  const jump = useAppStore((s) => s.jump);
  const commit = useAppStore((s) => s.commit);
  return (
    <div className="grid h-full place-items-center p-6 text-center">
      <div>
        <h1 className="type-title">Cho phép vị trí?</h1>
        <Button
          className="mt-4"
          onClick={() => {
            commit({ onboardingDone: true });
            jump('user', { id: 'UM1' });
          }}
        >
          Cho phép
        </Button>
        <Button variant="text" onClick={skip}>
          Để sau
        </Button>
      </div>
    </div>
  );
}

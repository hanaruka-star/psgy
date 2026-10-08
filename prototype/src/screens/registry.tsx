import type { ComponentType, ReactNode } from 'react';
import type { Role } from '@/types';
import { PlaceholderScreen } from './PlaceholderScreen';
import { U07_Map } from './user/U07_Map';
import { U09_CoachDetail } from './user/U09_CoachDetail';
import { U18_StudentResult } from './user/U18_StudentResult';
import { C01_Home } from './coach/C01_Home';

export type ScreenDef = {
  id: string;
  name: string;
  role: Role | 'both';
  component?: ComponentType<{ role: Role; params?: Record<string, string> }>;
  defaultParams?: Record<string, string>;
};

const U = (
  id: string,
  name: string,
  extra?: Partial<ScreenDef>,
): ScreenDef => ({ id, name, role: 'user', ...extra });

const C = (
  id: string,
  name: string,
  extra?: Partial<ScreenDef>,
): ScreenDef => ({ id, name, role: 'coach', ...extra });

export const screens: ScreenDef[] = [
  U('U01', 'Splash', { role: 'both' }),
  U('U02', 'Quyền riêng tư & Dữ liệu', { role: 'both' }),
  U('U03', 'ModeSwitcher (dev)', { role: 'both' }),
  U('U04', 'Xác thực số điện thoại'),
  U('U05', 'Tạo hồ sơ'),
  U('U06', 'Main shell'),
  U('U07', 'Bản đồ', { component: U07_Map }),
  U('U08', 'Coach gần bạn (list)'),
  U('U09', 'Chi tiết Coach', {
    component: U09_CoachDetail,
    defaultParams: { coachId: 'coach_01' },
  }),
  U('U10', 'Xác nhận đặt lịch'),
  U('U11', 'Theo dõi Booking'),
  U('U12', 'Chat'),
  U('U13', 'Lịch sử booking'),
  U('U14', 'Nhật ký của tôi'),
  U('U15', 'Cộng đồng PSgy'),
  U('U16', 'Bài viết'),
  U('U17', 'Chia sẻ buổi tập'),
  U('U18', 'Kết quả học viên', {
    component: U18_StudentResult,
    defaultParams: { coachId: 'coach_01', resultIndex: '0' },
  }),
  U('U19', 'PT AI'),
  U('U20', 'Chọn bài tập'),
  U('U21', 'Buổi tập PT AI'),
  U('U22', 'Hoàn thành PT AI'),
  C('C01', 'Coach Home', { component: C01_Home }),
  C('C02', 'Booking đang diễn ra'),
  C('C03', 'Yêu cầu đặt lịch'),
  C('C04', 'Chat Coach'),
  C('C05', 'Dịch vụ của bạn'),
  C('C06', 'Chỉnh sửa hồ sơ'),
  C('C07', 'Nhật ký học viên'),
];

const byId = new Map(screens.map((s) => [s.id, s]));

export function getScreen(id: string) {
  return byId.get(id);
}

export function renderScreen(
  id: string,
  role: Role,
  params?: Record<string, string>,
): ReactNode {
  const def = getScreen(id);
  if (!def) {
    return <PlaceholderScreen id={id} name="Không tìm thấy màn" role={role} />;
  }
  const Comp = def.component;
  const merged = { ...def.defaultParams, ...params };
  if (Comp) return <Comp role={role} params={merged} />;
  return <PlaceholderScreen id={def.id} name={def.name} role={role} />;
}

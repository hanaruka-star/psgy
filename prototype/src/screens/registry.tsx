import type { ComponentType, ReactNode } from 'react';
import type { Role } from '@/domain/types';
import { UD1_Discovery, UR1_Report } from './user/UD1_Discovery';
import { UG1_Gym, UM1_Map, US1_Spa } from './user/UM1_Map';
import { UP1_Profile } from './user/UP1_Profile';
import { UB1, UB2, UB3, UB4, UB5, UB6 } from './user/UB_Booking';
import { UCN1, UR2, URS1, USE1, USE2, USS1 } from './user/USS1_Session';
import { UAI1, UAI2, UC1, UC2, UW1 } from './user/UC_Chat';
import { UCA1, UCA2, UCA3, UO1, UO2, UO3, UO4 } from './user/UCA_Camera';
import {
  UJ1, UJ2, UL1, UN1, UPF1, UPF2, UPF3, UPF4, UPY1, UST1, USV1,
} from './user/UPF_Profile';
import { PL1, PL2, PO1, PSD1, PSE1, PW1 } from './pt/PO_PW';
import {
  PC1, PC2, PC3, PI1, PI2, PI3, PM1, PM10, PM2, PM3, PM4, PM5, PM6, PM7, PM8, PM9, PN1,
} from './pt/PC_PI_PM';

export type ScreenDef = {
  id: string;
  name: string;
  role: Role;
  component: ComponentType<{ role: Role; params?: Record<string, string> }>;
};

const U = (id: string, name: string, component: ComponentType<{ params?: Record<string, string> }>): ScreenDef => ({
  id, name, role: 'user', component: component as ScreenDef['component'],
});
const P = (id: string, name: string, component: ComponentType<{ params?: Record<string, string> }>): ScreenDef => ({
  id, name, role: 'pt', component: component as ScreenDef['component'],
});

export const screens: ScreenDef[] = [
  U('UO1', 'Splash', UO1),
  U('UO2', 'Đăng nhập User', UO2),
  U('UO3', 'Thiết lập nhanh', UO3),
  U('UO4', 'Quyền vị trí', UO4),
  U('UD1', 'Discovery', UD1_Discovery),
  U('UR1', 'Báo cáo PT', UR1_Report),
  U('UM1', 'Map', UM1_Map),
  U('UG1', 'Chi tiết Gym', UG1_Gym),
  U('US1', 'Chi tiết Spa', US1_Spa),
  U('UP1', 'PT Profile', UP1_Profile),
  U('UB1', 'Chọn gói', UB1),
  U('UB2', 'Chọn thời gian', UB2),
  U('UB3', 'Chọn địa điểm', UB3),
  U('UB4', 'Xác nhận & thanh toán', UB4),
  U('UB5', 'Đang xử lý', UB5),
  U('UB6', 'Thanh toán thành công', UB6),
  U('USS1', 'Buổi tập User', USS1),
  U('UR2', 'Đánh giá', UR2),
  U('URS1', 'Đổi lịch', URS1),
  U('UCN1', 'Huỷ buổi', UCN1),
  U('USE1', 'Hoàn thành buổi', USE1),
  U('USE2', 'Hoàn thành gói', USE2),
  U('UC1', 'Chat User', UC1),
  U('UC2', 'Chat chi tiết User', UC2),
  U('UAI1', 'Trợ lý AI', UAI1),
  U('UAI2', 'Gói AI', UAI2),
  U('UCA1', 'Camera AI', UCA1),
  U('UCA2', 'Kết quả phân tích', UCA2),
  U('UCA3', 'Lịch sử ảnh AI', UCA3),
  U('UPF1', 'Profile User', UPF1),
  U('UPF2', 'Chỉnh sửa hồ sơ', UPF2),
  U('UPF3', 'Tiến trình cơ thể', UPF3),
  U('UPF4', 'Thành tích', UPF4),
  U('UJ1', 'Hợp đồng của tôi', UJ1),
  U('UJ2', 'Chi tiết hợp đồng', UJ2),
  U('UL1', 'Lịch tập của tôi', UL1),
  U('UPY1', 'Lịch sử thanh toán', UPY1),
  U('USV1', 'Đã lưu', USV1),
  U('UST1', 'Cài đặt', UST1),
  U('UN1', 'Thông báo User', UN1),
  U('UW1', 'Ví PSGymer', UW1),
  P('PL1', 'Đăng nhập PT', PL1),
  P('PL2', 'Hồ sơ chờ duyệt', PL2),
  P('PO1', 'Tổng quan', PO1),
  P('PW1', 'Công việc', PW1),
  P('PSD1', 'Chi tiết buổi PT', PSD1),
  P('PSE1', 'Tổng kết buổi tập', PSE1),
  P('PC1', 'Chat PT', PC1),
  P('PC2', 'Chat chi tiết PT', PC2),
  P('PC3', 'Gửi lời chào', PC3),
  P('PI1', 'Thu nhập', PI1),
  P('PI2', 'Chi tiết giao dịch', PI2),
  P('PI3', 'Rút tiền', PI3),
  P('PM1', 'Tôi', PM1),
  P('PM2', 'Thông tin hồ sơ PT', PM2),
  P('PM3', 'Chứng chỉ', PM3),
  P('PM4', 'Gói tập & giá', PM4),
  P('PM5', 'Lịch làm việc', PM5),
  P('PM6', 'Khu vực & vị trí', PM6),
  P('PM7', 'Ảnh hồ sơ PT', PM7),
  P('PM8', 'Cấp PT', PM8),
  P('PM9', 'Thống kê hồ sơ', PM9),
  P('PM10', 'Boost', PM10),
  P('PN1', 'Thông báo PT', PN1),
];

const byId = new Map(screens.map((s) => [s.id, s]));
export function getScreen(id: string) {
  return byId.get(id);
}

export function renderScreen(id: string, role: Role, params?: Record<string, string>): ReactNode {
  const def = getScreen(id);
  if (!def) return <div className="p-4">Không tìm thấy {id}</div>;
  const Comp = def.component;
  return <Comp role={role} params={params} />;
}

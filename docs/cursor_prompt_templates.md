# Cursor Prompt Templates — PSgy (Giai đoạn Demo & UI Polish)

> Mục đích: Claude (Tech Lead) sinh prompt chuẩn → Human paste vào Cursor (Junior Dev) → Cursor code → Claude review.
> Giai đoạn hiện tại: **demo + đổi style UI nhanh**. Ưu tiên tốc độ, KHÔNG phá kiến trúc.

---

## TEMPLATE A — THÊM TÍNH NĂNG DEMO

```markdown
# Task: [Tên tính năng demo ngắn gọn]

## Context
- Project: PSgy (GymPS) — Flutter, Clean Architecture + Riverpod 2.0
- Codebase: /Users/ruka/psgy (branch: main)
- UI reference: lib/features/pilot_demo/ (mock UI chuẩn — dùng làm mẫu)
- Màn hình liên quan: [đường dẫn file hoặc tên màn hình]
- Feature này CHỈ cho demo — không đụng backend thật, dùng mock data

## Yêu cầu
1. [Mô tả tính năng — NGẮN GỌN, RÕ RÀNG, từng bước]
2. [Màn hình nào, nút bấm nào, hành vi gì]
3. [Style theo design system có sẵn — KHÔNG tự chế màu mới]

## Ràng buộc BẮT BUỘC
- ❌ KHÔNG thêm package mới (hỏi trước nếu cần)
- ❌ KHÔNG đổi architecture / domain layer / repository interface
- ❌ KHÔNG đổi file lib/core/ (trừ theme nếu được duyệt)
- ✅ Code mới đặt trong lib/features/<tên>/ hoặc lib/shared/
- ✅ Dùng theme có sẵn: colors/typography từ lib/core/theme/
- ✅ Mock data đặt riêng, đánh dấu // DEMO DATA — dễ xoá sau
- ✅ Giữ UI/UX khớp pilot_demo reference

## Definition of Done
- [ ] flutter analyze KHÔNG có error mới
- [ ] Chạy được: flutter run --dart-define=FLAVOR=user --dart-define=ENV=development
- [ ] Test thủ công trên simulator: [các bước test]
- [ ] Commit: feat: [mô tả] (CPxx) — tuân theo docs/git_workflow.md
- [ ] Báo cáo: file đã sửa, screenshot, điều gì chưa làm được
```

---

## TEMPLATE B — ĐỔI STYLE UI / THEME

```markdown
# Task: Đổi style [màn hình / toàn app / component]

## Context
- Project: PSgy (GymPS) — Flutter, Clean Architecture + Riverpod 2.0
- Codebase: /Users/ruka/psgy (branch: main)
- Design system: lib/core/theme/ (màu, typography, spacing — KIỂM TRA TRƯỚC KHI ĐỔI)
- Màn hình cần đổi: [đường dẫn file]

## Thay đổi mong muốn
1. [Mô tả CỤ THỂ: màu nào → màu gì, font nào, kích thước nào, spacing nào]
2. [Kèm reference: ảnh mẫu / link Figma / hex code màu nếu có]

## Ràng buộc BẮT BUỘC
- ✅ Ưu tiên đổi qua theme (lib/core/theme/) để ảnh hưởng toàn app đồng nhất
- ✅ Nếu chỉ đổi 1 màn: dùng Theme.of(context) extension, KHÔNG hardcode màu rải rác
- ❌ KHÔNG hardcode màu/hex code trong widget — phải qua theme hoặc AppColors
- ❌ KHÔNG đổi layout/logic — CHỈ đổi style
- ❌ KHÔNG thêm package mới (vd: google_fonts — hỏi trước)
- ✅ Test cả 2 flavor (user + coach) nếu thay đổi ảnh hưởng cả 2

## Definition of Done
- [ ] flutter analyze KHÔNG có error mới
- [ ] Chạy được trên simulator (user + coach nếu cần)
- [ ] So sánh screenshot trước/sau (Simulator → Cmd+S)
- [ ] Commit: style: [mô tả] (CPxx)
- [ ] Báo cáo: file đã sửa, screenshot trước/sau
```

---

## TEMPLATE C — FIX BUG NHANH (demo phase)

```markdown
# Task: Fix bug [mô tả]

## Context
- Project: PSgy — Flutter, Clean Architecture + Riverpod
- Codebase: /Users/ruka/psgy (branch: main)
- Lỗi: [mô tả chính xác + cách tái hiện từng bước]
- Log/ảnh lỗi: [paste log hoặc screenshot]

## Yêu cầu
1. Tìm nguyên nhân gốc (KHÔNG vá vội)
2. Fix tối thiểu, đúng chỗ
3. Giải thích 1-2 câu nguyên nhân + cách fix

## Ràng buộc
- ❌ KHÔNG đổi kiến trúc để fix bug
- ❌ KHÔNG thêm package
- ✅ Nếu fix đụng domain/core → dừng lại báo Claude trước

## Definition of Done
- [ ] flutter analyze sạch
- [ ] Tái hiện lỗi trước → fix → không còn lỗi
- [ ] Commit: fix: [mô tả] (CPxx)
```

---

## LUỒNG LÀM VIỆC CHUẨN (copy-paste)

```
[Anh Ruka] Mô tả ý tưởng/yêu cầu
    ↓
[Hermes/Claude] Phân tích:
    - Tính năng này nằm đâu? (feature mới / style / fix)
    - Có đụng kiến trúc không? (core/domain/repo)
    - Chọn template A/B/C + điền chi tiết
    ↓
[Hermes/Claude] Xuất prompt hoàn chỉnh (markdown block)
    ↓
[Anh Ruka] Copy → paste vào Cursor → Enter
    ↓
[Cursor] Code + báo cáo kết quả (file sửa, screenshot)
    ↓
[Anh Ruka] Copy kết quả/báo cáo → paste lại cho Hermes/Claude
    ↓
[Hermes/Claude] Review code: đúng kiến trúc? analyze sạch? theo theme?
    → OK: chốt, anh commit (hoặc Cursor commit theo git_workflow)
    → Sai: giải thích + sinh lại prompt
```

## QUY TẮC VÀNG cho giai đoạn demo

1. **Nhanh, thử nghiệm, KHÔNG sợ sai** — nhưng sai phải sửa được (commit từng checkpoint nhỏ)
2. **Demo = mock data** — mọi thứ demo phải dễ xoá (đánh dấu `// DEMO`)
3. **Style qua theme, không hardcode** — sau này đổi 1 chỗ là đổi hết
4. **Commit nhỏ, message chuẩn** — dễ rollback khi thử nghiệm thất bại
5. **Chụp screenshot trước/sau** mỗi lần đổi UI — anh nhìn là duyệt ngay

import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_availability_slot.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_profile.dart';
import 'package:psgy/features/pilot_demo/models/mock_training_location.dart';

/// Đợt 1: text/chip only. Slideshow 5 ảnh + kết quả học viên (ảnh trước/sau)
/// = Đợt 2. Khi làm Đợt 2: Coach chọn từ kho ảnh mẫu trong app, không mở
/// thư viện máy (chưa có Firebase Storage — ảnh máy không persist được).
class CoachProfileEditScreen extends StatefulWidget {
  static const routeName = 'coach_profile_edit';

  const CoachProfileEditScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const CoachProfileEditScreen(),
    );
  }

  @override
  State<CoachProfileEditScreen> createState() => _CoachProfileEditScreenState();
}

class _CoachProfileEditScreenState extends State<CoachProfileEditScreen> {
  static const _weekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  late final TextEditingController _bio;
  late final TextEditingController _policy;
  late final TextEditingController _membershipFee;
  late final List<String> _goals;
  late final List<String> _audience;
  late final List<String> _formats;
  late final List<MockAvailabilitySlot> _slots;
  late final List<MockTrainingLocation> _locations;
  late final List<String> _certifications;
  late bool _gymFeeIncluded;

  @override
  void initState() {
    super.initState();
    final profile = MockCoachSession.instance.profile;
    _bio = TextEditingController(text: profile.bio);
    _policy = TextEditingController(text: profile.bookingCancellationPolicy);
    _membershipFee = TextEditingController(
      text: profile.membershipFeeLabel ?? '',
    );
    _goals = List<String>.of(profile.goals);
    _audience = List<String>.of(profile.targetAudience);
    _formats = List<String>.of(profile.trainingFormats);
    _slots = [
      for (final slot in profile.weeklyAvailability)
        MockAvailabilitySlot(
          date: slot.date,
          startTime: slot.startTime,
          endTime: slot.endTime,
        ),
    ];
    _locations = [
      for (final location in profile.trainingLocations)
        MockTrainingLocation(
          name: location.name,
          address: location.address,
          type: location.type,
        ),
    ];
    _certifications = List<String>.of(profile.certifications);
    _gymFeeIncluded = profile.gymFeeIncluded;
  }

  @override
  void dispose() {
    _bio.dispose();
    _policy.dispose();
    _membershipFee.dispose();
    super.dispose();
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _toggle(List<String> target, String value, bool selected) {
    setState(() {
      if (selected) {
        if (!target.contains(value)) target.add(value);
      } else {
        target.remove(value);
      }
    });
  }

  TimeOfDay _parseTime(String raw) {
    final parts = raw.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _minutes(String raw) {
    final time = _parseTime(raw);
    return time.hour * 60 + time.minute;
  }

  Future<void> _addOrEditSlot({
    required DateTime day,
    MockAvailabilitySlot? existing,
  }) async {
    var start = existing == null
        ? const TimeOfDay(hour: 18, minute: 0)
        : _parseTime(existing.startTime);
    var end = existing == null
        ? const TimeOfDay(hour: 20, minute: 0)
        : _parseTime(existing.endTime);

    final pickedStart = await showTimePicker(
      context: context,
      initialTime: start,
      helpText: 'Giờ bắt đầu',
    );
    if (!mounted || pickedStart == null) return;
    start = pickedStart;

    final pickedEnd = await showTimePicker(
      context: context,
      initialTime: end,
      helpText: 'Giờ kết thúc',
    );
    if (!mounted || pickedEnd == null) return;
    end = pickedEnd;

    final startLabel = _formatTime(start);
    final endLabel = _formatTime(end);
    if (_minutes(endLabel) <= _minutes(startLabel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ kết thúc phải sau giờ bắt đầu.')),
      );
      return;
    }

    setState(() {
      if (existing != null) {
        final index = _slots.indexOf(existing);
        if (index >= 0) {
          _slots[index] = MockAvailabilitySlot(
            date: day,
            startTime: startLabel,
            endTime: endLabel,
          );
        }
      } else {
        _slots.add(
          MockAvailabilitySlot(
            date: day,
            startTime: startLabel,
            endTime: endLabel,
          ),
        );
      }
    });
  }

  Future<void> _editLocation({MockTrainingLocation? existing}) async {
    final result = await showDialog<MockTrainingLocation>(
      context: context,
      builder: (_) => _LocationFormDialog(existing: existing),
    );
    if (result == null) return;
    setState(() {
      if (existing == null) {
        _locations.add(result);
      } else {
        final index = _locations.indexOf(existing);
        if (index >= 0) _locations[index] = result;
      }
    });
  }

  Future<void> _editCertification({int? index}) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _TextItemDialog(
        title: index == null ? 'Thêm chứng chỉ' : 'Sửa chứng chỉ',
        initial: index == null ? '' : _certifications[index],
        label: 'Tên chứng chỉ',
      ),
    );
    if (result == null) return;
    setState(() {
      if (index == null) {
        _certifications.add(result);
      } else {
        _certifications[index] = result;
      }
    });
  }

  void _save() {
    final fee = _membershipFee.text.trim();
    final session = MockCoachSession.instance;
    session.updateProfile(
      session.profile.copyWith(
        bio: _bio.text.trim(),
        goals: List<String>.of(_goals),
        targetAudience: List<String>.of(_audience),
        trainingFormats: List<String>.of(_formats),
        weeklyAvailability: List<MockAvailabilitySlot>.of(_slots),
        trainingLocations: List<MockTrainingLocation>.of(_locations),
        bookingCancellationPolicy: _policy.text.trim(),
        certifications: List<String>.of(_certifications),
        gymFeeIncluded: _gymFeeIncluded,
        membershipFeeLabel: fee.isEmpty ? null : fee,
        clearMembershipFeeLabel: fee.isEmpty,
      ),
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Đã lưu hồ sơ trong phiên demo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = MockCoachSession.instance.profile;
    final today = _today;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        titleTextStyle: AppStatusColors.headingStyle(context),
        foregroundColor: AppStatusColors.sheetTitle(theme.brightness),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(profile.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          AppRating(
            value: profile.ratingAvg,
            suffix: '${profile.ratingCount} đánh giá · ${profile.yearsExperience} năm KN',
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Đánh giá và số booking do hệ thống tính — không chỉnh tay.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionCard(
            title: 'Về tôi',
            child: TextField(
              key: const Key('coach_profile_bio'),
              controller: _bio,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Giới thiệu kinh nghiệm, cách kèm, thành tựu…',
                alignLabelWithHint: true,
              ),
            ),
          ),
          _SectionCard(
            title: 'Mục tiêu',
            child: _ChipWrap(
              options: MockCoachProfile.goalOptions,
              selected: _goals,
              onSelected: (value, selected) =>
                  _toggle(_goals, value, selected),
            ),
          ),
          _SectionCard(
            title: 'Đối tượng',
            child: _ChipWrap(
              options: MockCoachProfile.audienceOptions,
              selected: _audience,
              onSelected: (value, selected) =>
                  _toggle(_audience, value, selected),
            ),
          ),
          _SectionCard(
            title: 'Hình thức',
            child: _ChipWrap(
              options: MockCoachProfile.formatOptions,
              selected: _formats,
              onSelected: (value, selected) =>
                  _toggle(_formats, value, selected),
            ),
          ),
          _SectionCard(
            title: 'Lịch trống tuần',
            child: Column(
              children: [
                for (var index = 0; index < 7; index++) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.sm),
                  _AvailabilityDayRow(
                    day: today.add(Duration(days: index)),
                    weekdayLabel: _weekdayLabels[
                        today.add(Duration(days: index)).weekday - 1],
                    isToday: index == 0,
                    slots: _slots
                        .where(
                          (slot) => _sameDay(
                            slot.date,
                            today.add(Duration(days: index)),
                          ),
                        )
                        .toList(),
                    onAdd: () => _addOrEditSlot(
                      day: today.add(Duration(days: index)),
                    ),
                    onEdit: (slot) => _addOrEditSlot(
                      day: today.add(Duration(days: index)),
                      existing: slot,
                    ),
                    onDelete: (slot) {
                      setState(() => _slots.remove(slot));
                    },
                  ),
                ],
              ],
            ),
          ),
          _SectionCard(
            title: 'Địa điểm tập',
            trailing: TextButton.icon(
              onPressed: () => _editLocation(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm'),
            ),
            child: Column(
              children: [
                if (_locations.isEmpty)
                  Text(
                    'Chưa có địa điểm.',
                    style: theme.textTheme.bodyMedium,
                  ),
                for (final location in _locations)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(location.name),
                    subtitle: Text('${location.address}\n${location.type}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Sửa',
                          onPressed: () => _editLocation(existing: location),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Xóa',
                          onPressed: () {
                            setState(() => _locations.remove(location));
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Chính sách huỷ',
            child: TextField(
              controller: _policy,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Huỷ miễn phí trước 2 giờ…',
              ),
            ),
          ),
          _SectionCard(
            title: 'Certification',
            trailing: TextButton.icon(
              onPressed: () => _editCertification(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm'),
            ),
            child: Column(
              children: [
                if (_certifications.isEmpty)
                  Text(
                    'Chưa có chứng chỉ.',
                    style: theme.textTheme.bodyMedium,
                  ),
                for (var i = 0; i < _certifications.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_certifications[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Sửa',
                          onPressed: () => _editCertification(index: i),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Xóa',
                          onPressed: () {
                            setState(() => _certifications.removeAt(i));
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Phí phòng gym & membership',
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Có bao gồm phí phòng gym'),
                  value: _gymFeeIncluded,
                  onChanged: (value) => setState(() => _gymFeeIncluded = value),
                ),
                TextField(
                  key: const Key('coach_profile_membership'),
                  controller: _membershipFee,
                  decoration: const InputDecoration(
                    labelText: 'Giá membership',
                    hintText: 'Để trống = ẩn dòng này',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 88),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: FilledButton(
            key: const Key('coach_profile_save'),
            onPressed: _save,
            style: AppStatusColors.highlightFilledButton(context),
            child: const Text('Lưu'),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final List<String> selected;
  final void Function(String value, bool selected) onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option),
            selected: selected.contains(option),
            onSelected: (value) => onSelected(option, value),
          ),
      ],
    );
  }
}

class _AvailabilityDayRow extends StatelessWidget {
  const _AvailabilityDayRow({
    required this.day,
    required this.weekdayLabel,
    required this.isToday,
    required this.slots,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final DateTime day;
  final String weekdayLabel;
  final bool isToday;
  final List<MockAvailabilitySlot> slots;
  final VoidCallback onAdd;
  final ValueChanged<MockAvailabilitySlot> onEdit;
  final ValueChanged<MockAvailabilitySlot> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);
    final dateLabel =
        '${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$weekdayLabel $dateLabel${isToday ? ' · hôm nay' : ''}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: isToday ? accent : null,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Thêm khung giờ',
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (slots.isEmpty)
          Text('—', style: theme.textTheme.bodyMedium)
        else
          for (final slot in slots)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text('${slot.startTime}–${slot.endTime}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Sửa',
                    onPressed: () => onEdit(slot),
                    icon: const Icon(Icons.schedule_outlined),
                  ),
                  IconButton(
                    tooltip: 'Xóa',
                    onPressed: () => onDelete(slot),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class _LocationFormDialog extends StatefulWidget {
  const _LocationFormDialog({this.existing});

  final MockTrainingLocation? existing;

  @override
  State<_LocationFormDialog> createState() => _LocationFormDialogState();
}

class _LocationFormDialogState extends State<_LocationFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  late String _type;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _address = TextEditingController(text: existing?.address ?? '');
    _type = existing?.type ?? MockTrainingLocation.typeNearby;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final address = _address.text.trim();
    if (name.isEmpty || address.isEmpty) return;
    Navigator.of(context).pop(
      MockTrainingLocation(name: name, address: address, type: _type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Thêm địa điểm' : 'Sửa địa điểm'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Loại'),
              items: const [
                DropdownMenuItem(
                  value: MockTrainingLocation.typeNearby,
                  child: Text(MockTrainingLocation.typeNearby),
                ),
                DropdownMenuItem(
                  value: MockTrainingLocation.typePartnerGym,
                  child: Text(MockTrainingLocation.typePartnerGym),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _type = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _submit,
          style: AppStatusColors.highlightFilledButton(context),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class _TextItemDialog extends StatefulWidget {
  const _TextItemDialog({
    required this.title,
    required this.initial,
    required this.label,
  });

  final String title;
  final String initial;
  final String label;

  @override
  State<_TextItemDialog> createState() => _TextItemDialogState();
}

class _TextItemDialogState extends State<_TextItemDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.label),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _submit,
          style: AppStatusColors.highlightFilledButton(context),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

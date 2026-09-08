import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_reviews.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_availability_slot.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_review.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/models/mock_student_result.dart';
import 'package:psgy/features/pilot_demo/models/mock_training_location.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_summary_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/student_result_detail_screen.dart';

class CoachDetailScreen extends StatefulWidget {
  const CoachDetailScreen({super.key, required this.coach});

  final MockCoach coach;

  @override
  State<CoachDetailScreen> createState() => _CoachDetailScreenState();
}

class _CoachDetailScreenState extends State<CoachDetailScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedServiceId;
  late final TabController _tabs;
  late final PageController _photos;
  int _photoIndex = 0;
  var _photosPrecached = false;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.coach.services.first.id;
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _photos = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_photosPrecached) return;
    _photosPrecached = true;
    for (final url in widget.coach.photoUrls) {
      precacheImage(AssetImage(url), context);
    }
  }

  @override
  void dispose() {
    _photos.dispose();
    _tabs.dispose();
    super.dispose();
  }

  MockService get _selectedService => widget.coach.services.firstWhere(
        (service) => service.id == _selectedServiceId,
      );

  int? _packageSavingsPercent(MockPackage package) {
    final unit = widget.coach.services.first;
    final retail = unit.priceVnd * package.sessionCount;
    if (retail <= 0 || package.totalPriceVnd >= retail) return null;
    return (((retail - package.totalPriceVnd) * 100) / retail).round();
  }

  Future<void> _buy(MockPackage package) async {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);
    final onAccent = AppStatusColors.onHighlight(theme.brightness);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận mua'),
          content: Text(
            '${package.name}\n${package.sessionCount} buổi · ${package.priceLabel}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: onAccent,
              ),
              child: const Text('Xác nhận mua'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    MockUserSession.instance.purchasePackage(package);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã mua ${package.name}')),
    );
  }

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingSummaryScreen(
          coach: widget.coach,
          service: _selectedService,
        ),
      ),
    );
  }

  void _openCertificate(BuildContext context, String title) {
    final asset = mockCertificatePhotos[
        title.hashCode.remainder(mockCertificatePhotos.length).abs()];
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            body: InteractiveViewer(
              child: Center(
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final coach = widget.coach;
    final session = MockUserSession.instance;
    final reviews = reviewsForCoach(coach.id);
    final stats = reviewStatsFor(reviews);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final owned = session.purchasedPackages
            .where((item) => item.coachId == coach.id)
            .toList();
        final dateFormat = DateFormat('dd/MM/yyyy');
        final accent = AppStatusColors.highlight(theme.brightness);
        final onAccent = AppStatusColors.onHighlight(theme.brightness);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Quay lại',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(coach.name),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _PhotoSlideshow(
                      coach: coach,
                      controller: _photos,
                      index: _photoIndex,
                      onChanged: (value) =>
                          setState(() => _photoIndex = value),
                    ),
                    Padding(
                      padding: AppSpacing.screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(coach.name, style: theme.textTheme.headlineMedium),
                          const SizedBox(height: AppSpacing.sm),
                          _TrustSignals(coach: coach, stats: stats),
                          const SizedBox(height: AppSpacing.lg),
                          const _SectionTitle('Về tôi'),
                          const SizedBox(height: AppSpacing.sm),
                          Text(coach.bio, style: theme.textTheme.bodyMedium),
                          if (coach.goals.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            _ChipBlock(
                              title: 'Mục tiêu',
                              labels: coach.goals,
                              colored: true,
                            ),
                          ],
                          if (coach.targetAudience.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            _ChipBlock(
                              title: 'Đối tượng',
                              labels: coach.targetAudience,
                              colored: true,
                            ),
                          ],
                          if (coach.trainingFormats.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            _ChipBlock(
                              title: 'Hình thức',
                              labels: coach.trainingFormats,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          const _SectionTitle('Lịch trống'),
                          const SizedBox(height: AppSpacing.sm),
                          _WeeklyAvailabilityGrid(
                            slots: coach.weeklyAvailability,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _SectionTitle('Chọn dịch vụ'),
                          const SizedBox(height: AppSpacing.sm),
                          TabBar(
                            controller: _tabs,
                            tabs: const [
                              Tab(text: 'Dịch vụ'),
                              Tab(text: 'Gói'),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (_tabs.index == 0)
                            RadioGroup<String>(
                              groupValue: _selectedServiceId,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedServiceId = value);
                              },
                              child: Column(
                                children: [
                                  for (final service in coach.services)
                                    _ServiceRadioTile(
                                      service: service,
                                    ),
                                ],
                              ),
                            )
                          else ...[
                            if (coach.packages.isEmpty)
                              Text(
                                'Coach này chưa có gói.',
                                style: theme.textTheme.bodyMedium,
                              )
                            else
                              for (final package in coach.packages) ...[
                                Card(
                                  child: Padding(
                                    padding: AppSpacing.cardPadding,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: AppSpacing.sm,
                                          runSpacing: AppSpacing.xs,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            AppTag(label: package.name),
                                            if (_packageSavingsPercent(package)
                                                case final percent?)
                                              AppTag(
                                                label: 'Tiết kiệm $percent%',
                                                highlight: true,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          '${package.sessionCount} buổi · ${package.priceLabel}',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        if (package.description.isNotEmpty) ...[
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            package.description,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                        const SizedBox(height: AppSpacing.sm),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FilledButton(
                                            onPressed: () => _buy(package),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: accent,
                                              foregroundColor: onAccent,
                                            ),
                                            child: const Text('Mua'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                            if (owned.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Gói đã mua',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              for (final item in owned) ...[
                                Card(
                                  child: ListTile(
                                    title: AppTag(label: item.packageName),
                                    subtitle: Text(
                                      '${item.remainingLabel}\n'
                                      'Mua ngày ${dateFormat.format(item.purchasedAt)}',
                                    ),
                                    isThreeLine: true,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                            ],
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          AppTag(
                            label: coach.gymFeeIncluded
                                ? 'Đã bao gồm chi phí phòng gym'
                                : 'Chưa bao gồm chi phí phòng gym',
                            highlight: coach.gymFeeIncluded,
                          ),
                          if (coach.trainingLocations.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            const _SectionTitle('Địa điểm tập'),
                            const SizedBox(height: AppSpacing.sm),
                            for (final location in coach.trainingLocations) ...[
                              _TrainingLocationCard(location: location),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            if (coach.membershipFeeLabel != null)
                              Text(
                                coach.membershipFeeLabel!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                          if (coach.studentResults.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            const _SectionTitle('Kết quả học viên'),
                            const SizedBox(height: AppSpacing.sm),
                            for (final result in coach.studentResults) ...[
                              _StudentResultCard(result: result),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                          ],
                          if (coach.certifications.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            _ChipBlock(
                              title: 'Certification',
                              labels: coach.certifications,
                              onSelected: (label) =>
                                  _openCertificate(context, label),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          _ReviewOverviewCard(stats: stats),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Bình luận khách hàng',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (reviews.isEmpty)
                            Text(
                              'Chưa có đánh giá.',
                              style: theme.textTheme.bodyMedium,
                            )
                          else
                            for (final review in reviews) ...[
                              _ReviewCommentCard(
                                review: review,
                                dateLabel: dateFormat.format(review.date),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                          if (coach.bookingCancellationPolicy.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.md),
                            const _SectionTitle('Chính sách booking/cancellation'),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              coach.bookingCancellationPolicy,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _continue,
                      child: const Text('Chọn HLV'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoSlideshow extends StatelessWidget {
  const _PhotoSlideshow({
    required this.coach,
    required this.controller,
    required this.index,
    required this.onChanged,
  });

  final MockCoach coach;
  final PageController controller;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final photos = coach.photoUrls;

    return SizedBox(
      height: 240,
      width: double.infinity,
      child: photos.isEmpty
          ? _PhotoFallback(coach: coach)
          : Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: photos.length,
                  onPageChanged: onChanged,
                  itemBuilder: (context, i) {
                    return Image.asset(
                      photos[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (frame == null) {
                          return _PhotoFallback(coach: coach);
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _PhotoFallback(coach: coach);
                      },
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSpacing.sm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < photos.length; i++) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == index
                                ? scheme.onPrimary
                                : scheme.onPrimary.withValues(alpha: 0.4),
                          ),
                        ),
                        if (i < photos.length - 1)
                          const SizedBox(width: AppSpacing.xs),
                      ],
                      const SizedBox(width: AppSpacing.sm),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.scrim.withValues(alpha: 0.45),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Padding(
                          padding: AppSpacing.chipPadding,
                          child: Text(
                            '${index + 1}/${photos.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({required this.coach});

  final MockCoach coach;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.primaryContainer,
      child: Center(
        child: Text(
          coach.initials,
          style: theme.textTheme.displaySmall?.copyWith(
            color: scheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _TrustSignals extends StatelessWidget {
  const _TrustSignals({required this.coach, required this.stats});

  final MockCoach coach;
  final MockCoachReviewStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);
    final style = theme.textTheme.bodyMedium;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.star, size: 16, color: accent),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${stats.average.toStringAsFixed(1)} · ${stats.count} đánh giá'
            '  ·  ${coach.yearsExperience} năm kinh nghiệm'
            '  ·  ${coach.totalBookings} lượt booking',
            style: style,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _ChipBlock extends StatelessWidget {
  const _ChipBlock({
    required this.title,
    required this.labels,
    this.colored = false,
    this.onSelected,
  });

  final String title;
  final List<String> labels;
  final bool colored;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final label in labels)
              _ProfileTag(
                label: label,
                colored: colored,
                onPressed: onSelected == null
                    ? null
                    : () => onSelected!(label),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({
    required this.label,
    required this.colored,
    this.onPressed,
  });

  final String label;
  final bool colored;
  final VoidCallback? onPressed;

  (Color background, Color foreground) _colors(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brightness = theme.brightness;
    if (!colored) {
      return (
        AppStatusColors.tagBackgroundOf(context),
        scheme.onSurface,
      );
    }
    switch (label) {
      case 'Tăng cơ':
        final pair = AppStatusColors.success(brightness);
        return (pair.container, pair.onContainer);
      case 'Giảm mỡ':
        final pair = AppStatusColors.warning(brightness);
        return (pair.container, pair.onContainer);
      case 'Tăng sức bền':
        return (scheme.primaryContainer, scheme.onPrimaryContainer);
      case 'Phục hồi sau chấn thương':
        return (scheme.tertiaryContainer, scheme.onTertiaryContainer);
      case 'Nam':
        return (scheme.secondaryContainer, scheme.onSecondaryContainer);
      case 'Nữ':
        return (
          AppStatusColors.sheetBackground(brightness),
          AppStatusColors.sheetTitle(brightness),
        );
      case 'VĐV':
        return (
          AppStatusColors.highlight(brightness).withValues(alpha: 0.18),
          AppStatusColors.highlight(brightness),
        );
      case 'Người mới bắt đầu':
        return (
          AppStatusColors.tabActive(brightness).withValues(alpha: 0.16),
          AppStatusColors.tabActive(brightness),
        );
      case 'Phục hồi chấn thương':
        final pair = AppStatusColors.danger(brightness);
        return (
          pair.container.withValues(alpha: 0.85),
          pair.onContainer,
        );
      default:
        return (
          AppStatusColors.tagBackgroundOf(context),
          scheme.onSurface,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _colors(context);
    final chip = Chip(
      visualDensity: VisualDensity.compact,
      label: Text(label),
      backgroundColor: colors.$1,
      side: BorderSide.none,
      labelStyle: theme.textTheme.labelMedium?.copyWith(color: colors.$2),
    );
    if (onPressed == null) return chip;
    return GestureDetector(onTap: onPressed, child: chip);
  }
}

class _ServiceRadioTile extends StatelessWidget {
  const _ServiceRadioTile({required this.service});

  final MockService service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          RadioListTile<String>(
            value: service.id,
            title: Text(service.name),
            subtitle: Text(
              '${service.priceLabel} · ${service.durationMinutes} phút',
            ),
          ),
          if (service.promoLabel != null)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: AppTag(label: service.promoLabel!, highlight: true),
            ),
        ],
      ),
    );
  }
}

class _WeeklyAvailabilityGrid extends StatelessWidget {
  const _WeeklyAvailabilityGrid({required this.slots});

  final List<MockAvailabilitySlot> slots;

  static const _weekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final accent = AppStatusColors.highlight(theme.brightness);

    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final day = today.add(Duration(days: index));
          final daySlots = slots
              .where((slot) => _sameDay(slot.date, day))
              .toList();
          final isToday = index == 0;
          return SizedBox(
            width: 88,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weekdayLabels[day.weekday - 1],
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isToday ? accent : null,
                      ),
                    ),
                    Text(
                      '${day.day}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: daySlots.isEmpty
                          ? Text(
                              '—',
                              style: theme.textTheme.bodySmall,
                            )
                          : Text(
                              [
                                for (final slot in daySlots)
                                  '${slot.startTime}–${slot.endTime}',
                              ].join('\n'),
                              style: theme.textTheme.labelSmall,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrainingLocationCard extends StatelessWidget {
  const _TrainingLocationCard({required this.location});

  final MockTrainingLocation location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTag(
              label: location.type,
              highlight: location.type == MockTrainingLocation.typeNearby,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(location.name, style: theme.textTheme.titleSmall),
            Text(location.address, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _StudentResultCard extends StatelessWidget {
  const _StudentResultCard({required this.result});

  final MockStudentResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppSpacing.borderRadiusSm,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        result.beforeImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppSpacing.borderRadiusSm,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        result.afterImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(result.studentLabel, style: theme.textTheme.titleSmall),
            Text(result.summary, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          StudentResultDetailScreen(result: result),
                    ),
                  );
                },
                child: const Text('Xem chi tiết'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewOverviewCard extends StatelessWidget {
  const _ReviewOverviewCard({required this.stats});

  final MockCoachReviewStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đánh giá', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (stats.count == 0)
              Text(
                'Chưa có đánh giá.',
                style: theme.textTheme.bodyMedium,
              )
            else ...[
              Text(
                stats.summaryLabel,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              for (var star = 5; star >= 1; star--) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '$star★',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: stats.percentOf(star),
                          minHeight: 8,
                          color: accent,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${(stats.percentOf(star) * 100).round()}%',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                if (star > 1) const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewCommentCard extends StatelessWidget {
  const _ReviewCommentCard({
    required this.review,
    required this.dateLabel,
  });

  final MockCoachReview review;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.reviewerName,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Text(dateLabel, style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  Icon(
                    i <= review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: accent,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(review.comment, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

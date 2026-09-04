import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_reviews.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_review.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_summary_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.coach.services.first.id;
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  MockService get _selectedService => widget.coach.services.firstWhere(
        (service) => service.id == _selectedServiceId,
      );

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
          appBar: AppBar(title: const Text('Chi tiết Coach')),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: AppSpacing.screenPadding,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.onPrimaryContainer,
                      child: Text(
                        coach.initials,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      coach.name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AppRating(
                          value: coach.rating,
                          suffix: '${coach.yearsExperience} năm kinh nghiệm',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: AppTag(
                        label: coach.nextSlotLabel,
                        highlight: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (coach.bio.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: AppSpacing.cardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giới thiệu',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                coach.bio,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    Text('Chọn dịch vụ', style: theme.textTheme.titleMedium),
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
                              RadioListTile<String>(
                                value: service.id,
                                title: Text(service.name),
                                subtitle: Text(
                                  '${service.priceLabel} · ${service.durationMinutes} phút',
                                ),
                                contentPadding: EdgeInsets.zero,
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
                                  AppTag(label: package.name),
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
                      child: const Text('Tiếp tục'),
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

import 'package:flutter/material.dart' hide Badge;
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_badge.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_photo_grid.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_post_detail_screen.dart';

class MyJournalScreen extends StatelessWidget {
  const MyJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final userId = session.profile?.id;
        final posts = session.journalPosts
            .where((post) => post.userId == userId)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final streak = session.userStreak.currentStreak;
        final streakLabel = streak > 0
            ? '🔥 $streak ngày liên tiếp'
            : '🔥 Chưa có chuỗi ngày tập';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Nhật ký của tôi')),
          body: JournalPhotoGrid(
            posts: posts,
            emptyMessage:
                'Chưa có bài nhật ký. Hoàn thành buổi tập rồi chia sẻ nhé.',
            onTap: (post) => _openPost(context, post),
            header: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(streakLabel, style: theme.textTheme.titleMedium),
                  if (session.userBadges.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final earned in session.userBadges)
                          _BadgeChip(badgeId: earned.badgeId),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openPost(BuildContext context, JournalPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JournalPostDetailScreen(postId: post.id),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badgeId});

  final String badgeId;

  @override
  Widget build(BuildContext context) {
    Badge? catalog;
    for (final item in mockBadges) {
      if (item.id == badgeId) {
        catalog = item;
        break;
      }
    }
    if (catalog == null) return const SizedBox.shrink();
    final badge = catalog;

    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final pair = switch (badgeId) {
      'badge_streak_3' => AppStatusColors.warning(brightness),
      'badge_streak_7' => AppStatusColors.success(brightness),
      _ => AppStatusPair(
          container: scheme.primaryContainer,
          onContainer: scheme.onPrimaryContainer,
        ),
    };

    return InkWell(
      borderRadius: AppSpacing.borderRadiusSm,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(badge.name),
              content: Text(badge.description),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: pair.container,
        foregroundColor: pair.onContainer,
        child: Icon(_iconFor(badgeId), size: 20),
      ),
    );
  }

  IconData _iconFor(String id) {
    switch (id) {
      case 'badge_first_session':
        return Icons.emoji_events_outlined;
      case 'badge_streak_3':
        return Icons.local_fire_department_outlined;
      case 'badge_streak_7':
        return Icons.workspace_premium_outlined;
      default:
        return Icons.military_tech_outlined;
    }
  }
}

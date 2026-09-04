import 'dart:io';

import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_profile.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_media.dart';

String formatJournalTimestamp(DateTime at) {
  final diff = DateTime.now().difference(at);
  if (diff.isNegative || diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
  if (diff.inDays < 1) return '${diff.inHours} giờ trước';
  if (diff.inDays < 7) return '${diff.inDays} ngày trước';
  final dd = at.day.toString().padLeft(2, '0');
  final mm = at.month.toString().padLeft(2, '0');
  final hh = at.hour.toString().padLeft(2, '0');
  final min = at.minute.toString().padLeft(2, '0');
  return '$dd/$mm $hh:$min';
}

String journalInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'U';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

class JournalPostCard extends StatelessWidget {
  const JournalPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.authorNameOverride,
    this.showSocial = true,
  });

  final JournalPost post;
  final VoidCallback? onTap;
  final String? authorNameOverride;
  final bool showSocial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = MockUserSession.instance;
    final author = session.profileById(post.userId);
    final authorName = authorNameOverride ??
        author?.name ??
        session.displayNameFor(post.userId);
    final mediaPath = post.mediaUrl;
    final hasMedia = journalHasMedia(post);
    final userId = session.profile?.id;
    final liked = userId != null && post.likeUserIds.contains(userId);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _AuthorAvatar(user: author, name: authorName),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authorName, style: theme.textTheme.titleMedium),
                        Text(
                          formatJournalTimestamp(post.createdAt),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTag(label: post.serviceName),
              Text(
                '${post.coachName}  ·  ${post.durationMinutes} phút',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (post.caption.isNotEmpty)
                Text(post.caption, style: theme.textTheme.bodyLarge),
              if (hasMedia) ...[
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppSpacing.borderRadiusSm,
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: journalMediaImage(mediaPath!, fit: BoxFit.cover),
                  ),
                ),
              ],
              if (showSocial) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_outline,
                      size: 18,
                      color: liked
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${post.likeUserIds.length}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${post.commentCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({required this.user, required this.name});

  final MockUserProfile? user;
  final String name;

  @override
  Widget build(BuildContext context) {
    final path = user?.avatarPath;
    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: FileImage(File(path)),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Text(
        journalInitials(name),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

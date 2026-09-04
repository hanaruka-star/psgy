import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_comment.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_post_card.dart';

class JournalPostDetailScreen extends StatefulWidget {
  const JournalPostDetailScreen({
    super.key,
    required this.postId,
    this.readOnly = false,
  });

  final String postId;
  final bool readOnly;

  @override
  State<JournalPostDetailScreen> createState() =>
      _JournalPostDetailScreenState();
}

class _JournalPostDetailScreenState extends State<JournalPostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (widget.readOnly) return;
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    MockUserSession.instance.addJournalComment(widget.postId, text);
    _commentController.clear();
  }

  JournalPost? _resolvePost(MockUserSession session) {
    final fromUser = session.journalPostById(widget.postId);
    if (fromUser != null) return fromUser;
    if (!widget.readOnly) return null;
    for (final post in MockCoachSession.instance.studentJournalPosts) {
      if (post.id == widget.postId) return post;
    }
    return null;
  }

  void _toggleLike() {
    if (widget.readOnly) return;
    MockUserSession.instance.toggleJournalLike(widget.postId);
  }

  void _report(BuildContext context) {
    if (widget.readOnly) return;
    final session = MockUserSession.instance;
    final post = session.journalPostById(widget.postId);
    if (post == null || post.reported) return;
    session.reportJournalPost(widget.postId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã ghi nhận báo cáo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final post = _resolvePost(session);
        if (post == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bài viết')),
            body: const Center(child: Text('Không tìm thấy bài viết.')),
          );
        }

        final comments = widget.readOnly
            ? const <JournalComment>[]
            : session.commentsForPost(post.id);
        final userId = session.profile?.id;
        final liked =
            userId != null && post.likeUserIds.contains(userId);
        final authorOverride = widget.readOnly
            ? MockCoachSession.instance.studentNameFor(post.userId)
            : null;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Bài viết'),
            actions: [
              if (!widget.readOnly)
                TextButton(
                  onPressed: post.reported ? null : () => _report(context),
                  child: Text(post.reported ? 'Đã báo cáo' : 'Báo cáo'),
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: AppSpacing.screenPadding,
                  children: [
                    JournalPostCard(
                      post: post,
                      authorNameOverride: authorOverride,
                      showSocial: !widget.readOnly,
                    ),
                    if (!widget.readOnly) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            liked ? 'Đã thích' : 'Thả tim',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Bình luận', style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      if (comments.isEmpty)
                        Text(
                          'Chưa có bình luận.',
                          style: theme.textTheme.bodyMedium,
                        )
                      else
                        for (final comment in comments)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.authorName,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(comment.text),
                                Text(
                                  formatJournalTimestamp(comment.createdAt),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                    ],
                  ],
                ),
              ),
              if (!widget.readOnly)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendComment(),
                            decoration: const InputDecoration(
                              hintText: 'Viết bình luận...',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        IconButton.filled(
                          onPressed: _sendComment,
                          icon: const Icon(Icons.send),
                        ),
                      ],
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

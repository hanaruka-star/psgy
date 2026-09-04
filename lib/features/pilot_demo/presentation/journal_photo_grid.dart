import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_media.dart';

class JournalPhotoGrid extends StatelessWidget {
  const JournalPhotoGrid({
    super.key,
    required this.posts,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.header,
    this.emptyMessage = 'Chưa có bài nhật ký.',
  });

  final List<JournalPost> posts;
  final ValueChanged<JournalPost> onTap;
  final EdgeInsets padding;
  final Widget? header;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final visible = posts.where(journalHasMedia).toList();
    return CustomScrollView(
      slivers: [
        if (header != null)
          SliverToBoxAdapter(child: header),
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Center(
                child: Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: padding,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = visible[index];
                  return GestureDetector(
                    onTap: () => onTap(post),
                    child: ClipRect(
                      child: SizedBox.expand(
                        child: journalMediaImage(post.mediaUrl!),
                      ),
                    ),
                  );
                },
                childCount: visible.length,
              ),
            ),
          ),
      ],
    );
  }
}

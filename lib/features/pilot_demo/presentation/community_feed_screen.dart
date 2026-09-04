import 'package:flutter/material.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_photo_grid.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_post_detail_screen.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final posts = session.journalPosts
            .where((post) => post.privacy == JournalPrivacy.public)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Cộng đồng PSgy')),
          body: JournalPhotoGrid(
            posts: posts,
            emptyMessage: 'Chưa có bài công khai.',
            onTap: (post) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => JournalPostDetailScreen(postId: post.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

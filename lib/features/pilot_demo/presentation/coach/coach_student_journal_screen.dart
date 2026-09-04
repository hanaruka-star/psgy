import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_photo_grid.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_post_detail_screen.dart';

/// Nhật ký học viên — đọc-only từ seed MockCoachSession.
/// Data mock độc lập minh hoạ UI, không kéo từ MockUserSession.
/// Bản thật cần Firestore sync xuyên 2 app (việc đội dev sau).
class CoachStudentJournalScreen extends StatelessWidget {
  const CoachStudentJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MockCoachSession.instance;
    final theme = Theme.of(context);
    final posts = List.of(session.studentJournalPosts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Nhật ký học viên'),
        titleTextStyle: AppStatusColors.headingStyle(context),
        foregroundColor: AppStatusColors.sheetTitle(theme.brightness),
      ),
      body: JournalPhotoGrid(
        posts: posts,
        emptyMessage: 'Chưa có bài nhật ký.',
        onTap: (post) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => JournalPostDetailScreen(
                postId: post.id,
                readOnly: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

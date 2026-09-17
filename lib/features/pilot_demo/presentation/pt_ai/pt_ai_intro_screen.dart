import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_picker_screen.dart';

class PtAiIntroScreen extends StatelessWidget {
  const PtAiIntroScreen({super.key});

  static const title = 'PT AI — Tập cùng AI, mọi lúc mọi nơi';
  static const body =
      'Không cần đặt lịch, không cần chờ Coach rảnh — chỉ cần điện thoại và một góc nhỏ đủ đứng tập. PT AI đồng hành cùng bạn qua camera, giống như một cuộc gọi video: AI sẽ theo dõi tư thế của bạn trong thời gian thực và nhắc bạn chỉnh sửa ngay khi cần, để mỗi động tác căn bản đều đúng kỹ thuật và an toàn. Phù hợp cho buổi tập nhẹ tại nhà, khởi động trước khi đến gym, hoặc đơn giản là muốn tập ngay mà không phải chờ ai.';
  static const shortLabel = 'AI đồng hành · Camera theo dõi · Tư thế chuẩn';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('PT AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: AppShapes.rect(radius: AppSpacing.radiusMd),
                  ),
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppStatusColors.highlight(brightness),
                          foregroundColor: AppStatusColors.onHighlight(brightness),
                          child: const Icon(Icons.videocam_outlined, size: 28),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            shortLabel,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  style: AppStatusColors.headingStyle(
                    context,
                    theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  body,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PtAiPickerScreen(),
                      ),
                    );
                  },
                  child: const Text('Bắt đầu'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

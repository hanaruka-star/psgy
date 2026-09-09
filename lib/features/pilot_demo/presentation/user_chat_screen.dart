import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_message.dart';
import 'package:psgy/features/pilot_demo/presentation/widgets/coach_avatar.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({
    super.key,
    this.bookingId,
    this.inquiryCoachId,
    required this.coachName,
  }) : assert(bookingId != null || inquiryCoachId != null);

  final String? bookingId;
  final String? inquiryCoachId;
  final String coachName;

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool get _isInquiry => widget.inquiryCoachId != null;

  @override
  void initState() {
    super.initState();
    final coachId = widget.inquiryCoachId;
    if (coachId != null) {
      MockUserSession.instance.ensureCoachInquiry(coachId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final session = MockUserSession.instance;
    final coachId = widget.inquiryCoachId;
    if (coachId != null) {
      session.addInquiryMessage(coachId, text);
    } else {
      session.addUserMessage(widget.bookingId!, text);
    }
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  List<MockMessage> _messages(MockUserSession session) {
    final coachId = widget.inquiryCoachId;
    if (coachId != null) return session.inquiryMessagesFor(coachId);
    return session.messagesFor(widget.bookingId!);
  }

  MockCoach? _coach(MockUserSession session) {
    var id = widget.inquiryCoachId;
    if (id == null && widget.bookingId != null) {
      id = session.bookingById(widget.bookingId!)?.coachId;
    }
    return mockCoachById(id) ?? mockCoachByName(widget.coachName);
  }

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final messages = _messages(session);
        final coach = _coach(session);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Row(
              children: [
                if (coach != null) ...[
                  CoachAvatar.coach(coach, radius: 16),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    widget.coachName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            bottom: _isInquiry
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(28),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        'Trao đổi trước khi đặt lịch',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  )
                : null,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: AppSpacing.screenPadding,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMine = !message.isFromCoach;
                    final bubble = ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2,
                        ),
                        decoration: ShapeDecoration(
                          color: isMine
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHigh,
                          shape: AppShapes.rect(radius: AppSpacing.radiusMd),
                        ),
                        child: Column(
                          crossAxisAlignment: isMine
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isMine
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              message.sentAtLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isMine
                                    ? theme.colorScheme.onPrimaryContainer
                                        .withValues(alpha: 0.7)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    if (isMine) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: bubble,
                      );
                    }
                    if (coach == null) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: bubble,
                      );
                    }
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.sm,
                              bottom: AppSpacing.sm,
                            ),
                            child: CoachAvatar.coach(coach, radius: 16),
                          ),
                          Flexible(child: bubble),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(
                            hintText: 'Nhắn tin cho Coach...',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton.filled(
                        onPressed: _send,
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

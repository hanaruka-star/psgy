import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class CreateJournalPostScreen extends StatefulWidget {
  const CreateJournalPostScreen({
    super.key,
    required this.coach,
    required this.service,
    required this.booking,
  });

  final MockCoach coach;
  final MockService service;
  final MockBookingRequest booking;

  @override
  State<CreateJournalPostScreen> createState() =>
      _CreateJournalPostScreenState();
}

class _CreateJournalPostScreenState extends State<CreateJournalPostScreen> {
  static const _captionMax = 100;

  final _captionController = TextEditingController();
  String? _mediaPath;
  JournalPrivacy _privacy = JournalPrivacy.private;

  int get _captionRemaining =>
      _captionMax - _captionController.text.length;

  bool get _canPublish => _mediaPath != null;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked == null || !mounted) return;
    setState(() => _mediaPath = picked.path);
  }

  void _publish() {
    if (!_canPublish) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất 1 ảnh')),
      );
      return;
    }

    MockUserSession.instance.addJournalPost(
      bookingId: widget.booking.id,
      coachId: widget.coach.id,
      coachName: widget.coach.name,
      serviceName: widget.service.name,
      durationMinutes: widget.service.durationMinutes,
      caption: _captionController.text.trim(),
      mediaUrl: _mediaPath,
      privacy: _privacy,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đăng nhật ký buổi tập')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = widget.service;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Chia sẻ buổi tập')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.coach.name),
                  Text('${service.durationMinutes} phút'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Ảnh buổi tập', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Bắt buộc · tối thiểu 1 ảnh',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_mediaPath != null) ...[
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: Image.file(
                File(_mediaPath!),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_outlined),
            label: Text(_mediaPath == null ? 'Thêm ảnh' : 'Đổi ảnh'),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _captionController,
            maxLines: 3,
            maxLength: _captionMax,
            decoration: InputDecoration(
              labelText: 'Cảm nhận (tuỳ chọn)',
              hintText: 'Buổi tập hôm nay thế nào?',
              counterText: 'Còn $_captionRemaining ký tự',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Ai xem được', style: theme.textTheme.titleMedium),
          RadioGroup<JournalPrivacy>(
            groupValue: _privacy,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _privacy = value);
            },
            child: const Column(
              children: [
                RadioListTile<JournalPrivacy>(
                  title: Text('Riêng tư'),
                  value: JournalPrivacy.private,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<JournalPrivacy>(
                  title: Text('Chỉ PT'),
                  value: JournalPrivacy.coachOnly,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<JournalPrivacy>(
                  title: Text('Công khai'),
                  value: JournalPrivacy.public,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canPublish ? _publish : null,
              child: const Text('Đăng'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:psgy/features/user/domain/entities/my_parking_record.dart';
import 'package:psgy/features/user/presentation/providers/my_parking_provider.dart';

class MyParkingDetailSheet extends ConsumerStatefulWidget {
  const MyParkingDetailSheet({super.key, required this.record});

  final MyParkingRecord record;

  @override
  ConsumerState<MyParkingDetailSheet> createState() =>
      _MyParkingDetailSheetState();
}

class _MyParkingDetailSheetState extends ConsumerState<MyParkingDetailSheet> {
  bool _isUpdatingPhoto = false;

  @override
  Widget build(BuildContext context) {
    final record =
        ref.watch(myParkingProvider).value?.currentRecord ?? widget.record;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '🚗 Xe của bạn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (record.photoPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(record.photoPath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_camera_outlined, size: 48),
              ),
            const SizedBox(height: 16),
            Text(
              DateFormat('HH:mm - dd/MM/yyyy').format(record.parkedAt),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${record.latitude.toStringAsFixed(5)}, '
              '${record.longitude.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _isUpdatingPhoto ? null : () => _updatePhoto(record),
              icon: const Text('📷'),
              label: _isUpdatingPhoto
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cập nhật ảnh'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _confirmDelete(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xoá vị trí đã lưu'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePhoto(MyParkingRecord record) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked == null) return;

    setState(() => _isUpdatingPhoto = true);
    try {
      await ref.read(myParkingProvider.notifier).saveParking(
            latitude: record.latitude,
            longitude: record.longitude,
            photoPath: picked.path,
          );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không cập nhật được ảnh')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingPhoto = false);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá vị trí?'),
        content: const Text('Bạn sẽ mất ảnh và toạ độ đã lưu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(myParkingProvider.notifier).clearParking();
    if (context.mounted) Navigator.pop(context);
  }
}

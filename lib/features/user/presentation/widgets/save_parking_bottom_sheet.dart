import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/features/user/presentation/providers/my_parking_provider.dart';

class SaveParkingBottomSheet extends ConsumerStatefulWidget {
  const SaveParkingBottomSheet({super.key});

  @override
  ConsumerState<SaveParkingBottomSheet> createState() =>
      _SaveParkingBottomSheetState();
}

class _SaveParkingBottomSheetState
    extends ConsumerState<SaveParkingBottomSheet> {
  String? _selectedImagePath;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(userLocationProvider);

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
              '📍 Lưu vị trí đậu xe',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            locationAsync.when(
              data: (loc) => Text(
                loc != null
                    ? '${loc.latitude.toStringAsFixed(5)}, '
                        '${loc.longitude.toStringAsFixed(5)}'
                    : 'Không lấy được vị trí',
              ),
              loading: () => const Text('Đang lấy vị trí...'),
              error: (_, __) => const Text('Không lấy được vị trí'),
            ),
            const SizedBox(height: 16),
            if (_selectedImagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_selectedImagePath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            OutlinedButton.icon(
              onPressed: _isSaving ? null : _pickImage,
              icon: const Text('📷'),
              label: const Text('Chụp / Chọn ảnh'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _isSaving ? null : () => _save(context),
              child: _isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu vị trí'),
            ),
            TextButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
    }
  }

  Future<void> _save(BuildContext context) async {
    final loc = ref.read(userLocationProvider).valueOrNull;
    if (loc == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có vị trí GPS')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(myParkingProvider.notifier).saveParking(
            latitude: loc.latitude,
            longitude: loc.longitude,
            photoPath: _selectedImagePath,
          );
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được vị trí')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_link/features/user/presentation/providers/user_profile_provider.dart';

class VehicleRegistrationScreen extends ConsumerStatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  ConsumerState<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState
    extends ConsumerState<VehicleRegistrationScreen> {
  String? _photoPath;
  final _plateController = TextEditingController();
  bool _isPersonal = true;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() => _photoPath = picked.path);
    }
  }

  Future<void> _submit() async {
    final plate = _plateController.text.trim();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập biển số xe')),
      );
      return;
    }
    if (_photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chụp ảnh xe')),
      );
      return;
    }

    await ref.read(userProfileProvider.notifier).addVehicle(
          plate: plate,
          localPhotoPath: _photoPath!,
          isPersonal: _isPersonal,
        );

    final state = ref.read(userProfileProvider).value;
    if (state?.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state!.error!)),
      );
      return;
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final profileState =
        ref.watch(userProfileProvider).value ?? const UserProfileState();

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký xe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickPhoto,
              child: _photoPath == null
                  ? Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera_outlined, size: 48),
                          SizedBox(height: 8),
                          Text('Chụp ảnh xe'),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_photoPath!),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _plateController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Biển số xe',
                hintText: '51G-12345',
              ),
              onChanged: (value) {
                final upper = value.toUpperCase();
                if (upper != value) {
                  _plateController.value = _plateController.value.copyWith(
                    text: upper,
                    selection:
                        TextSelection.collapsed(offset: upper.length),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('🚗 Xe cá nhân'),
                    selected: _isPersonal,
                    onSelected: (_) => setState(() => _isPersonal = true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('🤝 Xe mượn'),
                    selected: !_isPersonal,
                    onSelected: (_) => setState(() => _isPersonal = false),
                  ),
                ),
              ],
            ),
            if (!_isPersonal) ...[
              const SizedBox(height: 8),
              Text(
                'Lần sau bạn sẽ cần đăng ký lại',
                style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: profileState.isLoading ? null : _submit,
              child: profileState.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Đăng ký xe'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/auth_providers.dart';

class OwnerDashboardPlaceholderScreen extends ConsumerWidget {
  const OwnerDashboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          TextButton(
            onPressed: () async {
              final signOutUseCase = ref.read(signOutUseCaseProvider);
              await signOutUseCase();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Owner dashboard placeholder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

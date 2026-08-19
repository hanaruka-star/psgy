import 'package:flutter/material.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/shared/widgets/app_error_view.dart';

class FatalErrorScreen extends StatelessWidget {
  final AppException error;
  final VoidCallback onRetry;

  const FatalErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppErrorView.fromError(
          error,
          onPrimaryAction: onRetry,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';
import 'package:parking_link/shared/widgets/app_error_view.dart';

class StaffErrorMessage extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondary;

  const StaffErrorMessage({
    super.key,
    required this.error,
    this.onRetry,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final mapped = error is AppException ? error : mapFirebaseException(error);
    return AppErrorView.fromError(
      mapped,
      compact: true,
      onPrimaryAction: onRetry,
      onSecondaryAction: onSecondary,
    );
  }
}

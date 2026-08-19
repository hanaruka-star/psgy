import 'package:flutter/material.dart';
import 'package:parking_link/core/error/app_error_handler.dart';
import 'package:parking_link/core/error/app_error_ui.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';

void showErrorSnackBar(
  BuildContext context,
  AppException e, {
  VoidCallback? onRetry,
  bool keepExistingData = false,
}) {
  appErrorHandler.showSnackBar(
    context,
    e,
    onRetry: onRetry,
    keepExistingData: keepExistingData,
  );
}

void showMappedErrorSnackBar(
  BuildContext context,
  Object error, {
  VoidCallback? onRetry,
  bool keepExistingData = false,
}) {
  showErrorSnackBar(
    context,
    mapFirebaseException(error),
    onRetry: onRetry,
    keepExistingData: keepExistingData,
  );
}

Future<void> showErrorRecoverySheet(
  BuildContext context,
  Object error, {
  VoidCallback? onPrimary,
  VoidCallback? onSecondary,
}) {
  final presentation = AppErrorUi.from(error);
  return appErrorHandler.showRecoverySheet(
    context,
    presentation,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
  );
}

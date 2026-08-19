import 'package:flutter/material.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/error_mapper.dart';
import 'package:psgy/core/theme/app_colors.dart';

enum AppErrorCategory {
  network,
  auth,
  permission,
  slotUnavailable,
  location,
  quota,
  unknown,
}

class AppErrorPresentation {
  final AppErrorCategory category;
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
  final bool showSupportAction;

  const AppErrorPresentation({
    required this.category,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.primaryActionLabel = 'Thử lại',
    this.secondaryActionLabel,
    this.showSupportAction = false,
  });

  AppErrorPresentation copyWith({
    AppErrorCategory? category,
    String? title,
    String? message,
    IconData? icon,
    Color? iconColor,
    Color? iconBackground,
    String? primaryActionLabel,
    String? secondaryActionLabel,
    bool? showSupportAction,
  }) {
    return AppErrorPresentation(
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBackground: iconBackground ?? this.iconBackground,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      secondaryActionLabel: secondaryActionLabel ?? this.secondaryActionLabel,
      showSupportAction: showSupportAction ?? this.showSupportAction,
    );
  }
}

abstract final class AppErrorUi {
  static AppErrorPresentation from(Object error) {
    final exception = error is AppException ? error : mapFirebaseException(error);

    if (exception is NetworkException) {
      final isQuota = exception.code == 'resource-exhausted';
      final isTimeout = exception.code == 'deadline-exceeded';
      return AppErrorPresentation(
        category: isQuota ? AppErrorCategory.quota : AppErrorCategory.network,
        title: isQuota
            ? 'Hệ thống đang bận'
            : isTimeout
                ? 'Kết nối quá chậm'
                : 'Không có kết nối mạng',
        message: exception.message,
        icon: isQuota
            ? Icons.hourglass_top_rounded
            : Icons.wifi_off_rounded,
        iconColor: isQuota ? AppColors.warning : AppColors.danger,
        iconBackground: isQuota
            ? AppColors.warningContainer
            : AppColors.dangerContainer,
        primaryActionLabel: 'Thử lại',
        secondaryActionLabel: 'Dùng dữ liệu đã lưu',
      );
    }

    if (exception is AuthException) {
      final expired = exception.code == 'user-token-expired' ||
          exception.code == 'id-token-expired';
      return AppErrorPresentation(
        category: AppErrorCategory.auth,
        title: expired ? 'Phiên đăng nhập hết hạn' : 'Không thể đăng nhập',
        message: exception.message,
        icon: Icons.lock_clock_rounded,
        iconColor: AppColors.primary,
        iconBackground: AppColors.primaryContainer,
        primaryActionLabel: 'Đăng nhập lại',
        secondaryActionLabel: 'Quay lại',
      );
    }

    if (exception is PermissionException) {
      return AppErrorPresentation(
        category: AppErrorCategory.permission,
        title: 'Không thể truy cập',
        message: exception.message,
        icon: Icons.shield_outlined,
        iconColor: AppColors.warning,
        iconBackground: AppColors.warningContainer,
        primaryActionLabel: 'Thử lại',
        showSupportAction: true,
      );
    }

    if (exception is SlotUnavailableException) {
      return AppErrorPresentation(
        category: AppErrorCategory.slotUnavailable,
        title: 'Hết chỗ trống',
        message: exception.message,
        icon: Icons.local_parking_rounded,
        iconColor: AppColors.warning,
        iconBackground: AppColors.warningContainer,
        primaryActionLabel: 'Làm mới dữ liệu',
        secondaryActionLabel: 'Xem loại xe khác',
      );
    }

    return AppErrorPresentation(
      category: AppErrorCategory.unknown,
      title: 'Đã có sự cố nhỏ',
      message: exception.message,
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.primary,
      iconBackground: AppColors.primaryContainer,
      primaryActionLabel: 'Thử lại',
      showSupportAction: true,
    );
  }

  static AppErrorPresentation locationDenied({bool serviceDisabled = false}) {
    return AppErrorPresentation(
      category: AppErrorCategory.location,
      title: serviceDisabled
          ? 'GPS đang tắt'
          : 'Không thể xác định vị trí',
      message: serviceDisabled
          ? 'Bật Dịch vụ vị trí trong Cài đặt để tìm bãi gần bạn.'
          : 'Cho phép truy cập vị trí hoặc chọn khu vực trên bản đồ thủ công.',
      icon: Icons.location_off_rounded,
      iconColor: AppColors.primary,
      iconBackground: AppColors.primaryContainer,
      primaryActionLabel: 'Thử lại',
      secondaryActionLabel: 'Dùng vị trí thủ công',
    );
  }

  static AppErrorPresentation offline({String? cacheAgeLabel}) {
    return AppErrorPresentation(
      category: AppErrorCategory.network,
      title: 'Bạn đang offline',
      message: cacheAgeLabel == null
          ? 'Đang hiển thị dữ liệu đã lưu trên máy.'
          : 'Hiển thị dữ liệu cache lần cuối: $cacheAgeLabel.',
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.danger,
      iconBackground: AppColors.dangerContainer,
      primaryActionLabel: 'Thử kết nối lại',
      secondaryActionLabel: 'Tiếp tục xem cache',
    );
  }

  static String friendlyMessage(Object error) {
    return from(error).message;
  }
}

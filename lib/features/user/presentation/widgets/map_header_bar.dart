import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/app_mode.dart';
import 'package:psgy/features/user/presentation/providers/vehicle_filter_providers.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/user/domain/entities/parking_enums.dart';
import 'package:psgy/features/user/presentation/providers/my_parking_provider.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';
import 'package:psgy/features/user/presentation/providers/user_profile_provider.dart';
import 'package:psgy/features/user/presentation/screens/phone_auth_screen.dart';
import 'package:psgy/features/user/presentation/screens/qr_screen.dart';
import 'package:psgy/features/user/presentation/screens/user_notification_settings_screen.dart';
import 'package:psgy/features/user/presentation/screens/vehicle_list_screen.dart';
import 'package:psgy/features/user/presentation/screens/vehicle_registration_screen.dart';
import 'package:psgy/features/user/presentation/screens/watchlist_screen.dart';
import 'package:psgy/features/user/presentation/widgets/my_parking_detail_sheet.dart';
import 'package:psgy/features/user/presentation/widgets/save_parking_bottom_sheet.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';

/// Material 3 header: logo, vehicle-type chips, watchlist + notifications.
class MapHeaderBar extends ConsumerWidget {
  final int watchlistBadgeCount;
  final VoidCallback? onLogoLongPress;
  final VoidCallback? onParkingListTap;

  const MapHeaderBar({
    super.key,
    required this.watchlistBadgeCount,
    this.onLogoLongPress,
    this.onParkingListTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final vehicleFilter = ref.watch(vehicleTypeFilterProvider);
    final parkingAsync = ref.watch(myParkingProvider);
    final parkingMode =
        parkingAsync.value?.parkingMode ?? ParkingMode.none;

    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      color: colorScheme.surface.withValues(alpha: 0.96),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md - 4,
            AppSpacing.sm,
            AppSpacing.md - 4,
            AppSpacing.sm + 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onLongPress: onLogoLongPress,
                    child: ClipRRect(
                      borderRadius: AppSpacing.borderRadiusSm,
                      child: Image.asset(
                        'assets/images/branding/logo_light.png',
                        height: 32,
                        width: 32,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.local_parking_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Parking Link',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ),
                  _HeaderIconButton(
                    tooltip: 'Watchlist',
                    icon: Icons.bookmark_outline_rounded,
                    badge: watchlistBadgeCount,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WatchlistScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _HeaderIconButton(
                    tooltip: 'Thông báo',
                    icon: Icons.notifications_outlined,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const UserNotificationSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  if (AppConfig.showDevModeSwitcher) ...[
                    const SizedBox(width: AppSpacing.sm),
                    _HeaderIconButton(
                      tooltip: 'Chuyển sang Staff',
                      icon: Icons.engineering_outlined,
                      onTap: () {
                        ref.read(appModeProvider).switchToCoach();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _VehicleTypeChip(
                            label: 'Ô tô',
                            icon: Icons.directions_car_filled_rounded,
                            value: 'car',
                            selected: vehicleFilter == 'car',
                            selectedColor: AppColors.danger,
                            onSelected: () => _selectFilter(ref, 'car'),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _VehicleTypeChip(
                            label: 'Xe máy',
                            icon: Icons.two_wheeler_rounded,
                            value: 'moto',
                            selected: vehicleFilter == 'moto',
                            selectedColor: colorScheme.primary,
                            onSelected: () => _selectFilter(ref, 'moto'),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _VehicleTypeChip(
                            label: 'Tất cả',
                            icon: Icons.tune_rounded,
                            value: 'all',
                            selected: vehicleFilter == 'all',
                            selectedColor: colorScheme.tertiary,
                            onSelected: () => _selectFilter(ref, 'all'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (onParkingListTap != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    _MyParkingButton(
                      mode: parkingMode,
                      onTap: () => _onMyParkingTap(context, ref, parkingMode),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectFilter(WidgetRef ref, String type) {
    HapticFeedback.selectionClick();
    unawaited(ref.read(vehicleTypeFilterProvider.notifier).select(type));
  }

  void _onMyParkingTap(
    BuildContext context,
    WidgetRef ref,
    ParkingMode mode,
  ) {
    HapticFeedback.selectionClick();
    switch (mode) {
      case ParkingMode.none:
        showModalBottomSheet<void>(
          context: context,
          builder: (sheetContext) => _ParkingActionSheet(
            onSaveLocation: () {
              Navigator.pop(sheetContext);
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const SaveParkingBottomSheet(),
              );
            },
            onCheckin: () {
              Navigator.pop(sheetContext);
              unawaited(_handleCheckinFlow(context, ref));
            },
          ),
        );
      case ParkingMode.selfManaged:
      case ParkingMode.checkedIn:
        final record = ref.read(myParkingProvider).value?.currentRecord;
        if (record == null) return;
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => MyParkingDetailSheet(record: record),
        );
    }
  }

  Future<void> _handleCheckinFlow(BuildContext context, WidgetRef ref) async {
    var profileState = ref.read(userProfileProvider).value;

    if (profileState?.profile == null) {
      final authOk = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      );
      if (authOk != true || !context.mounted) return;
      await ref.read(userProfileProvider.future);
      profileState = ref.read(userProfileProvider).value;
    }

    if (profileState?.profile == null) return;

    if (profileState!.vehicles.isEmpty) {
      if (!context.mounted) return;
      final registered = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const VehicleRegistrationScreen(),
        ),
      );
      if (registered != true || !context.mounted) return;
      await ref.read(userProfileProvider.future);
      profileState = ref.read(userProfileProvider).value;
    }

    if (!context.mounted) return;

    final vehicle = await Navigator.push<UserVehicle>(
      context,
      MaterialPageRoute(builder: (_) => const VehicleListScreen()),
    );

    if (vehicle == null || !context.mounted) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => QrScreen(vehicle: vehicle),
      ),
    );
  }
}

class _ParkingActionSheet extends StatelessWidget {
  const _ParkingActionSheet({
    required this.onSaveLocation,
    required this.onCheckin,
  });

  final VoidCallback onSaveLocation;
  final VoidCallback onCheckin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('📍 Lưu vị trí đậu xe (tự quản lý)'),
            onTap: onSaveLocation,
          ),
          ListTile(
            leading: const Icon(Icons.local_parking_outlined),
            title: const Text('🅿️ Gửi xe vào bãi pilot'),
            onTap: onCheckin,
          ),
        ],
      ),
    );
  }
}

class _MyParkingButton extends StatelessWidget {
  const _MyParkingButton({
    required this.mode,
    required this.onTap,
  });

  final ParkingMode mode;
  final VoidCallback onTap;

  static const _purple = Color(0xFF8B5CF6);
  static const _purpleDark = Color(0xFF6D28D9);
  static const _badgeGreen = Color(0xFF10B981);

  Color get _backgroundColor => switch (mode) {
        ParkingMode.selfManaged => _purpleDark,
        ParkingMode.none || ParkingMode.checkedIn => _purple,
      };

  @override
  Widget build(BuildContext context) {
    const iconChild = Icon(
      Icons.local_parking_rounded,
      color: Colors.white,
      size: 22,
    );

    Widget buttonContent = Material(
      elevation: 4,
      shadowColor: _backgroundColor.withValues(alpha: 0.4),
      color: _backgroundColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: const SizedBox(
        width: 40,
        height: 40,
        child: Center(child: iconChild),
      ),
    );

    if (mode == ParkingMode.selfManaged) {
      buttonContent = Stack(
        clipBehavior: Clip.none,
        children: [
          buttonContent,
          const Positioned(
            top: -2,
            right: -2,
            child: SizedBox(
              width: 8,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _badgeGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ScaleTap(
      onTap: onTap,
      enableHaptic: true,
      child: Tooltip(
        message: 'Vị trí đậu xe',
        child: buttonContent,
      ),
    );
  }
}

class _VehicleTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onSelected;

  const _VehicleTypeChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = selected ? selectedColor : colorScheme.surfaceContainerHighest;
    final fg = selected ? Colors.white : colorScheme.onSurface;

    return ScaleTap(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: AppSpacing.chipPadding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected
                ? selectedColor
                : colorScheme.outline.withValues(alpha: 0.5),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int badge;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTap(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Badge(
          isLabelVisible: badge > 0,
          label: Text('$badge'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(icon, size: 22, color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

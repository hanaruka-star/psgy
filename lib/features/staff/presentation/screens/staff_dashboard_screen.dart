import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/di/auth_providers.dart';
import 'package:psgy/core/di/staff_providers.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/staff/presentation/screens/check_in_screen.dart';
import 'package:psgy/features/staff/presentation/screens/checkout_scan_screen.dart';
import 'package:psgy/features/staff/presentation/screens/qr_scan_screen.dart';
import 'package:psgy/features/staff/presentation/screens/check_out_screen.dart';
import 'package:psgy/features/staff/presentation/screens/history_screen.dart';
import 'package:psgy/features/staff/presentation/screens/manual_adjust_screen.dart';
import 'package:psgy/shared/widgets/empty_state.dart';
import 'package:psgy/shared/widgets/gradient_header.dart';
import 'package:psgy/shared/widgets/loading_shimmer.dart';
import 'package:psgy/shared/widgets/modern_card.dart';
import 'package:psgy/shared/widgets/offline_banner.dart';
import 'package:psgy/shared/widgets/quick_action_button.dart';
import 'package:psgy/shared/widgets/status_chip.dart';
import 'package:psgy/shared/widgets/ui_polish_widgets.dart';

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(staffProfileProvider);

    return profileAsync.when(
      loading: () => const _ScaffoldWithOfflineBanner(
        body: LoadingShimmerList(itemCount: 2, itemHeight: 140),
      ),
      error: (error, _) => _ScaffoldWithOfflineBanner(
        body: AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(staffProfileProvider),
          secondaryActionLabel: 'Đăng xuất',
          onSecondary: () => ref.read(signOutUseCaseProvider)(),
        ),
      ),
      data: (profile) {
        if (profile.lotId.isEmpty) {
          return const _ScaffoldWithOfflineBanner(
            body: EmptyStateView(
              icon: Icons.no_accounts_outlined,
              title: 'Chưa gán bãi xe',
              subtitle: 'Tài khoản staff chưa được gán bãi xe.',
            ),
          );
        }

        final lotAsync = ref.watch(staffLotProvider(profile.lotId));
        final vehicleTypesAsync =
            ref.watch(staffVehicleTypesProvider(profile.lotId));
        final todayStatsAsync =
            ref.watch(staffTodayStatsProvider(profile.lotId));

        return lotAsync.when(
          loading: () => const _ScaffoldWithOfflineBanner(
            body: LoadingShimmerList(itemCount: 2, itemHeight: 140),
          ),
          error: (error, _) => _ScaffoldWithOfflineBanner(
            body: AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(staffLotProvider(profile.lotId)),
              secondaryActionLabel: 'Đăng xuất',
              onSecondary: () => ref.read(signOutUseCaseProvider)(),
            ),
          ),
          data: (lot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(lot.name),
                actions: [
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: () async {
                      final signOutUseCase = ref.read(signOutUseCaseProvider);
                      await signOutUseCase();
                    },
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  vehicleTypesAsync.when(
                    loading: () => const LoadingShimmerList(
                      itemCount: 2,
                      itemHeight: 180,
                    ),
                    error: (error, _) => AppErrorState(
                      error: error,
                      onRetry: () => ref.invalidate(
                        staffVehicleTypesProvider(profile.lotId),
                      ),
                    ),
                    data: (vehicleTypes) {
                      final todayStats = todayStatsAsync.valueOrNull;

                      return _DashboardBody(
                        lot: lot,
                        vehicleTypes: vehicleTypes,
                        todayCheckIns: todayStats?.checkIns ?? 0,
                        todayCheckOuts: todayStats?.checkOuts ?? 0,
                      );
                    },
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: OfflineBanner(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ScaffoldWithOfflineBanner extends StatelessWidget {
  final Widget body;

  const _ScaffoldWithOfflineBanner({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          body,
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: OfflineBanner(),
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final ParkingLotEntity lot;
  final List<VehicleTypeEntity> vehicleTypes;
  final int todayCheckIns;
  final int todayCheckOuts;

  const _DashboardBody({
    required this.lot,
    required this.vehicleTypes,
    required this.todayCheckIns,
    required this.todayCheckOuts,
  });

  @override
  Widget build(BuildContext context) {
    final totalAvailable =
        vehicleTypes.fold<int>(0, (sum, v) => sum + v.availableSlots);
    final totalSlots =
        vehicleTypes.fold<int>(0, (sum, v) => sum + v.totalSlots);

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        GradientHeader(
          title: lot.name,
          subtitle: lot.address,
          icon: Icons.local_parking_rounded,
          trailing: _LiveStatusChip(isOpen: lot.isOpen),
        ),
        const SizedBox(height: AppSpacing.lg),
        _TodaySummaryCard(
          available: totalAvailable,
          total: totalSlots,
          checkIns: todayCheckIns,
          checkOuts: todayCheckOuts,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (vehicleTypes.isNotEmpty)
          QuickActionButton(
            icon: Icons.qr_code_scanner_rounded,
            label: '📷 Quét QR',
            onPressed: () => _openQrMenu(context, vehicleTypes),
          ),
        if (vehicleTypes.isNotEmpty) const SizedBox(height: AppSpacing.md),
        if (vehicleTypes.isEmpty)
          ModernCard(
            enableScaleTap: false,
            child: Text(
              'Chưa có cấu hình loại xe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          ...vehicleTypes.map(
            (vehicleType) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _VehicleTypeSection(
                vehicleType: vehicleType,
                allVehicleTypes: vehicleTypes,
              ),
            ),
          ),
        QuickActionButton(
          outlined: true,
          icon: Icons.history_rounded,
          label: 'Lịch sử hoạt động',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryScreen(
                  lotId: lot.id,
                  lotName: lot.name,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _openQrMenu(
    BuildContext context,
    List<VehicleTypeEntity> vehicleTypes,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Quét mã QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.login_rounded, color: Colors.green),
                title: const Text('Check-in (xe vào)'),
                subtitle: const Text('Quét mã gửi xe'),
                onTap: () => Navigator.pop(context, 'check_in'),
              ),
              ListTile(
                leading:
                    const Icon(Icons.logout_rounded, color: Colors.orange),
                title: const Text('Check-out (xe ra)'),
                subtitle: const Text('Quét mã rời bãi'),
                onTap: () => Navigator.pop(context, 'check_out'),
              ),
            ],
          ),
        );
      },
    );

    if (action == null || !context.mounted) return;
    if (action == 'check_in') {
      await _openCheckInScan(context, vehicleTypes);
    } else {
      await _openCheckOutScan(context, vehicleTypes);
    }
  }

  Future<String?> _selectVehicleType(
    BuildContext context,
    List<VehicleTypeEntity> vehicleTypes,
  ) async {
    if (vehicleTypes.length == 1) return vehicleTypes.first.type;
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Chọn loại xe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...vehicleTypes.map(
                (vt) => ListTile(
                  title: Text(_qrVehicleTypeTitle(vt.type)),
                  onTap: () => Navigator.pop(context, vt.type),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCheckInScan(
    BuildContext context,
    List<VehicleTypeEntity> vehicleTypes,
  ) async {
    final vehicleType = await _selectVehicleType(context, vehicleTypes);
    if (vehicleType == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrScanScreen(vehicleType: vehicleType),
      ),
    );
  }

  Future<void> _openCheckOutScan(
    BuildContext context,
    List<VehicleTypeEntity> vehicleTypes,
  ) async {
    final vehicleType = await _selectVehicleType(context, vehicleTypes);
    if (vehicleType == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScanScreen(vehicleType: vehicleType),
      ),
    );
  }
}

String _qrVehicleTypeTitle(String type) {
  switch (type) {
    case 'car':
      return 'Ô tô';
    case 'moto':
      return 'Xe máy';
    default:
      return type;
  }
}

class _LiveStatusChip extends StatefulWidget {
  final bool isOpen;

  const _LiveStatusChip({required this.isOpen});

  @override
  State<_LiveStatusChip> createState() => _LiveStatusChipState();
}

class _LiveStatusChipState extends State<_LiveStatusChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isOpen)
          FadeTransition(
            opacity: Tween(begin: 0.4, end: 1.0).animate(_pulse),
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ),
        StatusChip.open(isOpen: widget.isOpen),
      ],
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  final int available;
  final int total;
  final int checkIns;
  final int checkOuts;

  const _TodaySummaryCard({
    required this.available,
    required this.total,
    required this.checkIns,
    required this.checkOuts,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : available / total;

    return ModernCard(
      enableScaleTap: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hôm nay',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _SummaryStat(
                icon: Icons.local_parking_rounded,
                label: 'Còn trống',
                value: '$available/$total',
              ),
              _SummaryStat(
                icon: Icons.login_rounded,
                label: 'Check-in',
                value: '$checkIns',
              ),
              _SummaryStat(
                icon: Icons.logout_rounded,
                label: 'Check-out',
                value: '$checkOuts',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSlotProgressBar(value: ratio, height: 10),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _VehicleTypeSection extends ConsumerWidget {
  final VehicleTypeEntity vehicleType;
  final List<VehicleTypeEntity> allVehicleTypes;

  const _VehicleTypeSection({
    required this.vehicleType,
    required this.allVehicleTypes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalSlots = vehicleType.totalSlots;
    final availableSlots = vehicleType.availableSlots;
    final progress = totalSlots == 0 ? 0.0 : availableSlots / totalSlots;
    final isConnected =
        ref.watch(connectivityStatusProvider).valueOrNull ?? true;

    return ModernCard(
      enableScaleTap: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                vehicleType.type == 'car'
                    ? Icons.directions_car_rounded
                    : Icons.two_wheeler_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _vehicleTypeTitle(vehicleType.type),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: StatusChip.slots(
                  available: availableSlots,
                  total: totalSlots,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSlotProgressBar(value: progress),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Giá: ${_formatPrice(vehicleType)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          QuickActionButton(
            icon: Icons.login_rounded,
            label: 'Check In',
            onPressed: isConnected
                ? () => _openScreen(
                      context,
                      CheckInScreen(
                        vehicleType: vehicleType,
                        siblingVehicleTypes: allVehicleTypes,
                      ),
                    )
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          QuickActionButton(
            icon: Icons.logout_rounded,
            label: 'Check Out',
            backgroundColor: AppColors.danger,
            onPressed: isConnected
                ? () => _openScreen(
                      context,
                      CheckOutScreen(vehicleType: vehicleType),
                    )
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          QuickActionButton(
            outlined: true,
            icon: Icons.tune_rounded,
            label: 'Điều chỉnh thủ công',
            onPressed: isConnected
                ? () => _openScreen(
                      context,
                      ManualAdjustScreen(vehicleType: vehicleType),
                    )
                : null,
          ),
        ],
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }

  String _vehicleTypeTitle(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }

  String _formatPrice(VehicleTypeEntity vehicleType) {
    final amount = NumberFormat.decimalPattern('vi_VN').format(
      vehicleType.priceAmount,
    );
    final unit = vehicleType.isPerDay ? 'ngày' : 'lượt';
    return '$amountđ / $unit';
  }
}

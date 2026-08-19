import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/auth_providers.dart';
import 'package:parking_link/core/di/owner_providers.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/owner/presentation/providers/owner_ui_providers.dart';
import 'package:parking_link/features/owner/presentation/screens/add_staff_screen.dart';
import 'package:parking_link/features/owner/presentation/screens/create_lot_screen.dart';
import 'package:parking_link/features/owner/presentation/screens/edit_lot_screen.dart';
import 'package:parking_link/features/owner/presentation/widgets/owner_error_message.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  final StaffProfileEntity ownerProfile;

  const OwnerDashboardScreen({
    super.key,
    required this.ownerProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotId = ownerProfile.lotId;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Bãi xe'),
                Tab(text: 'Nhân viên'),
              ],
            ),
          ),
          body: lotId.isEmpty
              ? _OwnerNoLotState(ownerProfile: ownerProfile)
              : TabBarView(
                  children: [
                    _LotTab(
                      lotId: lotId,
                      ownerUid: ownerProfile.uid,
                    ),
                    _StaffManagementTab(lotId: lotId),
                  ],
                )),
    );
  }
}

class _OwnerNoLotState extends ConsumerStatefulWidget {
  final StaffProfileEntity ownerProfile;

  const _OwnerNoLotState({required this.ownerProfile});

  @override
  ConsumerState<_OwnerNoLotState> createState() => _OwnerNoLotStateState();
}

class _OwnerNoLotStateState extends ConsumerState<_OwnerNoLotState> {
  bool _isRouting = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.store_mall_directory_rounded, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Tài khoản owner chưa được gán bãi xe.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isRouting ? null : _openCreateLot,
              icon: _isRouting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_business_rounded),
              label: const Text('➕ Tạo bãi xe đầu tiên'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateLot() async {
    setState(() => _isRouting = true);
    try {
      final createdLotId = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => CreateLotScreen(ownerUid: widget.ownerProfile.uid),
        ),
      );
      if (!mounted || createdLotId == null || createdLotId.isEmpty) return;

      final refreshedProfile = StaffProfileEntity(
        uid: widget.ownerProfile.uid,
        name: widget.ownerProfile.name,
        email: widget.ownerProfile.email,
        role: widget.ownerProfile.role,
        lotId: createdLotId,
        isActive: widget.ownerProfile.isActive,
        createdAt: widget.ownerProfile.createdAt,
        updatedAt: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo bãi xe thành công ✅')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OwnerDashboardScreen(ownerProfile: refreshedProfile),
        ),
      );
    } finally {
      if (mounted) setState(() => _isRouting = false);
    }
  }
}

class _LotTab extends ConsumerWidget {
  final String lotId;
  final String ownerUid;

  const _LotTab({
    required this.lotId,
    required this.ownerUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotAsync = ref.watch(ownerLotStreamProvider(lotId));

    return lotAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => OwnerErrorMessage(message: error.toString()),
      data: (lot) {
        final vehicleTypesAsync = ref.watch(ownerVehicleTypesProvider(lot.id));

        return vehicleTypesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => OwnerErrorMessage(message: error.toString()),
          data: (vehicleTypes) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(ownerLotStreamProvider(lotId));
                ref.invalidate(ownerVehicleTypesProvider(lotId));
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _LotSummaryCard(lot: lot),
                  const SizedBox(height: 16),
                  _VehicleTypesCard(vehicleTypes: vehicleTypes),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () async {
                      final saved = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => EditLotScreen(
                            lot: lot,
                            vehicleTypes: vehicleTypes,
                            ownerUid: ownerUid,
                          ),
                        ),
                      );
                      if (saved == true) {
                        ref.invalidate(ownerLotStreamProvider(lotId));
                        ref.invalidate(ownerVehicleTypesProvider(lotId));
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Chỉnh sửa'),
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

class _LotSummaryCard extends StatelessWidget {
  final ParkingLotEntity lot;

  const _LotSummaryCard({required this.lot});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lot.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(lot.address)),
              ],
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(lot.status),
              avatar: Icon(
                lot.isOpen ? Icons.check_circle : Icons.cancel,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypesCard extends StatelessWidget {
  final List<VehicleTypeEntity> vehicleTypes;

  const _VehicleTypesCard({required this.vehicleTypes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loại xe',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (vehicleTypes.isEmpty)
              const Text('Chưa có cấu hình loại xe.')
            else
              ...vehicleTypes.map(
                (vehicleType) => _VehicleTypeTile(vehicleType: vehicleType),
              ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeTile extends StatelessWidget {
  final VehicleTypeEntity vehicleType;

  const _VehicleTypeTile({required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicleType.type,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Tổng slot: ${vehicleType.totalSlots} / '
            'Còn trống: ${vehicleType.availableSlots}',
          ),
          Text(
            'Giá: ${vehicleType.pricingModel} - '
            '${vehicleType.priceAmount} VND',
          ),
        ],
      ),
    );
  }
}

class _StaffManagementTab extends ConsumerWidget {
  final String lotId;

  const _StaffManagementTab({required this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffListAsync = ref.watch(ownerStaffListProvider(lotId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final added = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => AddStaffScreen(lotId: lotId),
                  ),
                );
                if (added == true) {
                  ref.invalidate(ownerStaffListProvider(lotId));
                }
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Thêm nhân viên'),
            ),
          ),
        ),
        Expanded(
          child: staffListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => OwnerErrorMessage(message: error.toString()),
            data: (staffList) {
              if (staffList.isEmpty) {
                return const Center(
                  child: Text('Chưa có nhân viên thuộc bãi xe này.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final staff = staffList[index];
                  return _StaffListTile(staff: staff);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: staffList.length,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StaffListTile extends ConsumerStatefulWidget {
  final StaffProfileEntity staff;

  const _StaffListTile({required this.staff});

  @override
  ConsumerState<_StaffListTile> createState() => _StaffListTileState();
}

class _StaffListTileState extends ConsumerState<_StaffListTile> {
  bool _isUpdating = false;

  Future<void> _confirmAndToggle(bool nextIsActive) async {
    final staff = widget.staff;
    final actionText = nextIsActive ? 'mở khoá' : 'khoá';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận $actionText'),
          content: Text('Bạn có chắc muốn $actionText ${staff.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      await ref.read(toggleStaffActiveUseCaseProvider)(
        uid: staff.uid,
        isActive: nextIsActive,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final staff = widget.staff;

    return Card(
      child: ListTile(
        title: Text(staff.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(staff.email),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(staff.role),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(staff.isActive ? 'Active' : 'Locked'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        trailing: Switch(
          value: staff.isActive,
          onChanged: _isUpdating ? null : _confirmAndToggle,
        ),
        isThreeLine: true,
      ),
    );
  }
}

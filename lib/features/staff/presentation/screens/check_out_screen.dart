import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/di/staff_providers.dart';
import 'package:psgy/core/error/app_error_handler.dart';
import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/staff/presentation/widgets/staff_error_message.dart';
import 'package:psgy/shared/widgets/empty_state.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  final VehicleTypeEntity vehicleType;

  const CheckOutScreen({
    super.key,
    required this.vehicleType,
  });

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  String? _loadingSessionId;
  Object? _error;

  @override
  Widget build(BuildContext context) {
    final vehicleTypeLabel = _vehicleTypeLabel(widget.vehicleType.type);
    final sessionsAsync =
        ref.watch(activeSessionsProvider(widget.vehicleType.type));
    final profileAsync = ref.watch(staffProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Check Out - $vehicleTypeLabel')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => StaffErrorMessage(
          error: error,
          onRetry: () => ref.invalidate(staffProfileProvider),
        ),
        data: (profile) {
          return sessionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => StaffErrorMessage(
              error: error,
              onRetry: () => ref.invalidate(
                activeSessionsProvider(widget.vehicleType.type),
              ),
            ),
            data: (sessions) {
              if (sessions.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.local_parking_outlined,
                  title: 'Không có xe đang đỗ',
                  subtitle: 'Danh sách trống cho loại xe này.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length + (_error == null ? 0 : 1),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (_error != null && index == 0) {
                    return StaffErrorMessage(
                      error: _error!,
                      onRetry: () => setState(() => _error = null),
                    );
                  }

                  final sessionIndex = _error == null ? index : index - 1;
                  final session = sessions[sessionIndex];
                  return _SessionCard(
                    session: session,
                    isLoading: _loadingSessionId == session.id,
                    onCheckOut: () => _confirmAndCheckOut(
                      lotId: profile.lotId,
                      staffId: profile.uid,
                      session: session,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmAndCheckOut({
    required String lotId,
    required String staffId,
    required ParkingSessionEntity session,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận Check Out'),
        content: Text('Check out xe ${session.vehiclePlate}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _loadingSessionId = session.id;
      _error = null;
    });

    try {
      final checkOutUseCase = ref.read(staffCheckOutUseCaseProvider);
      await appErrorHandler.runWithRetry(
        action: () => checkOutUseCase(
          lotId: lotId,
          sessionId: session.id,
          vehicleType: widget.vehicleType.type,
          staffId: staffId,
        ),
        contextLabel: 'staff_check_out',
      );

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check out thành công')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      appErrorHandler.hapticError();
      setState(() => _error = error);
    } finally {
      if (mounted) {
        setState(() => _loadingSessionId = null);
      }
    }
  }

  String _vehicleTypeLabel(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }
}

class _SessionCard extends StatelessWidget {
  final ParkingSessionEntity session;
  final bool isLoading;
  final VoidCallback onCheckOut;

  const _SessionCard({
    required this.session,
    required this.isLoading,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    final checkedInAt =
        DateFormat('HH:mm dd/MM/yyyy').format(session.checkedInAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.vehiclePlate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Giờ vào: $checkedInAt'),
            const SizedBox(height: 4),
            Text('Thời gian đỗ: ${_formatDuration(session.parkingDuration)}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: isLoading ? null : onCheckOut,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);

    if (hours == 0) {
      return '$minutes phút';
    }
    return '$hours giờ $minutes phút';
  }
}


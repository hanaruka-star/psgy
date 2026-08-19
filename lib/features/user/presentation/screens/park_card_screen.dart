import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parking_link/core/di/parking_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/core/utils/currency_formatter.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/pricing/pricing_strategy_factory.dart';
import 'package:parking_link/features/user/presentation/screens/checkout_qr_screen.dart';

/// Realtime stream of a single parking session via [WatchParkingSessionUseCase].
final parkCardSessionProvider =
    StreamProvider.autoDispose.family<ParkingSessionEntity?, String>(
  (ref, sessionId) =>
      ref.watch(watchParkingSessionUseCaseProvider).call(sessionId),
);

/// Lot display name via [WatchLotUseCase] (realtime; empty when [lotId] blank).
final parkCardLotNameProvider = StreamProvider.autoDispose.family<String, String>(
  (ref, lotId) {
    if (lotId.isEmpty) return Stream.value('');
    return ref
        .watch(watchLotUseCaseProvider)
        .call(lotId)
        .map((lot) => lot.name);
  },
);

class ParkCardScreen extends ConsumerWidget {
  const ParkCardScreen({
    super.key,
    required this.sessionId,
    required this.lotId,
  });

  final String sessionId;
  final String lotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(parkCardSessionProvider(sessionId));
    final lotNameAsync = ref.watch(parkCardLotNameProvider(lotId));
    final vehicleTypesAsync = ref.watch(lotVehicleTypesProvider(lotId));

    return Scaffold(
      appBar: AppBar(title: const Text('Thẻ xe')),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(message: error.toString()),
        data: (session) {
          if (session == null) {
            return const _ErrorView(message: 'Phiên gửi xe không tồn tại');
          }
          if (session.status == 'completed') {
            return _CompletedView();
          }

          final lotName = lotNameAsync.maybeWhen(
            data: (name) => name,
            orElse: () => '',
          );
          final vehicleTypes = vehicleTypesAsync.valueOrNull;
          return _ActiveCard(
            session: session,
            lotName: lotName,
            vehicleTypes: vehicleTypes,
            onCheckout: () => _handleCheckout(
              context,
              session: session,
              lotName: lotName,
              vehicleTypes: vehicleTypes,
            ),
            onPhotoOption: () => _showPhotoOption(context),
          );
        },
      ),
    );
  }

  VehicleTypeEntity? _vehicleTypeFor(
    List<VehicleTypeEntity>? vehicleTypes,
    String type,
  ) {
    if (vehicleTypes == null) return null;
    for (final vt in vehicleTypes) {
      if (vt.type == type) return vt;
    }
    return null;
  }

  int _estimateFee(
    ParkingSessionEntity session,
    List<VehicleTypeEntity>? vehicleTypes,
  ) {
    final vt = _vehicleTypeFor(vehicleTypes, session.vehicleType);
    if (vt == null) return 0;
    return pricingStrategyFor(vt).calculate(
      session: session,
      vehicleType: vt,
      now: DateTime.now(),
    );
  }

  Future<void> _handleCheckout(
    BuildContext context, {
    required ParkingSessionEntity session,
    required String lotName,
    required List<VehicleTypeEntity>? vehicleTypes,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để rời bãi')),
      );
      return;
    }

    final fee = _estimateFee(session, vehicleTypes);

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CheckoutQrScreen(
          sessionId: sessionId,
          userId: userId,
          estimatedFee: fee,
          plate: session.vehiclePlate,
          lotName: lotName,
        ),
      ),
    );
  }

  void _showPhotoOption(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng chụp ảnh vị trí đậu sắp ra mắt')),
    );
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard({
    required this.session,
    required this.lotName,
    required this.vehicleTypes,
    required this.onCheckout,
    required this.onPhotoOption,
  });

  final ParkingSessionEntity session;
  final String lotName;
  final List<VehicleTypeEntity>? vehicleTypes;
  final VoidCallback onCheckout;
  final VoidCallback onPhotoOption;

  int get _estimatedFee {
    for (final vt in vehicleTypes ?? const <VehicleTypeEntity>[]) {
      if (vt.type == session.vehicleType) {
        return pricingStrategyFor(vt).calculate(
          session: session,
          vehicleType: vt,
          now: DateTime.now(),
        );
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final checkInTime =
        DateFormat('HH:mm dd/MM').format(session.checkedInAt);
    final duration = DateTime.now().difference(session.checkedInAt);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    session.vehicleType == 'moto'
                        ? Icons.two_wheeler
                        : Icons.directions_car,
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lotName.isEmpty ? 'Bãi đỗ xe' : lotName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Đang gửi xe',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white30, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Biển số',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        session.vehiclePlate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Vào lúc',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        checkInTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Đã gửi: ${_formatDuration(duration)}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phí ước tính',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  Text(
                    formatVnd(_estimatedFee),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '(Phí có thể thay đổi khi check-out)',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
              Icon(Icons.info_outline, color: Colors.grey.shade500),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onCheckout,
            icon: const Icon(Icons.exit_to_app),
            label: const Text('🚗 Tạo mã rời bãi'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onPhotoOption,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Chụp ảnh vị trí đậu'),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final hours = safe.inHours;
    final minutes = safe.inMinutes.remainder(60);
    if (hours == 0) return '$minutes phút';
    return '$hours giờ $minutes phút';
  }
}

class _CompletedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Xe đã rời bãi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Về bản đồ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Về bản đồ'),
            ),
          ],
        ),
      ),
    );
  }
}

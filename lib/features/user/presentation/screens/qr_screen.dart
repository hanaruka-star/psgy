import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:parking_link/features/user/domain/entities/user_vehicle.dart';
import 'package:parking_link/features/user/presentation/providers/qr_token_provider.dart';
import 'package:parking_link/features/user/presentation/screens/park_card_screen.dart';

class QrScreen extends ConsumerStatefulWidget {
  const QrScreen({super.key, required this.vehicle});

  final UserVehicle vehicle;

  @override
  ConsumerState<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends ConsumerState<QrScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(qrTokenProvider.notifier).createToken(widget.vehicle);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<QrTokenState>>(qrTokenProvider, (previous, next) {
      final qrState = next.value;
      if (qrState?.isCheckedIn == true &&
          qrState?.token?.sessionId != null &&
          mounted) {
        final token = qrState!.token!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ParkCardScreen(
              sessionId: token.sessionId!,
              lotId: token.lotId ?? '',
            ),
          ),
        );
      }
    });

    final qrAsync = ref.watch(qrTokenProvider);
    final qrState = qrAsync.value ?? const QrTokenState();
    final token = qrState.token;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mã QR gửi xe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            await ref.read(qrTokenProvider.notifier).cancelToken();
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: qrAsync.isLoading && token == null
            ? const CircularProgressIndicator()
            : _buildBody(context, qrState),
      ),
    );
  }

  Widget _buildBody(BuildContext context, QrTokenState qrState) {
    if (qrState.error != null && qrState.token == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              qrState.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(qrTokenProvider.notifier).createToken(widget.vehicle),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final token = qrState.token;
    if (token == null) {
      return const CircularProgressIndicator();
    }

    final remaining = qrState.remainingTime;
    final remainingSeconds = remaining.inSeconds;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.vehicle.photoUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.directions_car,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.vehicle.plate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: 260,
            height: 260,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: token.tokenId,
              version: QrVersions.auto,
              size: 240,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          if (qrState.isExpired)
            Column(
              children: [
                const Text(
                  'Mã đã hết hạn',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref
                      .read(qrTokenProvider.notifier)
                      .refreshToken(widget.vehicle),
                  child: const Text('🔄 Tạo mã mới'),
                ),
              ],
            )
          else
            Text(
              '⏱ ${remaining.inMinutes}:'
              '${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: remainingSeconds < 30 ? Colors.red : Colors.black87,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Đưa mã này cho nhân viên quét',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () async {
              await ref.read(qrTokenProvider.notifier).cancelToken();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Huỷ'),
          ),
        ],
      ),
    );
  }
}

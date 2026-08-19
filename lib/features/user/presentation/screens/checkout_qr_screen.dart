import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:psgy/core/utils/currency_formatter.dart';
import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';
import 'package:psgy/features/user/presentation/providers/checkout_qr_token_provider.dart';
import 'package:psgy/features/user/presentation/screens/checkout_success_screen.dart';

class CheckoutQrScreen extends ConsumerStatefulWidget {
  const CheckoutQrScreen({
    super.key,
    required this.sessionId,
    required this.userId,
    required this.estimatedFee,
    required this.plate,
    required this.lotName,
  });

  final String sessionId;
  final String userId;
  final int estimatedFee;
  final String plate;
  final String lotName;

  @override
  ConsumerState<CheckoutQrScreen> createState() => _CheckoutQrScreenState();
}

class _CheckoutQrScreenState extends ConsumerState<CheckoutQrScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkoutQrTokenProvider.notifier).createToken(
            sessionId: widget.sessionId,
            userId: widget.userId,
            estimatedFee: widget.estimatedFee,
          );
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatMmSs(Duration d) {
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleClose() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Huỷ check-out?'),
        content: const Text('Bạn sẽ ở lại bãi và có thể tạo mã sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(checkoutQrTokenProvider.notifier).cancelToken();
    if (mounted) Navigator.of(context).pop();
  }

  void _showCompletionScreen(CheckoutQrToken token) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CheckoutSuccessScreen(
          lotName: widget.lotName,
          plate: widget.plate,
          estimatedFee: widget.estimatedFee,
          checkOutStaffId: token.checkOutStaffId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CheckoutQrTokenState>>(
      checkoutQrTokenProvider,
      (_, next) {
        final value = next.value;
        if (value != null && value.isCompleted && value.token != null) {
          _showCompletionScreen(value.token!);
        }
      },
    );

    final asyncState = ref.watch(checkoutQrTokenProvider);
    final state = asyncState.value ?? const CheckoutQrTokenState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mã rời bãi'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _handleClose,
        ),
      ),
      body: _buildBody(asyncState, state),
    );
  }

  Widget _buildBody(
    AsyncValue<CheckoutQrTokenState> asyncState,
    CheckoutQrTokenState state,
  ) {
    if (asyncState.isLoading || state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                state.error!.replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () =>
                    ref.read(checkoutQrTokenProvider.notifier).createToken(
                          sessionId: widget.sessionId,
                          userId: widget.userId,
                          estimatedFee: widget.estimatedFee,
                        ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final token = state.token;
    if (token == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.plate,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text('·', style: TextStyle(color: Colors.grey.shade500)),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.lotName,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
            ),
            child: Center(
              child: QrImageView(
                data: token.tokenId,
                version: QrVersions.auto,
                size: 240,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCountdown(state),
          const SizedBox(height: 24),
          _buildFeeCard(),
          const SizedBox(height: 24),
          Text(
            'Đưa mã QR này cho nhân viên\ntại barrier ra',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _handleClose,
            child: const Text('Huỷ'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(CheckoutQrTokenState state) {
    if (state.isExpired || state.remainingTime <= Duration.zero) {
      return Column(
        children: [
          const Text(
            'Mã đã hết hạn',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () =>
                ref.read(checkoutQrTokenProvider.notifier).refreshToken(
                      sessionId: widget.sessionId,
                      userId: widget.userId,
                      estimatedFee: widget.estimatedFee,
                    ),
            child: const Text('🔄 Tạo mã mới'),
          ),
        ],
      );
    }

    final isUrgent = state.remainingTime.inSeconds < 60;
    return Text(
      '⏱ ${_formatMmSs(state.remainingTime)}',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isUrgent ? Colors.red : Colors.black87,
      ),
    );
  }

  Widget _buildFeeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: Colors.amber.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phí ước tính',
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                ),
                Text(
                  formatVnd(widget.estimatedFee),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Trả tiền mặt cho nhân viên',
                  style: TextStyle(color: Colors.amber.shade800, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

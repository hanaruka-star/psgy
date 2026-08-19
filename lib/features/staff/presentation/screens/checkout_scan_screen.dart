import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:psgy/core/di/staff_providers.dart';
import 'package:psgy/core/utils/currency_formatter.dart';
import 'package:psgy/features/staff/domain/usecases/check_in_out/scan_qr_and_check_out_usecase.dart';

class CheckoutScanScreen extends ConsumerStatefulWidget {
  const CheckoutScanScreen({
    super.key,
    required this.vehicleType,
  });

  final String vehicleType;

  @override
  ConsumerState<CheckoutScanScreen> createState() => _CheckoutScanScreenState();
}

class _CheckoutScanScreenState extends ConsumerState<CheckoutScanScreen> {
  bool _isProcessing = false;
  String? _error;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('expired')) return 'Mã QR đã hết hạn';
    if (msg.contains('used')) return 'Mã QR đã được dùng';
    if (msg.contains('not-found') || msg.contains('not found')) {
      return 'Mã QR không hợp lệ';
    }
    if (msg.contains('lotid mismatch') || msg.contains('lot')) {
      return 'Mã QR không thuộc bãi này';
    }
    if (msg.contains('session') && msg.contains('active')) {
      return 'Phiên đã kết thúc';
    }
    return 'Lỗi: ${e.toString().replaceFirst('Exception: ', '')}';
  }

  Future<void> _handleScan(String tokenId) async {
    if (_isProcessing) return;

    final profile = ref.read(staffProfileProvider).valueOrNull;
    if (profile == null || profile.lotId.isEmpty) {
      setState(() => _error = 'Chưa có thông tin bãi xe');
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final result = await ref.read(scanQrAndCheckOutUseCaseProvider).call(
            tokenId: tokenId.trim(),
            lotId: profile.lotId,
            staffId: profile.uid,
            vehicleType: widget.vehicleType,
          );
      await _controller.stop();
      if (!mounted) return;
      _showSuccessSheet(result);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _mapError(e);
        _isProcessing = false;
      });
    }
  }

  void _showSuccessSheet(ScanQrAndCheckOutResult result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CheckoutSuccessSheet(result: result),
    ).then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã rời bãi'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_isProcessing) return;
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              final raw = barcodes.first.rawValue;
              if (raw != null && raw.isNotEmpty) {
                _handleScan(raw);
              }
            },
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF8B5CF6), width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black54,
                child: const Text(
                  'Đưa mã QR rời bãi của khách vào khung',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          if (_error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _error = null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Đang xử lý...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CheckoutSuccessSheet extends StatelessWidget {
  const _CheckoutSuccessSheet({required this.result});

  final ScanQrAndCheckOutResult result;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 64),
            const SizedBox(height: 12),
            Text(
              '✅ Check-out thành công',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _row('Biển số', result.plate, bold: true),
                  const Divider(),
                  _row('Bãi', result.lotName),
                  const Divider(),
                  _row('Thời gian đỗ', _formatDuration(result.parkingDuration)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined,
                      color: Colors.amber.shade700, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thu tiền mặt',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          formatVnd(result.estimatedFee),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Xong'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '$h giờ $m phút';
    return '$m phút';
  }
}

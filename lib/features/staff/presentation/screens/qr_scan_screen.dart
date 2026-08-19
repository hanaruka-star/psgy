import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parking_link/core/di/staff_providers.dart';
import 'package:parking_link/features/staff/domain/entities/scan_qr_result.dart';

class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({
    super.key,
    required this.vehicleType,
  });

  final String vehicleType;

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  bool _isProcessing = false;
  String? _error;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  String _mapError(Object e) {
    final message = e.toString().toLowerCase();
    if (message.contains('expired')) return 'Mã QR đã hết hạn';
    if (message.contains('used')) return 'Mã QR đã được dùng';
    if (message.contains('not-found') || message.contains('không hợp lệ')) {
      return 'Mã QR không hợp lệ';
    }
    return 'Lỗi không xác định, thử lại';
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
      final result = await ref.read(scanQrAndCheckInUseCaseProvider).call(
            tokenId: tokenId.trim(),
            lotId: profile.lotId,
            staffId: profile.uid,
            vehicleType: widget.vehicleType,
          );
      if (!mounted) return;
      await _scannerController.stop();
      _showSuccessSheet(result);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _mapError(e);
        _isProcessing = false;
      });
    }
  }

  void _showSuccessSheet(ScanQrResult result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    result.vehiclePhotoUrl,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.directions_car, size: 80),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  result.plate,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(result.userPhone),
                const SizedBox(height: 16),
                const Text(
                  '✅ Check-in thành công!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Xong'),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _scannerController,
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
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Text(
              'Đưa mã QR của khách vào khung',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [Shadow(blurRadius: 8, color: Colors.black)],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  title: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _error = null),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

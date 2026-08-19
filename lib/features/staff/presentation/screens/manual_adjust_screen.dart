import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/core/di/staff_providers.dart';

class ManualAdjustScreen extends ConsumerStatefulWidget {
  final VehicleTypeEntity vehicleType;

  const ManualAdjustScreen({
    super.key,
    required this.vehicleType,
  });

  @override
  ConsumerState<ManualAdjustScreen> createState() => _ManualAdjustScreenState();
}

class _ManualAdjustScreenState extends ConsumerState<ManualAdjustScreen> {
  static const int _maxDelta = 20;

  final _reasonController = TextEditingController();
  int _pendingDelta = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(staffProfileProvider);
    final liveVehicleTypeAsync =
        ref.watch(staffVehicleTypeProvider(widget.vehicleType.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Điều chỉnh - ${_vehicleTypeLabel(widget.vehicleType.type)}'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorMessage(message: error.toString()),
        data: (profile) {
          return liveVehicleTypeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _ErrorMessage(message: error.toString()),
            data: (vehicleType) => _buildContent(
              context,
              lotId: profile.lotId,
              staffId: profile.uid,
              vehicleType: vehicleType,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required String lotId,
    required String staffId,
    required VehicleTypeEntity vehicleType,
  }) {
    final available = vehicleType.availableSlots;
    final total = vehicleType.totalSlots;
    final label = _vehicleTypeLabel(vehicleType.type);
    final nextAvailable = (available + _pendingDelta).clamp(0, total);

    final canDecrement =
        !_isSubmitting && _pendingDelta > -available;
    final canIncrement = !_isSubmitting && _pendingDelta < _maxDelta;
    final canAct = _pendingDelta != 0 && !_isSubmitting;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Top — vehicle type info
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Hiện tại: $available / $total',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // Middle — counter row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_rounded),
              iconSize: 40,
              onPressed: canDecrement ? () => _decrement(available) : null,
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(width: 24),
            _buildCounterBox(),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.add_rounded),
              iconSize: 40,
              onPressed: canIncrement ? _increment : null,
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                foregroundColor: Colors.green.shade700,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Preview row — only when there is a pending change
        if (_pendingDelta != 0) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.preview_outlined,
                    size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sau xác nhận: $available → $nextAvailable',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Reason input — required when there is a pending change
        TextField(
          controller: _reasonController,
          enabled: !_isSubmitting,
          decoration: const InputDecoration(
            labelText: 'Lý do',
            hintText: 'Nhập lý do điều chỉnh (bắt buộc)',
            border: OutlineInputBorder(),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 16),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: canAct ? _reset : null,
                child: const Text('Huỷ'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: canAct
                    ? () => _submit(
                          lotId: lotId,
                          staffId: staffId,
                          vehicleType: vehicleType,
                        )
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _pendingDelta == 0
                            ? 'Xác nhận'
                            : 'Xác nhận (${_pendingDelta > 0 ? "+" : ""}$_pendingDelta)',
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterBox() {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    if (_pendingDelta == 0) {
      bgColor = Colors.grey.shade100;
      borderColor = Colors.grey.shade300;
      textColor = Colors.grey;
    } else if (_pendingDelta > 0) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green;
      textColor = Colors.green.shade700;
    } else {
      bgColor = Colors.orange.shade50;
      borderColor = Colors.orange;
      textColor = Colors.orange.shade700;
    }

    final displayValue = _pendingDelta == 0
        ? '0'
        : (_pendingDelta > 0 ? '+$_pendingDelta' : '$_pendingDelta');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 140,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: _pendingDelta == 0
            ? Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Human-friendly label — the prominent text
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _pendingDelta > 0
                          ? '$_pendingDelta xe ra'
                          : '${_pendingDelta.abs()} xe vào',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Numeric delta — secondary
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _increment() {
    setState(() {
      if (_pendingDelta < _maxDelta) _pendingDelta++;
    });
  }

  void _decrement(int available) {
    setState(() {
      if (_pendingDelta > -available) _pendingDelta--;
    });
  }

  void _reset() {
    setState(() => _pendingDelta = 0);
  }

  Future<void> _submit({
    required String lotId,
    required String staffId,
    required VehicleTypeEntity vehicleType,
  }) async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập lý do')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final delta = _pendingDelta;
    final absCount = delta.abs();
    final sign = delta > 0 ? 1 : -1;
    int succeeded = 0;

    try {
      final useCase = ref.read(staffManualAdjustUseCaseProvider);
      for (var i = 0; i < absCount; i++) {
        await useCase(
          lotId: lotId,
          vehicleType: vehicleType.type,
          delta: sign,
          staffId: staffId,
          reason: reason,
        );
        succeeded++;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Đã điều chỉnh ${delta > 0 ? "+" : ""}$delta thành công',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            succeeded == 0
                ? '❌ Lỗi: $message'
                : '⚠️ Đã điều chỉnh $succeeded/$absCount, lỗi: $message',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() {
        _pendingDelta = (absCount - succeeded) * sign;
        _isSubmitting = false;
      });
    }
  }

  String _vehicleTypeLabel(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message.replaceFirst('Exception: ', ''),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

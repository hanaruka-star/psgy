import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/staff_providers.dart';
import 'package:parking_link/core/error/app_error_handler.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/staff/presentation/widgets/staff_error_message.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  final VehicleTypeEntity vehicleType;
  final List<VehicleTypeEntity>? siblingVehicleTypes;

  const CheckInScreen({
    super.key,
    required this.vehicleType,
    this.siblingVehicleTypes,
  });

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  static final RegExp _plateAllowedRegex = RegExp(r'^[A-Z0-9\-]{6,12}$');
  static final RegExp _plateCommonVnRegex = RegExp(r'^[0-9]{2}[A-Z][A-Z0-9\-]{3,9}$');
  static const String _invalidPlateMessage =
      'Biển số không hợp lệ. VD: 51A-12345 hoặc 51A123.45';

  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  bool _isLoading = false;
  Object? _error;
  int? _optimisticAvailable;
  String? _plateWarning;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  int get _displayAvailable =>
      _optimisticAvailable ?? widget.vehicleType.availableSlots;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(staffProfileProvider);
    final vehicleTypeLabel = _vehicleTypeLabel(widget.vehicleType.type);

    return Scaffold(
      appBar: AppBar(title: Text('Check In - $vehicleTypeLabel')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => StaffErrorMessage(
          error: error,
          onRetry: () => ref.invalidate(staffProfileProvider),
        ),
        data: (profile) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _VehicleTypeInfoCard(
                vehicleTypeLabel: vehicleTypeLabel,
                availableSlots: _displayAvailable,
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _plateController,
                  enabled: !_isLoading,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: const [_UpperCaseTextFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Biển số xe',
                    hintText: '51A-12345',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.confirmation_number_outlined),
                  ),
                  validator: _validatePlate,
                  onChanged: _updatePlateWarning,
                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _submit(lotId: profile.lotId, staffId: profile.uid);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (_plateWarning != null) ...[
                Text(
                  _plateWarning!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(height: 12),
              ],
              if (_error != null) ...[
                StaffErrorMessage(
                  error: _error!,
                  onRetry: () => _submit(
                    lotId: profile.lotId,
                    staffId: profile.uid,
                  ),
                  onSecondary: _error is SlotUnavailableException
                      ? () => _showAlternativeOptions(profile.lotId)
                      : null,
                ),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: _isLoading || _displayAvailable <= 0
                    ? null
                    : () => _submit(lotId: profile.lotId, staffId: profile.uid),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check In'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAlternativeOptions(String lotId) async {
    final siblings = widget.siblingVehicleTypes ?? const [];
    final alternatives = siblings
        .where(
          (v) =>
              v.type != widget.vehicleType.type && v.availableSlots > 0,
        )
        .toList();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Loại xe này đã đầy',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                alternatives.isEmpty
                    ? 'Hiện không còn loại xe nào trống. Làm mới dữ liệu hoặc liên hệ quản lý.'
                    : 'Bạn có thể check-in loại xe còn chỗ sau:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (alternatives.isEmpty)
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.invalidate(staffVehicleTypesProvider(lotId));
                  },
                  child: const Text('Làm mới dữ liệu'),
                )
              else
                ...alternatives.map(
                  (alt) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => CheckInScreen(
                              vehicleType: alt,
                              siblingVehicleTypes: siblings,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '${_vehicleTypeLabel(alt.type)} • còn ${alt.availableSlots} chỗ',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String? _validatePlate(String? value) {
    final normalized = _normalizePlate(value);
    if (normalized.isEmpty) {
      return 'Vui lòng nhập biển số xe';
    }
    if (!_plateAllowedRegex.hasMatch(normalized)) {
      return _invalidPlateMessage;
    }
    return null;
  }

  void _updatePlateWarning(String value) {
    final normalized = _normalizePlate(value);
    final warning = _buildPlateWarning(normalized);
    if (warning == _plateWarning) return;
    setState(() => _plateWarning = warning);
  }

  String _normalizePlate(String? raw) => (raw ?? '').trim().toUpperCase();

  String? _buildPlateWarning(String normalizedPlate) {
    if (normalizedPlate.isEmpty) return null;
    if (!_plateAllowedRegex.hasMatch(normalizedPlate)) return null;
    if (_plateCommonVnRegex.hasMatch(normalizedPlate)) return null;
    return 'Lưu ý: định dạng biển số lạ, vui lòng kiểm tra lại trước khi xác nhận.';
  }

  Future<void> _submit({
    required String lotId,
    required String staffId,
  }) async {
    if (!_formKey.currentState!.validate()) return;

    final vehiclePlate = _normalizePlate(_plateController.text);
    final warning = _buildPlateWarning(vehiclePlate);
    if (warning != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cảnh báo: biển số có định dạng lạ, vẫn cho phép tiếp tục.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận Check In'),
        content: Text('Check in xe $vehiclePlate?'),
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

    final previousAvailable = _displayAvailable;
    setState(() {
      _isLoading = true;
      _error = null;
      _optimisticAvailable = (previousAvailable - 1).clamp(0, 9999);
    });

    try {
      final checkInUseCase = ref.read(staffCheckInUseCaseProvider);
      await appErrorHandler.runWithRetry(
        action: () => checkInUseCase(
          lotId: lotId,
          vehicleType: widget.vehicleType.type,
          vehiclePlate: vehiclePlate,
          staffId: staffId,
        ),
        contextLabel: 'staff_check_in',
      );

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã check in xe $vehiclePlate')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      appErrorHandler.hapticError();
      setState(() {
        _error = error;
        _optimisticAvailable = previousAvailable;
      });

      if (error is SlotUnavailableException ||
          mapFirebaseException(error) is SlotUnavailableException) {
        await _showAlternativeOptions(lotId);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _vehicleTypeLabel(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }
}

class _VehicleTypeInfoCard extends StatelessWidget {
  final String vehicleTypeLabel;
  final int availableSlots;

  const _VehicleTypeInfoCard({
    required this.vehicleTypeLabel,
    required this.availableSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicleTypeLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              availableSlots > 0
                  ? 'Còn $availableSlots slot'
                  : 'Đã hết chỗ — thử loại xe khác',
            ),
          ],
        ),
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  const _UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

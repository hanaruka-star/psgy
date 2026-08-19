import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/features/owner/domain/entities/lot_status.dart';
import 'package:parking_link/features/owner/domain/entities/owner_vehicle_type_edit.dart';
import 'package:parking_link/features/owner/presentation/models/vehicle_type_edit_form_model.dart';
import 'package:parking_link/features/owner/presentation/providers/owner_ui_providers.dart';
import 'package:parking_link/features/owner/presentation/widgets/owner_error_message.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class EditLotScreen extends ConsumerStatefulWidget {
  final ParkingLotEntity lot;
  final List<VehicleTypeEntity> vehicleTypes;
  final String ownerUid;

  const EditLotScreen({
    super.key,
    required this.lot,
    required this.vehicleTypes,
    required this.ownerUid,
  });

  @override
  ConsumerState<EditLotScreen> createState() => _EditLotScreenState();
}

class _EditLotScreenState extends ConsumerState<EditLotScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isOpen;
  late final Map<String, VehicleTypeEditFormModel> _vehicleTypeStates;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.lot.isOpen;
    _vehicleTypeStates = {
      for (final vehicleType in widget.vehicleTypes)
        vehicleType.id: VehicleTypeEditFormModel(vehicleType),
    };
  }

  @override
  void dispose() {
    for (final state in _vehicleTypeStates.values) {
      state.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    try {
      final nextStatus = _isOpen ? LotStatus.open : LotStatus.closed;
      final hasStatusChanged = nextStatus != widget.lot.status;
      final edits = <OwnerVehicleTypeEdit>[];

      for (final state in _vehicleTypeStates.values) {
        if (!state.hasChanges) continue;
        edits.add(
          OwnerVehicleTypeEdit(
            vehicleTypeId: state.vehicleType.id,
            totalSlots: int.parse(state.totalSlotsController.text.trim()),
            pricingModel: state.pricingModel,
            priceAmount: int.parse(state.priceAmountController.text.trim()),
          ),
        );
      }

      if (hasStatusChanged || edits.isNotEmpty) {
        await ref.read(ownerSaveLotEditsProvider)(
              lotId: widget.lot.id,
              status: nextStatus,
              edits: edits,
              changedBy: widget.ownerUid,
            );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa bãi xe'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('Trạng thái mở cửa'),
                subtitle: Text(_isOpen ? LotStatus.open : LotStatus.closed),
                value: _isOpen,
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _isOpen = value;
                        });
                      },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loại xe',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_vehicleTypeStates.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Chưa có vehicle_types để chỉnh sửa.'),
                ),
              )
            else
              ..._vehicleTypeStates.values.map(
                (state) => _VehicleTypeEditCard(
                  state: state,
                  enabled: !_isSaving,
                  onPricingModelChanged: (value) {
                    setState(() {
                      state.pricingModel = value;
                    });
                  },
                ),
              ),
            if (_errorText != null) ...[
              const SizedBox(height: 16),
              OwnerErrorMessage(message: _errorText!, centered: false),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeEditCard extends StatelessWidget {
  final VehicleTypeEditFormModel state;
  final bool enabled;
  final ValueChanged<String> onPricingModelChanged;

  const _VehicleTypeEditCard({
    required this.state,
    required this.enabled,
    required this.onPricingModelChanged,
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
              state.vehicleType.type,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: state.totalSlotsController,
              enabled: enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Tổng slot',
                border: OutlineInputBorder(),
              ),
              validator: _validateNonNegativeNumber,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: state.pricingModel,
              decoration: const InputDecoration(
                labelText: 'Pricing model',
                border: OutlineInputBorder(),
              ),
              items: pricingModelDropdownItems(),
              onChanged: enabled
                  ? (value) {
                      if (value != null) onPricingModelChanged(value);
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: state.priceAmountController,
              enabled: enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Giá (VND)',
                border: OutlineInputBorder(),
              ),
              validator: _validateNonNegativeNumber,
            ),
          ],
        ),
      ),
    );
  }

  static String? _validateNonNegativeNumber(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Không được để trống.';
    final number = int.tryParse(text);
    if (number == null || number < 0) return 'Giá trị không hợp lệ.';
    return null;
  }
}

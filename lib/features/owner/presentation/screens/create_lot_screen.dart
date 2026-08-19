import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_link/core/di/owner_providers.dart';
import 'package:parking_link/features/owner/domain/entities/create_lot_input.dart';
import 'package:parking_link/features/owner/domain/entities/pricing_model.dart';

class CreateLotScreen extends ConsumerStatefulWidget {
  final String ownerUid;

  const CreateLotScreen({
    super.key,
    required this.ownerUid,
  });

  @override
  ConsumerState<CreateLotScreen> createState() => _CreateLotScreenState();
}

class _CreateLotScreenState extends ConsumerState<CreateLotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _motoSlotsController = TextEditingController();
  final _motoPriceController = TextEditingController();
  final _carSlotsController = TextEditingController();
  final _carPriceController = TextEditingController();

  bool _useMoto = true;
  bool _useCar = true;
  String _motoPricingModel = PricingModel.perTrip;
  String _carPricingModel = PricingModel.perTrip;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _motoSlotsController.text = '200';
    _motoPriceController.text = '5000';
    _carSlotsController.text = '100';
    _carPriceController.text = '30000';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _motoSlotsController.dispose();
    _motoPriceController.dispose();
    _carSlotsController.dispose();
    _carPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo bãi xe mới')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Section 1 — Thông tin bãi'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên bãi',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Vui lòng nhập tên bãi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _sectionTitle('Section 2 — Vị trí GPS'),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _getCurrentPosition,
              icon: const Icon(Icons.my_location_rounded),
              label: const Text('📍 Lấy vị trí hiện tại'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Lat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validateCoordinate(value, isLat: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Lng',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validateCoordinate(value, isLat: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle('Section 3 — Loại xe & Giá'),
            CheckboxListTile(
              value: _useMoto,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _useMoto = value ?? false),
              title: const Text('🏍️ Xe máy'),
              contentPadding: EdgeInsets.zero,
            ),
            if (_useMoto) ...[
              _numberField(
                controller: _motoSlotsController,
                label: 'Số slot xe máy',
                validator: _validatePositiveInt,
              ),
              const SizedBox(height: 8),
              _numberField(
                controller: _motoPriceController,
                label: 'Giá xe máy (VND)',
                validator: _validateNonNegativeInt,
              ),
              const SizedBox(height: 8),
              _pricingModelDropdown(
                value: _motoPricingModel,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _motoPricingModel = value);
                },
              ),
            ],
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _useCar,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _useCar = value ?? false),
              title: const Text('🚗 Xe hơi'),
              contentPadding: EdgeInsets.zero,
            ),
            if (_useCar) ...[
              _numberField(
                controller: _carSlotsController,
                label: 'Số slot xe hơi',
                validator: _validatePositiveInt,
              ),
              const SizedBox(height: 8),
              _numberField(
                controller: _carPriceController,
                label: 'Giá xe hơi (VND)',
                validator: _validateNonNegativeInt,
              ),
              const SizedBox(height: 8),
              _pricingModelDropdown(
                value: _carPricingModel,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _carPricingModel = value);
                },
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: const Text('✅ Tạo bãi xe'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _pricingModelDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Loại giá',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: PricingModel.perTrip,
          child: Text('per_trip'),
        ),
        DropdownMenuItem(
          value: PricingModel.perDay,
          child: Text('per_day'),
        ),
      ],
      onChanged: _isLoading ? null : onChanged,
    );
  }

  String? _validateCoordinate(String? value, {required bool isLat}) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) {
      return isLat ? 'Vui lòng nhập lat' : 'Vui lòng nhập lng';
    }
    final parsed = double.tryParse(raw);
    if (parsed == null) {
      return isLat ? 'Lat không hợp lệ' : 'Lng không hợp lệ';
    }
    if (isLat && (parsed < -90 || parsed > 90)) {
      return 'Lat phải trong khoảng -90..90';
    }
    if (!isLat && (parsed < -180 || parsed > 180)) {
      return 'Lng phải trong khoảng -180..180';
    }
    return null;
  }

  String? _validatePositiveInt(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed <= 0) {
      return 'Giá trị phải > 0';
    }
    return null;
  }

  String? _validateNonNegativeInt(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) {
      return 'Giá trị phải >= 0';
    }
    return null;
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _errorMessage = null;
    });
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Không có quyền truy cập vị trí.';
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      _latController.text = position.latitude.toStringAsFixed(6);
      _lngController.text = position.longitude.toStringAsFixed(6);
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _submit() async {
    final hasVehicle = _useMoto || _useCar;
    if (!hasVehicle) {
      setState(() => _errorMessage = 'Vui lòng chọn ít nhất 1 loại xe');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final lat = double.parse(_latController.text.trim());
    final lng = double.parse(_lngController.text.trim());
    final vehicleTypes = <VehicleTypeInput>[
      if (_useMoto)
        VehicleTypeInput(
          type: 'moto',
          totalSlots: int.parse(_motoSlotsController.text.trim()),
          pricingModel: _motoPricingModel,
          priceAmount: int.parse(_motoPriceController.text.trim()),
        ),
      if (_useCar)
        VehicleTypeInput(
          type: 'car',
          totalSlots: int.parse(_carSlotsController.text.trim()),
          pricingModel: _carPricingModel,
          priceAmount: int.parse(_carPriceController.text.trim()),
        ),
    ];

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final createLotUseCase = ref.read(createLotUseCaseProvider);
      final lotId = await createLotUseCase(
        input: CreateLotInput(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          lat: lat,
          lng: lng,
          vehicleTypes: vehicleTypes,
        ),
        ownerUid: widget.ownerUid,
      );
      if (!mounted) return;
      Navigator.of(context).pop(lotId);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

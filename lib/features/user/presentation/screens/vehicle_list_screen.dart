import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';
import 'package:psgy/features/user/presentation/providers/user_profile_provider.dart';
import 'package:psgy/features/user/presentation/screens/vehicle_registration_screen.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final vehicles = profileAsync.value?.vehicles ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn xe gửi')),
      body: Column(
        children: [
          Expanded(
            child: vehicles.isEmpty
                ? const Center(child: Text('Chưa có xe đăng ký'))
                : ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return _VehicleTile(
                        vehicle: vehicle,
                        onTap: () => Navigator.pop(context, vehicle),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () async {
                  final added = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehicleRegistrationScreen(),
                    ),
                  );
                  if (added == true) {
                    ref.invalidate(userProfileProvider);
                  }
                },
                icon: const Text('➕'),
                label: const Text('Thêm xe mới'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({required this.vehicle, required this.onTap});

  final UserVehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = StringBuffer(
      vehicle.isPersonal ? 'Xe cá nhân' : 'Xe mượn',
    );
    if (vehicle.isDefault) subtitle.write(' · Mặc định');

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          vehicle.photoUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 56,
            height: 56,
            color: Colors.grey[300],
            child: const Icon(Icons.directions_car),
          ),
        ),
      ),
      title: Text(
        vehicle.plate,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle.toString()),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

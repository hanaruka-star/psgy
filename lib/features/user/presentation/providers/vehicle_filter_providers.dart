import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/app_settings_providers.dart';
import 'package:parking_link/features/user/domain/entities/vehicle_type_filter.dart';

/// Smart default: `moto` on first launch, then last user choice (Isar).
final vehicleTypeFilterProvider =
    NotifierProvider<VehicleTypeFilterNotifier, String>(
  VehicleTypeFilterNotifier.new,
);

class VehicleTypeFilterNotifier extends Notifier<String> {
  @override
  String build() {
    Future.microtask(_hydrateFromStorage);
    return VehicleTypeFilter.defaultFilter;
  }

  Future<void> _hydrateFromStorage() async {
    try {
      final settings =
          await ref.read(appSettingsLocalDataSourceProvider).getSettings();
      final stored = settings.preferredVehicleFilter == VehicleTypeFilter.other
          ? VehicleTypeFilter.all
          : settings.preferredVehicleFilter;
      if (VehicleTypeFilter.isValid(stored) && stored != state) {
        state = stored;
      }
    } catch (_) {
      // Keep in-memory default.
    }
  }

  Future<void> select(String type) async {
    if (type == VehicleTypeFilter.other) {
      type = VehicleTypeFilter.all;
    }
    if (!VehicleTypeFilter.isValid(type) || state == type) return;
    state = type;
    try {
      await ref
          .read(appSettingsLocalDataSourceProvider)
          .setPreferredVehicleFilter(type);
    } catch (_) {
      // Preference is best-effort; filter still applies in session.
    }
  }
}

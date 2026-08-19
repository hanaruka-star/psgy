import 'package:geolocator/geolocator.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';

class UserLocationDataSource {
  Future<GeoCoordinate?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    return GeoCoordinate(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

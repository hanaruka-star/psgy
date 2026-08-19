import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psgy/core/utils/currency_formatter.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:psgy/features/user/domain/entities/map_lot_item.dart';

/// Surveying lot brand color — amber/orange (#FFB300).
const surveyingMarkerColor = Color(0xFFFFB300);
const surveyingMarkerDeep = Color(0xFFFF8F00);

const activeMarkerGreen = Color(0xFF22C55E);
const activeMarkerGreenDeep = Color(0xFF16A34A);
const fullMarkerRed = Color(0xFFF44336);
const surveyingChipOrange = Color(0xFFFF9800);
const mixedClusterPurple = Color(0xFF7C3AED);

enum ClusterBadgeType { none, potential, mixed }

enum MarkerVehicleKind { car, moto, other }
enum MarkerClusterKind { dynamic, survey, mixed }

/// Cached map marker icons to avoid recreating [BitmapDescriptor] on every rebuild.
class ParkingLotMarkerIconCache {
  ParkingLotMarkerIconCache._();

  static final Map<String, BitmapDescriptor> _customCache = {};
  static final Map<String, BitmapDescriptor> _clusterCache = {};

  static Future<BitmapDescriptor> activeIcon({
    required MarkerVehicleKind vehicleKind,
    required bool isSelected,
    required bool isFull,
  }) async {
    final key =
        'active_${vehicleKind.name}_${isSelected ? 'sel' : 'def'}_${isFull ? 'full' : 'ok'}';
    final cached = _customCache[key];
    if (cached != null) return cached;

    final icon = await _buildActiveCircleBitmap(
      width: isSelected ? 36 : 30,
      height: isSelected ? 48 : 40,
      vehicleKind: vehicleKind,
      isSelected: isSelected,
      isFull: isFull,
    );
    _customCache[key] = icon;
    return icon;
  }

  static Future<BitmapDescriptor> surveyingIcon({
    required bool isSelected,
    required MarkerVehicleKind vehicleKind,
    double pulsePhase = 0,
  }) async {
    final kindKey = vehicleKind.name;
    final phaseKey = (pulsePhase * 10).round().clamp(0, 10);
    final key = isSelected
        ? 'surveying_${kindKey}_sel_$phaseKey'
        : 'surveying_${kindKey}_$phaseKey';
    final cached = _customCache[key];
    if (cached != null) return cached;

    final icon = await _buildSurveyingCircleBitmap(
      width: isSelected ? 36 : 30,
      height: isSelected ? 48 : 40,
      isSelected: isSelected,
      vehicleKind: vehicleKind,
    );
    _customCache[key] = icon;
    return icon;
  }

  static Future<BitmapDescriptor> clusterIcon(
    int count, {
    required MarkerClusterKind clusterKind,
    MarkerVehicleKind? vehicleKind,
    ClusterBadgeType badge = ClusterBadgeType.none,
  }) async {
    final bucket = _clusterBucket(count);
    final kindKey = vehicleKind?.name ?? 'none';
    final cacheKey = '${bucket}_${clusterKind.name}_${kindKey}_${badge.name}';
    final cached = _clusterCache[cacheKey];
    if (cached != null) return cached;

    final icon = await _buildClusterBitmap(
      size: count >= 50 ? 40 : count >= 20 ? 36 : 32,
      text: count.toString(),
      clusterKind: clusterKind,
      vehicleKind: vehicleKind,
      badge: badge,
    );
    _clusterCache[cacheKey] = icon;
    return icon;
  }

  static int _clusterBucket(int count) {
    if (count >= 100) return 100;
    if (count >= 50) return 50;
    if (count >= 20) return 20;
    if (count >= 10) return 10;
    return count;
  }

  static IconData _iconForVehicle(MarkerVehicleKind kind) {
    return switch (kind) {
      MarkerVehicleKind.car => Icons.directions_car_filled_rounded,
      MarkerVehicleKind.moto => Icons.two_wheeler_rounded,
      MarkerVehicleKind.other => Icons.more_horiz_rounded,
    };
  }

  static MarkerVehicleKind vehicleKindFromType(String? type) {
    return switch (type) {
      'car' => MarkerVehicleKind.car,
      'moto' => MarkerVehicleKind.moto,
      _ => MarkerVehicleKind.other,
    };
  }

  static Future<BitmapDescriptor> _buildActiveCircleBitmap({
    required int width,
    required int height,
    required MarkerVehicleKind vehicleKind,
    required bool isSelected,
    required bool isFull,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final circleCenter = Offset(width / 2, width / 2);
    final radius = width / 2;
    final bg = isFull ? fullMarkerRed : const Color(0xFF4CAF50);
    canvas.drawPath(
      _teardropPath(
        width: width.toDouble(),
        height: height.toDouble(),
      ),
      Paint()..color = bg,
    );
    if (isSelected) {
      canvas.drawCircle(
        circleCenter,
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }

    const iconSize = 16.0;
    final iconColor = isFull
        ? Colors.white.withValues(alpha: 0.76)
        : Colors.white;
    _paintMaterialIcon(
      canvas: canvas,
      center: circleCenter,
      icon: _iconForVehicle(vehicleKind),
      size: iconSize,
      color: iconColor,
    );

    if (isFull) {
      final cross = Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.4;
      canvas.drawLine(
        Offset(circleCenter.dx - 6, circleCenter.dy - 6),
        Offset(circleCenter.dx + 6, circleCenter.dy + 6),
        cross,
      );
    }

    final image = await recorder.endRecording().toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> _buildSurveyingCircleBitmap({
    required int width,
    required int height,
    required bool isSelected,
    required MarkerVehicleKind vehicleKind,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final circleCenter = Offset(width / 2, width / 2);
    final radius = width / 2;
    canvas.drawPath(
      _teardropPath(
        width: width.toDouble(),
        height: height.toDouble(),
      ),
      Paint()..color = const Color(0xFFFF9800),
    );
    if (isSelected) {
      canvas.drawCircle(
        circleCenter,
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }

    _paintMaterialIcon(
      canvas: canvas,
      center: circleCenter,
      icon: _iconForVehicle(vehicleKind),
      size: 16,
      color: Colors.white,
    );

    final image = await recorder.endRecording().toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> _buildClusterBitmap({
    required int size,
    required String text,
    required MarkerClusterKind clusterKind,
    required MarkerVehicleKind? vehicleKind,
    required ClusterBadgeType badge,
  }) async {
    final _ = Object.hash(size, vehicleKind, badge);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const width = 36.0;
    const height = 48.0;
    const renderWidth = 36;
    const renderHeight = 48;
    const circleCenter = Offset(width / 2, width / 2);
    final baseColor = switch (clusterKind) {
      MarkerClusterKind.dynamic => const Color(0xFF4CAF50),
      MarkerClusterKind.survey => const Color(0xFFFF9800),
      MarkerClusterKind.mixed => mixedClusterPurple,
    };

    canvas.drawPath(
      _teardropPath(
        width: width,
        height: height,
      ),
      Paint()..color = baseColor,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        circleCenter.dx - textPainter.width / 2,
        circleCenter.dy - textPainter.height / 2,
      ),
    );

    final image =
        await recorder.endRecording().toImage(renderWidth, renderHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  static void _paintMaterialIcon({
    required Canvas canvas,
    required Offset center,
    required IconData icon,
    required double size,
    required Color color,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  static Path _teardropPath({
    required double width,
    required double height,
  }) {
    final circleCenter = Offset(width / 2, width / 2);
    final circleRadius = width / 2;
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: circleCenter,
          radius: circleRadius,
        ),
      )
      ..moveTo(width * 0.24, width * 0.58)
      ..lineTo(width * 0.76, width * 0.58)
      ..lineTo(width / 2, height)
      ..close();
  }

}

class MapLotMarker {
  const MapLotMarker._();

  static Future<Marker> build({
    required MapLotItem item,
    required bool isSelected,
    required VoidCallback onTap,
    MarkerVehicleKind? vehicleKind,
    int? activeAvailableSlots,
    double pulsePhase = 0,
  }) async {
    final BitmapDescriptor icon;
    final resolvedKind = vehicleKind ?? MarkerVehicleKind.car;
    final snippet = item.isActive
        ? item.parkingLot!.address
        : _surveyingSnippet(item.surveyingLot!);

    if (item.isActive) {
      final isOpen = item.parkingLot!.isOpen;
      final isFull = !isOpen || ((activeAvailableSlots ?? 0) <= 0);
      icon = await ParkingLotMarkerIconCache.activeIcon(
        vehicleKind: resolvedKind,
        isSelected: isSelected,
        isFull: isFull,
      );
    } else {
      icon = await ParkingLotMarkerIconCache.surveyingIcon(
        isSelected: isSelected,
        vehicleKind: resolvedKind,
        pulsePhase: pulsePhase,
      );
    }

    return Marker(
      markerId: MarkerId(item.mapKey),
      position: LatLng(item.lat, item.lng),
      icon: icon,
      anchor: const Offset(0.5, 1.0),
      zIndexInt: isSelected ? item.mapZIndex + 2 : item.mapZIndex,
      infoWindow: InfoWindow(
        title: item.name,
        snippet: snippet,
      ),
      onTap: onTap,
    );
  }

  static String _surveyingSnippet(SurveyingLotEntity lot) {
    final slots = lot.totalSlots > 0 ? lot.totalSlots : (lot.estimatedSlots ?? 0);
    final slotText = '~$slots chỗ';
    final priceText = _priceByVehicleTypes(lot);
    if (priceText != null) {
      return '$slotText • $priceText';
    }
    if (lot.category.trim().isNotEmpty) {
      return '$slotText • ${lot.category.trim()}';
    }
    return slotText;
  }

  static String? _priceByVehicleTypes(SurveyingLotEntity lot) {
    final car = '🚗 ${_priceLabel(lot.carPrice)}';
    final moto = '🏍️ ${_priceLabel(lot.motoPrice)}';
    return switch (lot.vehicleTypes) {
      'both' => '$car • $moto',
      'car' => car,
      'moto' => moto,
      _ => null,
    };
  }

  static String _priceLabel(int price) => formatVnd(price);
}

/// Legacy wrapper for active lots only.
class ParkingLotMarker {
  const ParkingLotMarker._();

  static Future<Marker> build({
    required ParkingLotEntity lot,
    required bool isSelected,
    required VoidCallback onTap,
    MarkerVehicleKind? vehicleKind,
    int? activeAvailableSlots,
  }) {
    return MapLotMarker.build(
      item: MapLotItem.active(lot),
      isSelected: isSelected,
      onTap: onTap,
      vehicleKind: vehicleKind,
      activeAvailableSlots: activeAvailableSlots,
    );
  }
}

class SurveyingLotMarker {
  const SurveyingLotMarker._();

  static Future<Marker> build({
    required SurveyingLotEntity lot,
    required bool isSelected,
    required VoidCallback onTap,
    MarkerVehicleKind? vehicleKind,
    double pulsePhase = 0,
  }) {
    return MapLotMarker.build(
      item: MapLotItem.surveying(lot),
      isSelected: isSelected,
      onTap: onTap,
      vehicleKind: vehicleKind,
      pulsePhase: pulsePhase,
    );
  }
}

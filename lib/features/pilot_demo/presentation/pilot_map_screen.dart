import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';

class PilotMapScreen extends StatefulWidget {
  static const routeName = 'pilot_map';

  const PilotMapScreen({super.key});

  static const LatLng _hcmcCenter = LatLng(10.7769, 106.7009);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const PilotMapScreen(),
    );
  }

  @override
  State<PilotMapScreen> createState() => _PilotMapScreenState();
}

class _PilotMapScreenState extends State<PilotMapScreen> {
  String? _mapStyle;
  BitmapDescriptor? _coachIcon;
  Brightness? _loadedBrightness;
  Color? _loadedMarkerColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    final markerColor = AppStatusColors.highlight(brightness);
    final onMarker = AppStatusColors.onHighlight(brightness);
    if (brightness != _loadedBrightness) {
      _loadedBrightness = brightness;
      _loadMapStyle(brightness);
    }
    if (markerColor != _loadedMarkerColor) {
      _loadedMarkerColor = markerColor;
      _loadCoachIcon(markerColor, onMarker);
    }
  }

  Future<void> _loadMapStyle(Brightness brightness) async {
    final asset = brightness == Brightness.dark
        ? 'assets/map_style/map_style_dark.json'
        : 'assets/map_style/map_style_light.json';
    final json = await rootBundle.loadString(asset);
    if (!mounted || Theme.of(context).brightness != brightness) return;
    setState(() => _mapStyle = json);
  }

  Future<void> _loadCoachIcon(Color fill, Color onFill) async {
    final icon = await _buildCoachMarkerIcon(fill, onFill);
    if (!mounted || _loadedMarkerColor != fill) return;
    setState(() => _coachIcon = icon);
  }

  void _openCoach(MockCoach coach) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CoachDetailScreen(coach: coach),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _coachIcon;
    final markers = {
      if (icon != null)
        for (final coach in mockCoaches)
          Marker(
            markerId: MarkerId(coach.id),
            position: LatLng(coach.lat, coach.lng),
            infoWindow: InfoWindow(title: coach.name),
            icon: icon,
            onTap: () => _openCoach(coach),
          ),
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: PilotMapScreen._hcmcCenter,
              zoom: 13,
            ),
            style: _mapStyle,
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 280),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.22,
            maxChildSize: 0.78,
            builder: (context, scrollController) {
              return Material(
                color: AppStatusColors.sheetBackground(
                  Theme.of(context).brightness,
                ),
                elevation: 0,
                shape: AppShapes.sheetTop(),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Coach gần bạn',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppStatusColors.sheetTitle(
                                  Theme.of(context).brightness,
                                ),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          0,
                          AppSpacing.md,
                          AppSpacing.lg,
                        ),
                        itemCount: mockCoaches.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final coach = mockCoaches[index];
                          return _CoachCard(
                            coach: coach,
                            onTap: () => _openCoach(coach),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.coach, required this.onTap});

  final MockCoach coach;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Text(
                  coach.initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coach.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    AppRating(
                      value: coach.rating,
                      suffix:
                          '${coach.distanceKm.toStringAsFixed(1)} km',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTag(label: coach.nextSlotLabel, highlight: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<BitmapDescriptor> _buildCoachMarkerIcon(
  Color fill,
  Color onFill,
) async {
  const width = 36;
  const height = 48;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const circleCenter = Offset(width / 2, width / 2);
  final path = Path()
    ..addOval(
      Rect.fromCircle(center: circleCenter, radius: width / 2),
    )
    ..moveTo(width * 0.24, width * 0.58)
    ..lineTo(width * 0.76, width * 0.58)
    ..lineTo(width / 2, height.toDouble())
    ..close();
  canvas.drawPath(path, Paint()..color = fill);
  canvas.drawCircle(circleCenter, 6, Paint()..color = onFill);
  final image = await recorder.endRecording().toImage(width, height);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
}

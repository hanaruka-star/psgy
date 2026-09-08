import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_gyms.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_gym.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  BitmapDescriptor? _partnerGymIcon;
  BitmapDescriptor? _collectedGymIcon;
  Brightness? _loadedBrightness;
  Color? _loadedMarkerColor;
  bool _showGyms = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final markerColor = AppStatusColors.highlight(brightness);
    final onMarker = AppStatusColors.onHighlight(brightness);
    if (brightness != _loadedBrightness) {
      _loadedBrightness = brightness;
      _loadMapStyle(brightness);
    }
    if (markerColor != _loadedMarkerColor) {
      _loadedMarkerColor = markerColor;
      _loadMarkerIcons(theme, markerColor, onMarker);
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

  Future<void> _loadMarkerIcons(
    ThemeData theme,
    Color fill,
    Color onFill,
  ) async {
    const collectedFill = AppStatusColors.tabInactive;
    final collectedOnFill = theme.colorScheme.surface;
    final results = await Future.wait([
      _buildCoachMarkerIcon(fill, onFill),
      _buildGymMarkerIcon(fill, onFill),
      _buildGymMarkerIcon(collectedFill, collectedOnFill),
    ]);
    if (!mounted || _loadedMarkerColor != fill) return;
    setState(() {
      _coachIcon = results[0];
      _partnerGymIcon = results[1];
      _collectedGymIcon = results[2];
    });
  }

  void _openCoach(MockCoach coach) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CoachDetailScreen(coach: coach),
      ),
    );
  }

  Future<void> _openDirections(MockGym gym) async {
    final launched = await launchUrl(
      gym.directionsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không mở được Google Maps.')),
      );
    }
  }

  void _selectLayer({required bool gyms}) {
    if (_showGyms == gyms) return;
    setState(() => _showGyms = gyms);
  }

  void _showGymInfo(MockGym gym) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppStatusColors.sheetBackground(
        Theme.of(context).brightness,
      ),
      shape: AppShapes.sheetTop(),
      builder: (context) {
        return Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GymCard(gym: gym, onDirections: () => _openDirections(gym)),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final coachIcon = _coachIcon;
    final partnerIcon = _partnerGymIcon;
    final collectedIcon = _collectedGymIcon;
    final markers = <Marker>{
      if (!_showGyms && coachIcon != null)
        for (final coach in mockCoaches)
          Marker(
            markerId: MarkerId(coach.id),
            position: LatLng(coach.lat, coach.lng),
            infoWindow: InfoWindow(title: coach.name),
            icon: coachIcon,
            onTap: () => _openCoach(coach),
          ),
      if (_showGyms && partnerIcon != null && collectedIcon != null)
        for (final gym in mockGyms)
          Marker(
            markerId: MarkerId(gym.id),
            position: LatLng(gym.lat, gym.lng),
            infoWindow: InfoWindow(
              title: gym.name,
              snippet: gym.gymSourceType,
            ),
            icon: gym.isPartner ? partnerIcon : collectedIcon,
            onTap: () => _showGymInfo(gym),
          ),
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: PilotMapScreen._hcmcCenter,
              zoom: 12.2,
            ),
            style: _mapStyle,
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(top: 88, bottom: 280),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _MapFilterChip(
                          key: const Key('map_chip_coach'),
                          label: 'Coach',
                          icon: Icons.person_outline,
                          selected: !_showGyms,
                          onPressed: () => _selectLayer(gyms: false),
                        ),
                        _MapFilterChip(
                          key: const Key('map_chip_gym'),
                          label: 'Phòng gym',
                          icon: Icons.fitness_center_outlined,
                          selected: _showGyms,
                          onPressed: () => _selectLayer(gyms: true),
                        ),
                      ],
                    ),
                    if (_showGyms) ...[
                      const SizedBox(height: AppSpacing.sm),
                      const _GymLegend(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.22,
            maxChildSize: 0.78,
            builder: (context, scrollController) {
              return Material(
                color: AppStatusColors.sheetBackground(brightness),
                elevation: 0,
                shape: AppShapes.sheetTop(),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
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
                          _showGyms ? 'Phòng gym' : 'Coach gần bạn',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppStatusColors.sheetTitle(brightness),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        key: ValueKey(_showGyms),
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          0,
                          AppSpacing.md,
                          AppSpacing.lg,
                        ),
                        itemCount: _showGyms
                            ? mockGyms.length
                            : mockCoaches.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          if (_showGyms) {
                            final gym = mockGyms[index];
                            return _GymCard(
                              gym: gym,
                              onDirections: () => _openDirections(gym),
                            );
                          }
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

class _MapFilterChip extends StatelessWidget {
  const _MapFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final selectedFill = AppStatusColors.highlight(brightness);
    final selectedFg = AppStatusColors.onHighlight(brightness);
    return FilterChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? selectedFg : theme.colorScheme.onSurface,
      ),
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onPressed(),
      selectedColor: selectedFill,
      backgroundColor: theme.colorScheme.surface,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected ? selectedFg : theme.colorScheme.onSurface,
      ),
      side: BorderSide(
        color: selected
            ? selectedFill
            : theme.colorScheme.outline.withValues(alpha: 0.4),
      ),
    );
  }
}

class _GymLegend extends StatelessWidget {
  const _GymLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.94),
      elevation: 1,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.2),
      borderRadius: AppSpacing.borderRadiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs + 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _LegendRow(
              color: AppStatusColors.highlight(brightness),
              label: 'Hệ thống — đối tác PSgy',
            ),
            const SizedBox(height: AppSpacing.xs),
            const _LegendRow(
              color: AppStatusColors.tabInactive,
              label: 'Thu thập — chỉ tham khảo',
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
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
                      suffix: '${coach.distanceKm.toStringAsFixed(1)} km',
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

class _GymCard extends StatelessWidget {
  const _GymCard({required this.gym, required this.onDirections});

  final MockGym gym;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partner = gym.isPartner;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: partner
                      ? AppStatusColors.highlight(theme.brightness)
                      : AppStatusColors.tabInactive,
                  foregroundColor: partner
                      ? AppStatusColors.onHighlight(theme.brightness)
                      : theme.colorScheme.surface,
                  child: const Icon(Icons.fitness_center, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gym.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(gym.address, style: theme.textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.sm),
                      AppTag(
                        label: gym.gymSourceType,
                        highlight: partner,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: onDirections,
                icon: const Icon(Icons.directions_outlined, size: 18),
                label: const Text('Chỉ đường'),
              ),
            ),
          ],
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

Future<BitmapDescriptor> _buildGymMarkerIcon(
  Color fill,
  Color onFill,
) async {
  const width = 36;
  const height = 48;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(4, 4, 28, 28),
    const Radius.circular(6),
  );
  canvas.drawRRect(rect, Paint()..color = fill);
  final tail = Path()
    ..moveTo(width * 0.32, 30)
    ..lineTo(width * 0.68, 30)
    ..lineTo(width / 2, height.toDouble())
    ..close();
  canvas.drawPath(tail, Paint()..color = fill);
  canvas.drawRect(
    Rect.fromCenter(center: const Offset(18, 18), width: 10, height: 10),
    Paint()..color = onFill,
  );
  final image = await recorder.endRecording().toImage(width, height);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
}

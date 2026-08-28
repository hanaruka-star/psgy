import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_booking_history_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_wallet_screen.dart';

class PilotMapScreen extends StatelessWidget {
  static const routeName = 'pilot_map';

  const PilotMapScreen({super.key});

  static const LatLng _hcmcCenter = LatLng(10.7769, 106.7009);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const PilotMapScreen(),
    );
  }

  void _openCoach(BuildContext context, MockCoach coach) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CoachDetailScreen(coach: coach),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = {
      for (final coach in mockCoaches)
        Marker(
          markerId: MarkerId(coach.id),
          position: LatLng(coach.lat, coach.lng),
          infoWindow: InfoWindow(title: coach.name),
          onTap: () => _openCoach(context, coach),
        ),
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _hcmcCenter,
              zoom: 13,
            ),
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
                color: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusXl),
                  ),
                ),
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
                        AppSpacing.sm,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Coach gần bạn',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Lịch sử booking',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const UserBookingHistoryScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.receipt_long_outlined),
                          ),
                          IconButton(
                            tooltip: 'Ví của tôi',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const UserWalletScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.account_balance_wallet_outlined),
                          ),
                        ],
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
                            onTap: () => _openCoach(context, coach),
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
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
                child: Text(
                  coach.initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimaryContainer,
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
                    Text(
                      '⭐ ${coach.rating.toStringAsFixed(1)}  ·  ${coach.distanceKm.toStringAsFixed(1)} km',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(coach.nextSlotLabel),
                      backgroundColor: AppColors.primaryContainer,
                      side: BorderSide.none,
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
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

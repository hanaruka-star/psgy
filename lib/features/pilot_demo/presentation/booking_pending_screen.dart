import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_map_screen.dart';

class BookingPendingScreen extends StatefulWidget {
  const BookingPendingScreen({
    super.key,
    required this.coach,
    required this.service,
  });

  final MockCoach coach;
  final MockService service;

  @override
  State<BookingPendingScreen> createState() => _BookingPendingScreenState();
}

class _BookingPendingScreenState extends State<BookingPendingScreen> {
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _confirmed = true);
    });
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == PilotMapScreen.routeName || route.isFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_confirmed ? 'Đã xác nhận' : 'Đang chờ xác nhận'),
        automaticallyImplyLeading: _confirmed,
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: _confirmed ? _buildConfirmed(theme) : _buildWaiting(theme),
      ),
    );
  }

  Widget _buildWaiting(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Đang chờ Coach xác nhận...',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmed(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '✅ Coach đã xác nhận!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.coach.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(widget.service.name, style: theme.textTheme.bodyLarge),
                      Text(
                        widget.service.priceLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(widget.coach.nextSlotLabel),
                      const Text('Coach đến chỗ bạn'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _goHome,
              child: const Text('Về trang chủ'),
            ),
          ),
        ),
      ],
    );
  }
}

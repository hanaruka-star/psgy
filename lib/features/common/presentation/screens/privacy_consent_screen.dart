import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/di/app_settings_providers.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/common/presentation/screens/privacy_policy_screen.dart';
import 'package:psgy/features/common/presentation/screens/terms_of_service_screen.dart';
import 'package:psgy/shared/widgets/modern_card.dart';

class PrivacyConsentScreen extends ConsumerWidget {
  final VoidCallback onAccepted;

  const PrivacyConsentScreen({super.key, required this.onAccepted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Quyền riêng tư & Dữ liệu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'ParkingLink sử dụng vị trí và dữ liệu bãi xe để giúp bạn tìm chỗ đậu. '
                'Chúng tôi không bán dữ liệu cá nhân của bạn.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const ModernCard(
                enableScaleTap: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConsentRow(
                      icon: Icons.location_on_outlined,
                      title: 'Vị trí',
                      subtitle: 'Hiển thị bãi xe gần bạn trên bản đồ',
                    ),
                    Divider(height: AppSpacing.lg),
                    _ConsentRow(
                      icon: Icons.cloud_outlined,
                      title: 'Dữ liệu bãi xe',
                      subtitle: 'Đồng bộ tình trạng chỗ trống và bãi khảo sát',
                    ),
                    Divider(height: AppSpacing.lg),
                    _ConsentRow(
                      icon: Icons.analytics_outlined,
                      title: 'Chẩn đoán',
                      subtitle: 'Giúp cải thiện ổn định app (Crashlytics)',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    child: const Text('Chính sách'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TermsOfServiceScreen(),
                        ),
                      );
                    },
                    child: const Text('Điều khoản'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await ref
                        .read(appSettingsLocalDataSourceProvider)
                        .setPrivacyConsentAccepted(true);
                    onAccepted();
                  },
                  child: const Text('Đồng ý và tiếp tục'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Phiên bản ${AppConfig.fullVersion}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ConsentRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

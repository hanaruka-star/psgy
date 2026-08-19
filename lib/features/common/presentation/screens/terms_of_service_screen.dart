import 'package:flutter/material.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/common/presentation/screens/privacy_policy_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  List<LegalSectionItem> get allSections => [
        const LegalSectionItem(
          title: '1. Chấp nhận điều khoản',
          body:
              'Bằng việc sử dụng ParkingLink, bạn đồng ý tuân thủ các điều khoản này '
              'và chính sách quyền riêng tư của chúng tôi.',
        ),
        const LegalSectionItem(
          title: '2. Dịch vụ',
          body:
              'ParkingLink cung cấp thông tin bãi xe và tình trạng chỗ trống mang tính tham khảo. '
              'Thông tin bãi khảo sát chưa hoạt động và có thể thay đổi.',
        ),
        const LegalSectionItem(
          title: '3. Trách nhiệm người dùng',
          body:
              'Bạn chịu trách nhiệm tuân thủ luật giao thông và quy định của bãi xe khi sử dụng dịch vụ.',
        ),
        const LegalSectionItem(
          title: '4. Liên hệ',
          body: 'Mọi thắc mắc vui lòng liên hệ ${AppConfig.supportEmail}.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điều khoản sử dụng')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Cập nhật: ${AppConfig.fullVersion}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final section in allSections) ...[
            Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(section.body, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
          ],
          OutlinedButton.icon(
            onPressed: () => _openUrl(AppConfig.termsOfServiceUrl),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Xem bản đầy đủ trên web'),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

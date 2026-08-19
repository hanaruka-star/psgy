import 'package:flutter/material.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalSectionItem {
  final String title;
  final String body;

  const LegalSectionItem({required this.title, required this.body});
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  List<LegalSectionItem> get allSections => [
        const LegalSectionItem(
          title: '1. Dữ liệu chúng tôi thu thập',
          body:
              'ParkingLink có thể thu thập vị trí thiết bị (khi bạn cho phép), '
              'thông tin bãi xe bạn xem/tìm kiếm, và dữ liệu chẩn đoán kỹ thuật '
              'để cải thiện độ ổn định ứng dụng.',
        ),
        const LegalSectionItem(
          title: '2. Mục đích sử dụng',
          body:
              'Dữ liệu được dùng để hiển thị bãi xe gần bạn, cập nhật tình trạng chỗ trống, '
              'đồng bộ bãi khảo sát, và hỗ trợ khắc phục sự cố.',
        ),
        const LegalSectionItem(
          title: '3. Chia sẻ dữ liệu',
          body:
              'Chúng tôi không bán dữ liệu cá nhân. Dữ liệu có thể được xử lý qua '
              'nhà cung cấp hạ tầng (Firebase/Google Cloud) theo hợp đồng bảo mật.',
        ),
        const LegalSectionItem(
          title: '4. Quyền của bạn',
          body: 'Bạn có thể rút quyền truy cập vị trí trong cài đặt thiết bị. '
              'Liên hệ ${AppConfig.supportEmail} để yêu cầu hỗ trợ về dữ liệu.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chính sách quyền riêng tư')),
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
            onPressed: () => _openUrl(AppConfig.privacyPolicyUrl),
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

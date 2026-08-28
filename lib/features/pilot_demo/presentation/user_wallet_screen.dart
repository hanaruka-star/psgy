import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';

class UserWalletScreen extends StatelessWidget {
  const UserWalletScreen({super.key});

  Future<void> _buy(BuildContext context, MockPackage package) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận mua'),
          content: Text('${package.name}\n${package.priceLabel}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xác nhận mua'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;

    MockUserSession.instance.purchasePackage(package.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã mua ${package.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Ví của tôi')),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Text('Gói hệ thống', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final package in mockSystemPackages) ...[
                Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(package.name, style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(package.priceLabel, style: theme.textTheme.bodyLarge),
                        Text(
                          package.validityLabel,
                          style: theme.textTheme.bodySmall,
                        ),
                        if (package.description.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            package.description,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: () => _buy(context, package),
                            child: const Text('Mua'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
              Text('Ví đã mua', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              if (session.wallets.isEmpty)
                Text(
                  'Chưa có gói nào trong ví.',
                  style: theme.textTheme.bodyMedium,
                )
              else
                for (final wallet in session.wallets) ...[
                  Card(
                    child: ListTile(
                      title: Text(wallet.packageName),
                      subtitle: Text(
                        'Còn lại ${wallet.remainingLabel}\n'
                        'Mua ngày ${dateFormat.format(wallet.purchasedAt)}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class CoachServicesScreen extends StatelessWidget {
  const CoachServicesScreen({super.key});

  Future<void> _editService(
    BuildContext context,
    MockCoachSession session, {
    MockService? existing,
  }) async {
    final result = await showDialog<MockService>(
      context: context,
      builder: (_) => _ServiceFormDialog(existing: existing),
    );
    if (result == null) return;
    session.upsertService(result);
  }

  Future<void> _confirmDelete(
    BuildContext context, {
    required String title,
    required VoidCallback onConfirm,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: const Text('Xóa mục này khỏi danh sách demo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
    if (ok == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    final session = MockCoachSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final theme = Theme.of(context);
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Dịch vụ của bạn')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _editService(context, session),
            child: const Icon(Icons.add),
          ),
          body: ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: session.services.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final service = session.services[index];
              return Card(
                child: ListTile(
                  title: Text(service.name),
                  subtitle: Text(
                    '${service.priceLabel} · ${service.durationMinutes} phút',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editService(context, session, existing: service);
                      } else if (value == 'delete') {
                        _confirmDelete(
                          context,
                          title: 'Xóa dịch vụ',
                          onConfirm: () => session.removeService(service.id),
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Sửa')),
                      PopupMenuItem(value: 'delete', child: Text('Xóa')),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ServiceFormDialog extends StatefulWidget {
  const _ServiceFormDialog({this.existing});

  final MockService? existing;

  @override
  State<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<_ServiceFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _duration;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _price = TextEditingController(
      text: existing == null ? '' : existing.priceVnd.toString(),
    );
    _duration = TextEditingController(
      text: existing == null ? '' : existing.durationMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _duration.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final price = int.tryParse(_price.text.trim());
    final duration = int.tryParse(_duration.text.trim());
    if (name.isEmpty || price == null || duration == null) return;
    Navigator.of(context).pop(
      MockService(
        id: widget.existing?.id ?? 'svc_${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        priceVnd: price,
        durationMinutes: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Thêm dịch vụ' : 'Sửa dịch vụ'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Giá (VND)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _duration,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Thời lượng (phút)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
}

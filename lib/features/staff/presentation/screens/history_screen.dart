import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/staff/domain/entities/staff_history_filter.dart';
import 'package:psgy/features/staff/presentation/models/history_item_ui_model.dart';
import 'package:psgy/features/staff/presentation/providers/staff_ui_providers.dart';
import 'package:psgy/shared/widgets/empty_state.dart';
import 'package:psgy/shared/widgets/loading_shimmer.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';
import 'package:psgy/shared/widgets/modern_card.dart';
import 'package:psgy/shared/widgets/status_chip.dart';
import 'package:psgy/shared/widgets/ui_polish_widgets.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final String lotId;
  final String lotName;

  const HistoryScreen({
    super.key,
    required this.lotId,
    required this.lotName,
  });

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử — ${widget.lotName}'),
        actions: [
          IconButton(
            tooltip: _dateRange == null ? 'Lọc theo ngày' : 'Xóa lọc ngày',
            onPressed: _dateRange == null ? _pickDateRange : () {
              setState(() => _dateRange = null);
            },
            icon: Icon(
              _dateRange == null
                  ? Icons.date_range_rounded
                  : Icons.filter_alt_off_rounded,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Xe hơi'),
            Tab(text: 'Xe máy'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: ScaleTap(
                onTap: _pickDateRange,
                child: AnimatedFilterChip(
                  label:
                      '${DateFormat('dd/MM').format(_dateRange!.start)} — ${DateFormat('dd/MM').format(_dateRange!.end)}',
                  selected: true,
                  icon: Icons.calendar_today_rounded,
                  onSelected: (_) => _pickDateRange(),
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _HistoryList(
                  lotId: widget.lotId,
                  filter: StaffHistoryFilter.all,
                  dateRange: _dateRange,
                ),
                _HistoryList(
                  lotId: widget.lotId,
                  filter: StaffHistoryFilter.car,
                  dateRange: _dateRange,
                ),
                _HistoryList(
                  lotId: widget.lotId,
                  filter: StaffHistoryFilter.moto,
                  dateRange: _dateRange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends ConsumerStatefulWidget {
  final String lotId;
  final StaffHistoryFilter filter;
  final DateTimeRange? dateRange;

  const _HistoryList({
    required this.lotId,
    required this.filter,
    required this.dateRange,
  });

  @override
  ConsumerState<_HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<_HistoryList> {
  final ScrollController _scrollController = ScrollController();
  int _lastRenderedCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lotId = widget.lotId;
    final filter = widget.filter;
    final dateRange = widget.dateRange;
    final historyAsync = ref.watch(
      staffHistoryFilteredUiProvider((lotId: lotId, filter: filter)),
    );
    final paginationState = ref.watch(staffHistoryPaginationProvider(lotId));

    ref.listen<AsyncValue<List<HistoryItemUiModel>>>(
      staffHistoryFilteredUiProvider((lotId: lotId, filter: filter)),
      (_, next) {
        final items = next.valueOrNull;
        if (items == null) return;
        final previousCount = _lastRenderedCount;
        _lastRenderedCount = items.length;
        if (items.length <= previousCount || !_scrollController.hasClients) {
          return;
        }
        final isNearTop = _scrollController.position.pixels <= 32;
        if (!isNearTop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_scrollController.hasClients) return;
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
          );
        });
      },
    );

    return historyAsync.when(
      loading: () => const LoadingShimmerList(itemCount: 4, itemHeight: 88),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(
          staffHistoryFilteredUiProvider((lotId: lotId, filter: filter)),
        ),
      ),
      data: (items) {
        final filtered = _applyDateFilter(items, dateRange);

        if (filtered.isEmpty) {
          return EmptyStateView(
            icon: Icons.history_rounded,
            title: 'Chưa có hoạt động nào',
            subtitle: dateRange == null
                ? 'Lịch sử check-in/out sẽ hiển thị tại đây'
                : 'Không có hoạt động trong khoảng thời gian đã chọn',
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: AppSpacing.screenPadding,
          itemCount: filtered.length + 1,
          itemBuilder: (context, index) {
            if (index == filtered.length) {
              return _LoadMoreSection(
                state: paginationState,
                onLoadMore: () => ref
                    .read(staffHistoryPaginationProvider(lotId).notifier)
                    .loadMore(),
              );
            }
            final isLast = index == filtered.length - 1;
            return FadeSlideIn(
              index: index,
              child: _TimelineTile(
                item: filtered[index],
                isLast: isLast,
              ),
            );
          },
        );
      },
    );
  }

  List<HistoryItemUiModel> _applyDateFilter(
    List<HistoryItemUiModel> items,
    DateTimeRange? range,
  ) {
    if (range == null) return items;

    return items
        .where((item) {
          final day = DateTime(
            item.timestamp.year,
            item.timestamp.month,
            item.timestamp.day,
          );
          final start = DateTime(
            range.start.year,
            range.start.month,
            range.start.day,
          );
          final end = DateTime(
            range.end.year,
            range.end.month,
            range.end.day,
          );
          return !day.isBefore(start) && !day.isAfter(end);
        })
        .toList(growable: false);
  }
}

class _LoadMoreSection extends StatelessWidget {
  final StaffHistoryPaginationState state;
  final Future<void> Function() onLoadMore;

  const _LoadMoreSection({
    required this.state,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Center(
          child: Text('Đã tải toàn bộ lịch sử'),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: onLoadMore,
            icon: const Icon(Icons.expand_more_rounded),
            label: const Text('Load more'),
          ),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                state.errorMessage!.replaceFirst('Exception: ', ''),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final HistoryItemUiModel item;
  final bool isLast;

  const _TimelineTile({
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final variant = _variant;
    final dotColor = _dotColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.45),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            dotColor.withValues(alpha: 0.6),
                            Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: ModernCard(
                padding: const EdgeInsets.all(AppSpacing.md - 2),
                enableScaleTap: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusChip(
                          label: _actionLabel,
                          variant: variant,
                          icon: _actionIcon,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (item.vehiclePlate != null &&
                        item.vehiclePlate!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        text: 'Biển số: ${item.vehiclePlate}',
                      ),
                    _InfoRow(
                      icon: Icons.two_wheeler_outlined,
                      text: 'Loại xe: ${_vehicleTypeLabel(item.vehicleType)}',
                    ),
                    _InfoRow(
                      icon: Icons.schedule_rounded,
                      text: DateFormat('HH:mm • dd/MM/yyyy')
                          .format(item.timestamp),
                    ),
                    if (item.reason != null && item.reason!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.notes_rounded,
                        text: 'Lý do: ${item.reason}',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StatusChipVariant get _variant {
    switch (item.action) {
      case HistoryAction.checkIn:
        return StatusChipVariant.success;
      case HistoryAction.checkOut:
        return StatusChipVariant.danger;
      case HistoryAction.manual:
        return StatusChipVariant.warning;
    }
  }

  Color get _dotColor {
    switch (item.action) {
      case HistoryAction.checkIn:
        return AppColors.success;
      case HistoryAction.checkOut:
        return AppColors.danger;
      case HistoryAction.manual:
        return AppColors.warning;
    }
  }

  IconData get _actionIcon {
    switch (item.action) {
      case HistoryAction.checkIn:
        return Icons.login_rounded;
      case HistoryAction.checkOut:
        return Icons.logout_rounded;
      case HistoryAction.manual:
        return Icons.tune_rounded;
    }
  }

  String get _actionLabel {
    switch (item.action) {
      case HistoryAction.checkIn:
        return 'Check In';
      case HistoryAction.checkOut:
        return 'Check Out';
      case HistoryAction.manual:
        return 'Thủ công';
    }
  }

  String get _title {
    switch (item.action) {
      case HistoryAction.checkIn:
        return 'Xe vào bãi';
      case HistoryAction.checkOut:
        return 'Xe ra bãi';
      case HistoryAction.manual:
        final delta = item.delta ?? 0;
        final sign = delta > 0 ? '+$delta' : delta.toString();
        return 'Điều chỉnh slot $sign';
    }
  }

  String _vehicleTypeLabel(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

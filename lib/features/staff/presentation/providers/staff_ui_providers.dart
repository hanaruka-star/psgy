import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/staff_providers.dart';
import 'package:psgy/features/staff/domain/entities/staff_history_filter.dart';
import 'package:psgy/features/parking/domain/entities/history_item_entity.dart';
import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';
import 'package:psgy/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:psgy/features/staff/presentation/mappers/history_item_ui_mapper.dart';
import 'package:psgy/features/staff/presentation/models/history_item_ui_model.dart';

const _historySessionPageSize = 50;
const _historyAdjustmentPageSize = 20;

class StaffHistoryPaginationState {
  final List<HistoryItemEntity> olderItems;
  final bool isLoadingMore;
  final String? errorMessage;
  final DateTime? sessionCursor;
  final String? sessionCursorId;
  final DateTime? adjustmentCursor;
  final String? adjustmentCursorId;
  final bool hasMoreSessions;
  final bool hasMoreAdjustments;

  const StaffHistoryPaginationState({
    this.olderItems = const [],
    this.isLoadingMore = false,
    this.errorMessage,
    this.sessionCursor,
    this.sessionCursorId,
    this.adjustmentCursor,
    this.adjustmentCursorId,
    this.hasMoreSessions = true,
    this.hasMoreAdjustments = true,
  });

  bool get hasMore => hasMoreSessions || hasMoreAdjustments;

  StaffHistoryPaginationState copyWith({
    List<HistoryItemEntity>? olderItems,
    bool? isLoadingMore,
    String? errorMessage,
    DateTime? sessionCursor,
    String? sessionCursorId,
    DateTime? adjustmentCursor,
    String? adjustmentCursorId,
    bool? hasMoreSessions,
    bool? hasMoreAdjustments,
    bool clearError = false,
  }) {
    return StaffHistoryPaginationState(
      olderItems: olderItems ?? this.olderItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sessionCursor: sessionCursor ?? this.sessionCursor,
      sessionCursorId: sessionCursorId ?? this.sessionCursorId,
      adjustmentCursor: adjustmentCursor ?? this.adjustmentCursor,
      adjustmentCursorId: adjustmentCursorId ?? this.adjustmentCursorId,
      hasMoreSessions: hasMoreSessions ?? this.hasMoreSessions,
      hasMoreAdjustments: hasMoreAdjustments ?? this.hasMoreAdjustments,
    );
  }
}

class StaffHistoryPaginationController
    extends StateNotifier<StaffHistoryPaginationState> {
  final Ref _ref;
  final String _lotId;

  StaffHistoryPaginationController(this._ref, this._lotId)
      : super(const StaffHistoryPaginationState());

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final baseSessions =
          _ref.read(recentSessionsProvider((_lotId, _historySessionPageSize))).valueOrNull ??
              const <ParkingSessionEntity>[];
      final baseAdjustments = _ref
              .read(recentAdjustmentsProvider((_lotId, _historyAdjustmentPageSize)))
              .valueOrNull ??
          const <ManualAdjustmentEntity>[];

      final sessionsCursor = state.sessionCursor ??
          (baseSessions.isNotEmpty ? baseSessions.last.checkedInAt : null);
      final sessionsCursorId =
          state.sessionCursorId ?? (baseSessions.isNotEmpty ? baseSessions.last.id : null);
      final adjustmentsCursor = state.adjustmentCursor ??
          (baseAdjustments.isNotEmpty ? baseAdjustments.last.createdAt : null);
      final adjustmentsCursorId = state.adjustmentCursorId ??
          (baseAdjustments.isNotEmpty ? baseAdjustments.last.id : null);

      List<ParkingSessionEntity> moreSessions = const [];
      if (state.hasMoreSessions && sessionsCursor != null && sessionsCursorId != null) {
        moreSessions = await _ref.read(getMoreRecentSessionsUseCaseProvider)(
              lotId: _lotId,
              startAfterCheckedInAt: sessionsCursor,
              startAfterId: sessionsCursorId,
              limit: _historySessionPageSize,
            );
      }

      List<ManualAdjustmentEntity> moreAdjustments = const [];
      if (state.hasMoreAdjustments &&
          adjustmentsCursor != null &&
          adjustmentsCursorId != null) {
        moreAdjustments = await _ref.read(getMoreRecentAdjustmentsUseCaseProvider)(
              lotId: _lotId,
              startAfterCreatedAt: adjustmentsCursor,
              startAfterId: adjustmentsCursorId,
              limit: _historyAdjustmentPageSize,
            );
      }

      final mergedOlder = _dedupeAndSort([
        ...state.olderItems,
        ..._toSessionHistoryItems(moreSessions),
        ..._toAdjustmentHistoryItems(moreAdjustments),
      ]);

      state = state.copyWith(
        olderItems: mergedOlder,
        isLoadingMore: false,
        hasMoreSessions: sessionsCursor == null
            ? false
            : (moreSessions.length == _historySessionPageSize),
        hasMoreAdjustments: adjustmentsCursor == null
            ? false
            : (moreAdjustments.length == _historyAdjustmentPageSize),
        sessionCursor:
            moreSessions.isNotEmpty ? moreSessions.last.checkedInAt : sessionsCursor,
        sessionCursorId: moreSessions.isNotEmpty ? moreSessions.last.id : sessionsCursorId,
        adjustmentCursor:
            moreAdjustments.isNotEmpty ? moreAdjustments.last.createdAt : adjustmentsCursor,
        adjustmentCursorId:
            moreAdjustments.isNotEmpty ? moreAdjustments.last.id : adjustmentsCursorId,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
    }
  }

  List<HistoryItemEntity> _toSessionHistoryItems(List<ParkingSessionEntity> sessions) {
    final items = <HistoryItemEntity>[];
    for (final session in sessions) {
      items.add(
        HistoryItemEntity(
          id: '${session.id}_check_in',
          action: HistoryActionEntity.checkIn,
          vehiclePlate: session.vehiclePlate,
          vehicleType: session.vehicleType,
          timestamp: session.checkedInAt,
          delta: null,
          reason: null,
        ),
      );
      if (session.checkedOutAt != null) {
        items.add(
          HistoryItemEntity(
            id: '${session.id}_check_out',
            action: HistoryActionEntity.checkOut,
            vehiclePlate: session.vehiclePlate,
            vehicleType: session.vehicleType,
            timestamp: session.checkedOutAt!,
            delta: null,
            reason: null,
          ),
        );
      }
    }
    return items;
  }

  List<HistoryItemEntity> _toAdjustmentHistoryItems(
    List<ManualAdjustmentEntity> adjustments,
  ) {
    return adjustments
        .map(
          (item) => HistoryItemEntity(
            id: item.id,
            action: HistoryActionEntity.manual,
            vehiclePlate: null,
            vehicleType: item.vehicleType,
            timestamp: item.createdAt,
            delta: item.delta,
            reason: item.reason,
          ),
        )
        .toList(growable: false);
  }

  List<HistoryItemEntity> _dedupeAndSort(List<HistoryItemEntity> items) {
    final map = <String, HistoryItemEntity>{};
    for (final item in items) {
      map[item.id] = item;
    }
    final merged = map.values.toList(growable: false);
    merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return merged;
  }
}

final staffHistoryPaginationProvider = StateNotifierProvider.autoDispose
    .family<StaffHistoryPaginationController, StaffHistoryPaginationState, String>(
  (ref, lotId) => StaffHistoryPaginationController(ref, lotId),
);

final staffHistoryUiProvider =
    Provider.family<AsyncValue<List<HistoryItemUiModel>>, String>((ref, lotId) {
  final baseAsync = ref.watch(historyProvider(lotId));
  final pagination = ref.watch(staffHistoryPaginationProvider(lotId));

  return baseAsync.whenData((baseItems) {
    final merged = <HistoryItemEntity>[
      ...baseItems,
      ...pagination.olderItems,
    ];
    final deduped = <String, HistoryItemEntity>{};
    for (final item in merged) {
      deduped[item.id] = item;
    }
    final sorted = deduped.values.toList(growable: false)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return HistoryItemUiMapper.toUiModels(sorted);
  });
});

final staffHistoryFilteredUiProvider = Provider.family<
    AsyncValue<List<HistoryItemUiModel>>, ({String lotId, StaffHistoryFilter filter})>(
  (ref, params) {
    final itemsAsync = ref.watch(staffHistoryUiProvider(params.lotId));
    return itemsAsync.whenData((items) {
    final vehicleType = params.filter.vehicleType;
    if (vehicleType == null) {
      return items;
    }
    return items
        .where((item) => item.vehicleType == vehicleType)
        .toList(growable: false);
    });
  },
);

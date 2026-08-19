import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/features/user/domain/entities/active_session_info.dart';
import 'package:parking_link/features/user/domain/entities/my_parking_record.dart';
import 'package:parking_link/features/user/domain/entities/parking_enums.dart';

class MyParkingState {
  const MyParkingState({
    this.currentRecord,
    this.activeSession,
    this.isLoading = false,
  });

  final MyParkingRecord? currentRecord;
  final ActiveSessionInfo? activeSession;
  final bool isLoading;

  ParkingMode get parkingMode {
    if (activeSession != null) return ParkingMode.checkedIn;
    if (currentRecord != null &&
        currentRecord!.type == ParkingRecordType.selfManaged) {
      return ParkingMode.selfManaged;
    }
    return ParkingMode.none;
  }

  MyParkingState copyWith({
    MyParkingRecord? currentRecord,
    ActiveSessionInfo? activeSession,
    bool? isLoading,
    bool clearRecord = false,
    bool clearSession = false,
  }) =>
      MyParkingState(
        currentRecord:
            clearRecord ? null : currentRecord ?? this.currentRecord,
        activeSession:
            clearSession ? null : activeSession ?? this.activeSession,
        isLoading: isLoading ?? this.isLoading,
      );
}

class MyParkingNotifier extends AsyncNotifier<MyParkingState> {
  @override
  Future<MyParkingState> build() async {
    final currentRecord =
        await ref.read(getCurrentParkingUseCaseProvider).call();
    return MyParkingState(currentRecord: currentRecord);
  }

  Future<void> saveParking({
    required double latitude,
    required double longitude,
    String? photoPath,
  }) async {
    state = AsyncData(state.value!.copyWith(isLoading: true));
    try {
      await ref.read(saveSelfManagedParkingUseCaseProvider).call(
            latitude: latitude,
            longitude: longitude,
            photoPath: photoPath,
          );
      final updated = await ref.read(getCurrentParkingUseCaseProvider).call();
      state = AsyncData(state.value!.copyWith(
        currentRecord: updated,
        isLoading: false,
      ));
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<void> clearParking() async {
    await ref.read(clearParkingRecordUseCaseProvider).call();
    state = AsyncData(state.value!.copyWith(clearRecord: true));
  }
}

final myParkingProvider =
    AsyncNotifierProvider<MyParkingNotifier, MyParkingState>(
  MyParkingNotifier.new,
);

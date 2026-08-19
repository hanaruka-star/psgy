import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/features/user/domain/entities/qr_token.dart';
import 'package:parking_link/features/user/domain/entities/user_vehicle.dart';

class QrTokenState {
  const QrTokenState({
    this.token,
    this.isLoading = false,
    this.error,
    this.isCheckedIn = false,
  });

  final QrToken? token;
  final bool isLoading;
  final String? error;
  final bool isCheckedIn;

  Duration get remainingTime {
    if (token == null) return Duration.zero;
    final remaining = token!.expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isExpired => token?.isExpired ?? false;

  QrTokenState copyWith({
    QrToken? token,
    bool? isLoading,
    String? error,
    bool? isCheckedIn,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return QrTokenState(
      token: clearToken ? null : token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}

class QrTokenNotifier extends AutoDisposeAsyncNotifier<QrTokenState> {
  StreamSubscription<QrToken?>? _tokenSubscription;

  @override
  Future<QrTokenState> build() async {
    ref.onDispose(() => _tokenSubscription?.cancel());
    return const QrTokenState();
  }

  Future<void> createToken(UserVehicle vehicle) async {
    state = const AsyncLoading();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('Chưa đăng nhập');
      }
      final phone = user.phoneNumber;
      if (phone == null || phone.isEmpty) {
        throw StateError('Không có số điện thoại');
      }
      final maskedPhone = _maskPhone(phone);

      final token = await ref.read(createQrTokenUseCaseProvider).call(
            userId: user.uid,
            vehicle: vehicle,
            maskedPhone: maskedPhone,
          );

      state = AsyncData(QrTokenState(token: token));
      _watchToken(token.tokenId);
    } catch (e) {
      state = AsyncData(QrTokenState(error: e.toString()));
    }
  }

  void _watchToken(String tokenId) {
    _tokenSubscription?.cancel();
    _tokenSubscription =
        ref.read(watchQrTokenUseCaseProvider).call(tokenId).listen(
      (updatedToken) {
        if (updatedToken == null) return;

        final current = state.value ?? const QrTokenState();
        if (updatedToken.sessionId != null) {
          state = AsyncData(current.copyWith(
            token: updatedToken,
            isCheckedIn: true,
          ));
          return;
        }

        state = AsyncData(current.copyWith(token: updatedToken));
      },
      onError: (Object e) {
        state = AsyncData((state.value ?? const QrTokenState())
            .copyWith(error: e.toString()));
      },
    );
  }

  Future<void> cancelToken() async {
    final tokenId = state.value?.token?.tokenId;
    if (tokenId != null) {
      await ref.read(cancelQrTokenUseCaseProvider).call(tokenId);
    }
    _tokenSubscription?.cancel();
    state = const AsyncData(QrTokenState());
  }

  Future<void> refreshToken(UserVehicle vehicle) async {
    await cancelToken();
    await createToken(vehicle);
  }

  String _maskPhone(String phone) {
    final normalized = phone.replaceAll(RegExp(r'^\+84'), '0');
    if (normalized.length < 7) return normalized;
    return normalized.replaceRange(3, 7, '***');
  }
}

final qrTokenProvider =
    AsyncNotifierProvider.autoDispose<QrTokenNotifier, QrTokenState>(
  QrTokenNotifier.new,
);

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';

class CheckoutQrTokenState {
  const CheckoutQrTokenState({
    this.token,
    this.isLoading = false,
    this.error,
    this.isCompleted = false,
  });

  final CheckoutQrToken? token;
  final bool isLoading;
  final String? error;

  /// Staff has scanned + confirmed the check-out.
  final bool isCompleted;

  Duration get remainingTime {
    if (token == null) return Duration.zero;
    final remaining = token!.expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isExpired => token?.isExpired ?? false;

  CheckoutQrTokenState copyWith({
    CheckoutQrToken? token,
    bool? isLoading,
    String? error,
    bool? isCompleted,
    bool clearError = false,
    bool clearToken = false,
  }) {
    return CheckoutQrTokenState(
      token: clearToken ? null : token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class CheckoutQrTokenNotifier
    extends AutoDisposeAsyncNotifier<CheckoutQrTokenState> {
  StreamSubscription<CheckoutQrToken?>? _tokenSubscription;

  @override
  Future<CheckoutQrTokenState> build() async {
    ref.onDispose(() => _tokenSubscription?.cancel());
    return const CheckoutQrTokenState();
  }

  Future<void> createToken({
    required String sessionId,
    required String userId,
    required int estimatedFee,
  }) async {
    state = const AsyncLoading();
    try {
      final token = await ref.read(createCheckoutQrTokenUseCaseProvider).call(
            sessionId: sessionId,
            userId: userId,
            estimatedFee: estimatedFee,
          );
      state = AsyncData(CheckoutQrTokenState(token: token));
      _watchToken(token.tokenId);
    } catch (e) {
      state = AsyncData(CheckoutQrTokenState(error: e.toString()));
    }
  }

  void _watchToken(String tokenId) {
    _tokenSubscription?.cancel();
    _tokenSubscription =
        ref.read(watchCheckoutQrTokenUseCaseProvider).call(tokenId).listen(
      (updated) {
        if (updated == null) return;
        final current = state.value ?? const CheckoutQrTokenState();
        // Staff completed the check-out.
        if (updated.used && updated.checkOutStaffId != null) {
          state = AsyncData(current.copyWith(
            token: updated,
            isCompleted: true,
          ));
          return;
        }
        state = AsyncData(current.copyWith(token: updated));
      },
      onError: (Object e) {
        state = AsyncData((state.value ?? const CheckoutQrTokenState())
            .copyWith(error: e.toString()));
      },
    );
  }

  Future<void> cancelToken() async {
    final tokenId = state.value?.token?.tokenId;
    if (tokenId != null) {
      try {
        await ref.read(cancelCheckoutQrTokenUseCaseProvider).call(tokenId);
      } catch (_) {
        // Best-effort cancel; ignore failures (e.g. already used/expired).
      }
    }
    _tokenSubscription?.cancel();
    state = const AsyncData(CheckoutQrTokenState());
  }

  Future<void> refreshToken({
    required String sessionId,
    required String userId,
    required int estimatedFee,
  }) async {
    await cancelToken();
    await createToken(
      sessionId: sessionId,
      userId: userId,
      estimatedFee: estimatedFee,
    );
  }
}

final checkoutQrTokenProvider = AsyncNotifierProvider.autoDispose<
    CheckoutQrTokenNotifier, CheckoutQrTokenState>(
  CheckoutQrTokenNotifier.new,
);

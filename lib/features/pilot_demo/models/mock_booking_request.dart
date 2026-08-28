import 'package:psgy/features/pilot_demo/models/mock_service.dart';

enum MockBookingStatus {
  pending,
  confirmed,
  inProgress,
  awaitingUserConfirmation,
  completed,
  cancelled,
}

enum MockPaymentMethod { cash, wallet }

class MockBookingRequest {
  final String id;
  final String userName;
  final String userAvatarInitials;
  final String serviceName;
  final int priceVnd;
  final String requestedTimeLabel;
  final String locationLabel;
  final MockBookingStatus status;
  final String? cancelReason;
  final MockPaymentMethod paymentMethod;
  final int topUpAmountVnd;
  final int? rating;
  final String? reviewComment;
  final String coachId;
  final String coachName;

  const MockBookingRequest({
    required this.id,
    required this.userName,
    required this.userAvatarInitials,
    required this.serviceName,
    required this.priceVnd,
    required this.requestedTimeLabel,
    required this.locationLabel,
    required this.status,
    this.cancelReason,
    this.paymentMethod = MockPaymentMethod.cash,
    this.topUpAmountVnd = 0,
    this.rating,
    this.reviewComment,
    this.coachId = '',
    this.coachName = '',
  });

  String get priceLabel => formatVnd(priceVnd);

  int get walletChargeVnd => paymentMethod == MockPaymentMethod.wallet
      ? priceVnd - topUpAmountVnd
      : 0;

  String get paymentSummary {
    if (paymentMethod == MockPaymentMethod.cash) {
      return 'Thanh toán tiền mặt trực tiếp với Coach';
    }
    if (topUpAmountVnd <= 0) {
      return 'Thanh toán bằng ví — 0đ tiền mặt';
    }
    return 'Ví ${formatVnd(walletChargeVnd)} · tiền mặt thêm ${formatVnd(topUpAmountVnd)}';
  }

  String get paymentMethodLabel =>
      paymentMethod == MockPaymentMethod.wallet ? 'Ví' : 'Tiền mặt';

  bool get isActive =>
      status == MockBookingStatus.confirmed ||
      status == MockBookingStatus.inProgress ||
      status == MockBookingStatus.awaitingUserConfirmation;

  bool get isTrackable =>
      status == MockBookingStatus.pending ||
      status == MockBookingStatus.confirmed ||
      status == MockBookingStatus.inProgress ||
      status == MockBookingStatus.awaitingUserConfirmation;

  String get statusLabel {
    return switch (status) {
      MockBookingStatus.pending => 'Chờ xác nhận',
      MockBookingStatus.confirmed => 'Đã xác nhận',
      MockBookingStatus.inProgress => 'Đang tập',
      MockBookingStatus.awaitingUserConfirmation => 'Chờ khách xác nhận',
      MockBookingStatus.completed => 'Hoàn thành',
      MockBookingStatus.cancelled => 'Đã hủy',
    };
  }

  MockBookingRequest copyWith({
    MockBookingStatus? status,
    String? cancelReason,
    int? rating,
    String? reviewComment,
  }) {
    return MockBookingRequest(
      id: id,
      userName: userName,
      userAvatarInitials: userAvatarInitials,
      serviceName: serviceName,
      priceVnd: priceVnd,
      requestedTimeLabel: requestedTimeLabel,
      locationLabel: locationLabel,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
      paymentMethod: paymentMethod,
      topUpAmountVnd: topUpAmountVnd,
      rating: rating ?? this.rating,
      reviewComment: reviewComment ?? this.reviewComment,
      coachId: coachId,
      coachName: coachName,
    );
  }
}

import 'package:psgy/features/pilot_demo/models/mock_service.dart';

enum MockBookingStatus {
  pending,
  confirmed,
  inProgress,
  awaitingUserConfirmation,
  completed,
  cancelled,
}

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
  });

  String get priceLabel => formatVnd(priceVnd);

  bool get isActive =>
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
    );
  }
}

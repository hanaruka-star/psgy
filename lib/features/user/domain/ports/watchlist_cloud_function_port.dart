/// Contract for Cloud Function that promotes surveying lots.
///
/// Trigger (backend):
///   parking_lots/{lotId} created from surveying_lots
///   → FCM topic `lot_open_{lotId}` push to subscribed devices
abstract class WatchlistCloudFunctionPort {
  String lotOpeningTopic(String lotId);

  Map<String, String> openingNotificationPayload({
    required String lotId,
    required String lotName,
  });
}

class WatchlistCloudFunctionContract implements WatchlistCloudFunctionPort {
  @override
  String lotOpeningTopic(String lotId) => 'lot_open_$lotId';

  @override
  Map<String, String> openingNotificationPayload({
    required String lotId,
    required String lotName,
  }) {
    return {
      'type': 'lot_opened',
      'lotId': lotId,
      'lotName': lotName,
      'title': 'Bãi bạn theo dõi đã mở cửa!',
      'body': '$lotName đã có chỗ đỗ • Nhấn để xem ngay',
    };
  }
}

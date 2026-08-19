abstract class WatchlistNotificationPort {
  Future<void> registerInterest(String lotId);
}

class NoOpWatchlistNotificationPort implements WatchlistNotificationPort {
  @override
  Future<void> registerInterest(String lotId) async {}
}

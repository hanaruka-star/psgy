import 'package:psgy/features/user/domain/repositories/user_watchlist_repository.dart';

/// Legacy alias — prefer [WatchUserWatchlistUseCase].
class WatchWatchedLotsUseCase {
  final UserWatchlistRepository repository;

  WatchWatchedLotsUseCase(this.repository);

  Stream<Set<String>> call() => repository.watchWatchedLotIds();
}

import 'package:psgy/features/user/domain/entities/watchlist_entity.dart';
import 'package:psgy/features/user/domain/repositories/user_watchlist_repository.dart';

class WatchUserWatchlistUseCase {
  final UserWatchlistRepository repository;

  WatchUserWatchlistUseCase(this.repository);

  Stream<List<WatchlistEntity>> call() => repository.watchWatchlist();
}

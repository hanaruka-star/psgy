import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';
import 'package:parking_link/features/user/domain/repositories/user_watchlist_repository.dart';

class WatchUserWatchlistUseCase {
  final UserWatchlistRepository repository;

  WatchUserWatchlistUseCase(this.repository);

  Stream<List<WatchlistEntity>> call() => repository.watchWatchlist();
}

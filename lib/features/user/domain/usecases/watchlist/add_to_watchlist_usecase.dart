import 'package:psgy/features/user/domain/entities/watchlist_entity.dart';
import 'package:psgy/features/user/domain/repositories/user_watchlist_repository.dart';

class AddToWatchlistUseCase {
  final UserWatchlistRepository repository;

  AddToWatchlistUseCase(this.repository);

  Future<void> call(WatchlistEntity entry) => repository.add(entry);
}

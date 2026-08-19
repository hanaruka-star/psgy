import 'package:psgy/features/user/domain/entities/watchlist_entity.dart';
import 'package:psgy/features/user/domain/repositories/user_watchlist_repository.dart';

class ToggleWatchLotUseCase {
  final UserWatchlistRepository repository;

  ToggleWatchLotUseCase(this.repository);

  Future<bool> call(WatchlistEntity entry) => repository.toggle(entry);
}

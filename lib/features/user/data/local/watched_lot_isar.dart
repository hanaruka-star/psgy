import 'package:isar/isar.dart';

part 'watched_lot_isar.g.dart';

@collection
class WatchedLotIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String lotId;

  late String lotName;

  late DateTime watchedAt;

  DateTime? estimatedOpeningAt;

  bool hasUnreadUpdate = false;
}

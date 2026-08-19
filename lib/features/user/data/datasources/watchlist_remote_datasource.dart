import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';

class WatchlistRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WatchlistRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _watchlistRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('watchlist');
  }

  Future<String?> _uidOrNull() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;
    return null;
  }

  Future<void> upsert(WatchlistEntity entry) async {
    final uid = await _uidOrNull();
    if (uid == null) return;

    await _watchlistRef(uid).doc(entry.lotId).set({
      'lotId': entry.lotId,
      'lotName': entry.lotName,
      'watchedAt': Timestamp.fromDate(entry.watchedAt),
      'estimatedOpeningAt': entry.estimatedOpeningAt == null
          ? null
          : Timestamp.fromDate(entry.estimatedOpeningAt!),
      'notifyOnOpen': true,
      'fcmTopic': _lotTopic(entry.lotId),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> remove(String lotId) async {
    final uid = await _uidOrNull();
    if (uid == null) return;
    await _watchlistRef(uid).doc(lotId).delete();
  }

  static String _lotTopic(String lotId) => 'lot_open_$lotId';
}

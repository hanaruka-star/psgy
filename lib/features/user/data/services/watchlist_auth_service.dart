import 'package:firebase_auth/firebase_auth.dart';

/// Ensures a Firebase user exists for watchlist sync (anonymous for User app).
class WatchlistAuthService {
  final FirebaseAuth _auth;

  WatchlistAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<String?> ensureUserId() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;

    try {
      final credential = await _auth.signInAnonymously();
      return credential.user?.uid;
    } catch (_) {
      return null;
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;
}

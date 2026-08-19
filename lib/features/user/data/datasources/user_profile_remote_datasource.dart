import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_link/core/error/app_exception.dart';

abstract class IUserProfileRemoteDatasource {
  Future<void> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String smsCode);
  Future<bool> isProfileExists(String userId);
  Future<void> createProfile(Map<String, dynamic> data, String userId);
  Future<Map<String, dynamic>?> getProfile(String userId);
  Future<void> addVehicle(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getVehicles(String userId);
  Future<void> updateVehicle(String vehicleId, Map<String, dynamic> data);
  Future<Map<String, dynamic>> createQrToken(Map<String, dynamic> data);
  Stream<Map<String, dynamic>?> watchQrToken(String tokenId);
  Future<void> updateQrToken(String tokenId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getQrToken(String tokenId);
  Future<void> completeQrToken(String tokenId, String sessionId);

  // Checkout QR tokens
  Future<Map<String, dynamic>> createCheckoutQrToken(
      String tokenId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getCheckoutQrToken(String tokenId);
  Stream<Map<String, dynamic>?> watchCheckoutQrToken(String tokenId);
  Future<void> updateCheckoutQrToken(
      String tokenId, Map<String, dynamic> data);

  /// Reads a parking session document (used to build a checkout token).
  Future<Map<String, dynamic>?> getParkingSession(String sessionId);

  /// Reads a parking lot document (used to resolve the lot name).
  Future<Map<String, dynamic>?> getParkingLot(String lotId);
}

class UserProfileRemoteDatasourceImpl implements IUserProfileRemoteDatasource {
  UserProfileRemoteDatasourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? _verificationId;

  static const _usersCollection = 'users';
  static const _vehiclesCollection = 'user_vehicles';
  static const _qrTokensCollection = 'qr_tokens';
  static const _checkoutQrTokensCollection = 'checkout_qr_tokens';
  static const _parkingSessionsCollection = 'parking_sessions';
  static const _parkingLotsCollection = 'parking_lots';

  @override
  Future<void> sendOtp(String phoneNumber) async {
    final completer = Completer<void>();
    final formatted = _formatPhoneNumber(phoneNumber);
    debugPrint('🔵 [Phone Auth] Calling verifyPhoneNumber: $formatted');

    await _auth.verifyPhoneNumber(
      phoneNumber: formatted,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        debugPrint('🟢 [Phone Auth] verificationCompleted (auto-verify)');
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (e) {
        debugPrint(
          '🔴 [Phone Auth] verificationFailed: ${e.code} - ${e.message}',
        );
        if (!completer.isCompleted) {
          completer.completeError(
            AuthException(e.message ?? 'Xác thực thất bại'),
          );
        }
      },
      codeSent: (verificationId, _) {
        debugPrint('🟢 [Phone Auth] codeSent verificationId=$verificationId');
        _verificationId = verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (id) {
        debugPrint('⚠️ [Phone Auth] codeAutoRetrievalTimeout: $id');
      },
    );

    return completer.future;
  }

  @override
  Future<String> verifyOtp(String smsCode) async {
    final verificationId = _verificationId;
    if (verificationId == null || verificationId.isEmpty) {
      throw const AuthException('Chưa gửi mã OTP. Vui lòng gửi lại.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    final uid = result.user?.uid;
    if (uid == null) {
      throw const AuthException('Đăng nhập thất bại');
    }
    return uid;
  }

  @override
  Future<bool> isProfileExists(String userId) async {
    final doc = await _firestore.collection(_usersCollection).doc(userId).get();
    return doc.exists;
  }

  @override
  Future<void> createProfile(Map<String, dynamic> data, String userId) async {
    await _firestore.collection(_usersCollection).doc(userId).set(data);
  }

  @override
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _firestore.collection(_usersCollection).doc(userId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  @override
  Future<void> addVehicle(Map<String, dynamic> data) async {
    await _firestore.collection(_vehiclesCollection).add(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getVehicles(String userId) async {
    final snapshot = await _firestore
        .collection(_vehiclesCollection)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => {...doc.data(), 'vehicleId': doc.id})
        .toList();
  }

  @override
  Future<void> updateVehicle(String vehicleId, Map<String, dynamic> data) async {
    await _firestore.collection(_vehiclesCollection).doc(vehicleId).update(data);
  }

  @override
  Future<Map<String, dynamic>> createQrToken(Map<String, dynamic> data) async {
    final tokenId = data['tokenId'] as String;
    await _firestore.collection(_qrTokensCollection).doc(tokenId).set(data);
    return {...data, 'tokenId': tokenId};
  }

  @override
  Stream<Map<String, dynamic>?> watchQrToken(String tokenId) {
    return _firestore
        .collection(_qrTokensCollection)
        .doc(tokenId)
        .snapshots()
        .map((snapshot) => snapshot.exists ? snapshot.data() : null);
  }

  @override
  Future<void> updateQrToken(String tokenId, Map<String, dynamic> data) async {
    await _firestore.collection(_qrTokensCollection).doc(tokenId).update(data);
  }

  @override
  Future<Map<String, dynamic>?> getQrToken(String tokenId) async {
    final doc =
        await _firestore.collection(_qrTokensCollection).doc(tokenId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  @override
  Future<void> completeQrToken(String tokenId, String sessionId) async {
    await _firestore.collection(_qrTokensCollection).doc(tokenId).update({
      'used': true,
      'usedAt': FieldValue.serverTimestamp(),
      'sessionId': sessionId,
    });
  }

  @override
  Future<Map<String, dynamic>> createCheckoutQrToken(
    String tokenId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(_checkoutQrTokensCollection)
        .doc(tokenId)
        .set(data);
    return {...data, 'tokenId': tokenId};
  }

  @override
  Future<Map<String, dynamic>?> getCheckoutQrToken(String tokenId) async {
    final doc = await _firestore
        .collection(_checkoutQrTokensCollection)
        .doc(tokenId)
        .get();
    if (!doc.exists) return null;
    return doc.data();
  }

  @override
  Stream<Map<String, dynamic>?> watchCheckoutQrToken(String tokenId) {
    return _firestore
        .collection(_checkoutQrTokensCollection)
        .doc(tokenId)
        .snapshots()
        .map((snapshot) => snapshot.exists ? snapshot.data() : null);
  }

  @override
  Future<void> updateCheckoutQrToken(
    String tokenId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(_checkoutQrTokensCollection)
        .doc(tokenId)
        .update(data);
  }

  @override
  Future<Map<String, dynamic>?> getParkingSession(String sessionId) async {
    final doc = await _firestore
        .collection(_parkingSessionsCollection)
        .doc(sessionId)
        .get();
    if (!doc.exists) return null;
    return doc.data();
  }

  @override
  Future<Map<String, dynamic>?> getParkingLot(String lotId) async {
    final doc =
        await _firestore.collection(_parkingLotsCollection).doc(lotId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  String _formatPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('84') && digits.length >= 11) {
      return '+$digits';
    }
    if (digits.startsWith('0') && digits.length == 10) {
      return '+84${digits.substring(1)}';
    }
    if (digits.length == 9) {
      return '+84$digits';
    }
    return '+84$digits';
  }
}

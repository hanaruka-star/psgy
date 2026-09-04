import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psgy/core/error/app_exception.dart';

abstract class IUserProfileRemoteDatasource {
  Future<void> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String smsCode);
  Future<bool> isProfileExists(String userId);
  Future<void> createProfile(Map<String, dynamic> data, String userId);
  Future<Map<String, dynamic>?> getProfile(String userId);
  Future<void> addVehicle(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getVehicles(String userId);
  Future<void> updateVehicle(String vehicleId, Map<String, dynamic> data);
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

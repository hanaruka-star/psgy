import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'seed_data.dart';

Future<void> seedStaffAccounts() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final now = Timestamp.now();

  final accounts = <Map<String, String>>[
    {
      'name': 'Owner Lot A',
      'email': 'owner@parkinglink.com',
      'password': '123456',
      'role': 'owner',
      'lotId': seedLotANguyenHueQ1Id,
    },
    {
      'name': 'Staff A',
      'email': 'staff_a@parkinglink.com',
      'password': '123456',
      'role': 'staff',
      'lotId': seedLotANguyenHueQ1Id,
    },
    {
      'name': 'Staff B',
      'email': 'staff_b@parkinglink.com',
      'password': '123456',
      'role': 'staff',
      'lotId': seedLotBLeVanSyQ3Id,
    },
    {
      'name': 'Owner CC Dragon',
      'email': 'owner_dragon@parkinglink.com',
      'password': 'Dragon2026!',
      'role': 'owner',
      'lotId': 'lot_cc_dragon',
    },
  ];

  final originalUser = auth.currentUser;
  String? originalEmail;

  for (final account in accounts) {
    final email = account['email']!;
    final password = account['password']!;
    final name = account['name']!;
    final role = account['role']!;
    final lotId = account['lotId']!;

    final uid = await _ensureAccountUid(
      auth: auth,
      email: email,
      password: password,
    );

    final profileRef = firestore.collection('staff_profiles').doc(uid);
    final existing = await profileRef.get();
    final createdAt = (existing.data()?['createdAt'] as Timestamp?) ?? now;

    await profileRef.set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'lotId': lotId,
      'isActive': true,
      'createdAt': createdAt,
      'updatedAt': now,
    });

    debugPrint('[seed_staff] ensured account: $email');
  }

  await auth.signOut();
  if (originalUser != null) {
    originalEmail = originalUser.email;
  }

  if (originalEmail != null) {
    debugPrint(
      '[seed_staff] previous signed-in user was "$originalEmail", '
      'please sign in again if needed.',
    );
  }
}

Future<String> _ensureAccountUid({
  required FirebaseAuth auth,
  required String email,
  required String password,
}) async {
  try {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Failed to create account for "$email".');
    }
    return user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code != 'email-already-in-use') {
      throw Exception(
        'Failed to create account "$email": ${e.message ?? e.code}',
      );
    }

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Email "$email" exists but no user was returned.');
      }
      return user.uid;
    } on FirebaseAuthException catch (signInError) {
      throw Exception(
        'Email "$email" already exists and cannot be reused with this password: '
        '${signInError.message ?? signInError.code}',
      );
    }
  } catch (e) {
    throw Exception('Failed to ensure account "$email": $e');
  }
}

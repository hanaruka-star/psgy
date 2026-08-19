import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_link/firebase_options.dart';

import 'seed_data.dart';
import 'seed_staff.dart';

const forceSeed = bool.fromEnvironment('FORCE_SEED');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  if (forceSeed) {
    debugPrint('[seed] FORCE_SEED=true -> clearing parking_lots.');
    await _clearParkingLots(firestore);
    await seedToFirestore();
  } else if (await _hasParkingLots(firestore)) {
    debugPrint('[seed] parking_lots already has data -> skip lot seeding.');
  } else {
    await seedToFirestore();
  }

  await seedStaffAccounts();
  debugPrint('[seed] Firestore and staff auth seed completed successfully.');
}

Future<bool> _hasParkingLots(FirebaseFirestore firestore) async {
  final lotsSnapshot =
      await firestore.collection('parking_lots').limit(1).get();
  return lotsSnapshot.docs.isNotEmpty;
}

Future<void> _clearParkingLots(FirebaseFirestore firestore) async {
  final lotsCollection = firestore.collection('parking_lots');
  final lotsSnapshot = await lotsCollection.get();

  for (final lotDoc in lotsSnapshot.docs) {
    final lotRef = lotsCollection.doc(lotDoc.id);
    await _deleteCollection(lotRef.collection('vehicle_types'));
    await _deleteCollection(lotRef.collection('slots'));
    await lotRef.delete();
  }
}

Future<void> _deleteCollection(CollectionReference collection) async {
  const batchSize = 450;

  while (true) {
    final snapshot = await collection.limit(batchSize).get();
    if (snapshot.docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

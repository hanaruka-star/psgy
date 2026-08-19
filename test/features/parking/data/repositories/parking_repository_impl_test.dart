// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psgy/features/parking/data/repositories/parking_repository_impl.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockTransaction extends Mock implements Transaction {}

Future<void> _fakeTransactionHandler(Transaction _) async {}

void main() {
  setUpAll(() {
    registerFallbackValue(_fakeTransactionHandler);
    registerFallbackValue(Duration.zero);
  });

  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockLotsCollection;
  late MockCollectionReference mockSlotsCollection;
  late MockCollectionReference mockVehicleTypesCollection;
  late MockCollectionReference mockManualAdjustmentsCollection;
  late MockCollectionReference mockSessionsCollection;
  late MockDocumentReference mockLotDocRef;
  late MockDocumentReference mockSlotDocRef;
  late MockDocumentReference mockVehicleTypeDocRef;
  late MockDocumentReference mockManualAdjustmentDocRef;
  late MockDocumentReference mockSessionDocRef;
  late MockQuerySnapshot mockSessionQuerySnapshot;
  late MockTransaction mockTransaction;
  late ParkingRepositoryImpl repository;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockLotsCollection = MockCollectionReference();
    mockSlotsCollection = MockCollectionReference();
    mockVehicleTypesCollection = MockCollectionReference();
    mockManualAdjustmentsCollection = MockCollectionReference();
    mockSessionsCollection = MockCollectionReference();
    mockLotDocRef = MockDocumentReference();
    mockSlotDocRef = MockDocumentReference();
    mockVehicleTypeDocRef = MockDocumentReference();
    mockManualAdjustmentDocRef = MockDocumentReference();
    mockSessionDocRef = MockDocumentReference();
    mockSessionQuerySnapshot = MockQuerySnapshot();
    mockTransaction = MockTransaction();
    repository = ParkingRepositoryImpl(mockFirestore);

    when(() => mockFirestore.collection('parking_lots'))
        .thenReturn(mockLotsCollection);
    when(() => mockFirestore.collection('parking_sessions'))
        .thenReturn(mockSessionsCollection);
    when(() => mockLotsCollection.doc(any())).thenReturn(mockLotDocRef);
    when(() => mockLotDocRef.collection('slots'))
        .thenReturn(mockSlotsCollection);
    when(() => mockLotDocRef.collection('vehicle_types'))
        .thenReturn(mockVehicleTypesCollection);
    when(() => mockLotDocRef.collection('manual_adjustments'))
        .thenReturn(mockManualAdjustmentsCollection);
    when(() => mockSlotsCollection.doc(any())).thenReturn(mockSlotDocRef);
    when(() => mockVehicleTypesCollection.doc(any()))
        .thenReturn(mockVehicleTypeDocRef);
    when(() => mockManualAdjustmentsCollection.doc())
        .thenReturn(mockManualAdjustmentDocRef);
    when(() => mockSessionsCollection.doc()).thenReturn(mockSessionDocRef);
    when(() => mockSessionsCollection.doc(any())).thenReturn(mockSessionDocRef);
    when(
      () => mockSessionsCollection.where(
        'lotId',
        isEqualTo: any(named: 'isEqualTo'),
      ),
    ).thenReturn(mockSessionsCollection);
    when(
      () => mockSessionsCollection.where(
        'vehiclePlate',
        isEqualTo: any(named: 'isEqualTo'),
      ),
    ).thenReturn(mockSessionsCollection);
    when(
      () => mockSessionsCollection.where(
        'status',
        isEqualTo: any(named: 'isEqualTo'),
      ),
    ).thenReturn(mockSessionsCollection);
    when(() => mockSessionsCollection.limit(1)).thenReturn(mockSessionsCollection);
    when(() => mockSessionsCollection.get())
        .thenAnswer((_) async => mockSessionQuerySnapshot);
    when(() => mockSessionQuerySnapshot.docs).thenReturn([]);
    when(() => mockManualAdjustmentDocRef.id).thenReturn('adjustment_1');
    when(() => mockSessionDocRef.id).thenReturn('session_1');
  });

  void stubRunTransaction() {
    when(() => mockFirestore.runTransaction<Null>(any()))
        .thenAnswer((invocation) {
      final handler =
          invocation.positionalArguments.first as TransactionHandler<Null>;
      return handler(mockTransaction);
    });
    when(() => mockFirestore.runTransaction<void>(any()))
        .thenAnswer((invocation) {
      final handler =
          invocation.positionalArguments.first as TransactionHandler<void>;
      return handler(mockTransaction);
    });
    when(() => mockFirestore.runTransaction<dynamic>(any()))
        .thenAnswer((invocation) {
      final handler =
          invocation.positionalArguments.first as TransactionHandler<dynamic>;
      return handler(mockTransaction);
    });
  }

  group('watchAllLots()', () {
    test(
      'returns stream of ParkingLotEntity list when firestore has data',
      () async {
        final mockSnapshot = MockQuerySnapshot();
        final mockDoc = MockQueryDocumentSnapshot();
        final createdAt = Timestamp.now();

        when(() => mockLotsCollection.snapshots())
            .thenAnswer((_) => Stream.value(mockSnapshot));
        when(() => mockSnapshot.docs).thenReturn([mockDoc]);
        when(() => mockDoc.id).thenReturn('lot_a');
        when(() => mockDoc.data()).thenReturn({
          'id': 'lot_a',
          'name': 'Bai A',
          'address': 'Q1',
          'lat': 10.77,
          'lng': 106.70,
          'status': 'open',
          'ownerId': 'owner_1',
          'createdAt': createdAt,
          'updatedAt': createdAt,
        });

        final result = await repository.watchAllLots().first;

        expect(result, hasLength(1));
        expect(result.first.id, 'lot_a');
        expect(result.first.name, 'Bai A');
        expect(result.first.ownerId, 'owner_1');
      },
    );

    test('returns empty list when collection is empty', () async {
      final mockSnapshot = MockQuerySnapshot();

      when(() => mockLotsCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));
      when(() => mockSnapshot.docs).thenReturn([]);

      final result = await repository.watchAllLots().first;

      expect(result, isEmpty);
    });
  });

  group('watchLot()', () {
    test('returns ParkingLotEntity when doc exists', () async {
      final mockDoc = MockDocumentSnapshot();
      final createdAt = Timestamp.now();

      when(() => mockLotDocRef.snapshots())
          .thenAnswer((_) => Stream.value(mockDoc));
      when(() => mockDoc.exists).thenReturn(true);
      when(() => mockDoc.id).thenReturn('lot_b');
      when(() => mockDoc.data()).thenReturn({
        'id': 'lot_b',
        'name': 'Bai B',
        'address': 'Q3',
        'lat': 10.78,
        'lng': 106.68,
        'status': 'open',
        'ownerId': 'owner_2',
        'createdAt': createdAt,
        'updatedAt': createdAt,
      });

      final result = await repository.watchLot('lot_b').first;

      expect(result.id, 'lot_b');
      expect(result.name, 'Bai B');
    });

    test('throws Exception when doc does not exist', () async {
      final mockDoc = MockDocumentSnapshot();

      when(() => mockLotDocRef.snapshots())
          .thenAnswer((_) => Stream.value(mockDoc));
      when(() => mockDoc.exists).thenReturn(false);

      await expectLater(
        repository.watchLot('not_found'),
        emitsError(isA<Exception>()),
      );
    });
  });

  group('checkIn()', () {
    test('completes successfully when vehicle type has available slots',
        () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data())
          .thenReturn({'availableSlots': 1});
      when(() => mockTransaction.set<Map<String, dynamic>>(
            mockSessionDocRef,
            any(),
          )).thenReturn(mockTransaction);
      when(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .thenReturn(mockTransaction);

      await expectLater(
        repository.checkIn(
          lotId: 'lot_a',
          vehicleType: 'car',
          vehiclePlate: '59A-12345',
          staffId: 'staff_1',
        ),
        completes,
      );

      verify(() => mockTransaction.set<Map<String, dynamic>>(
            mockSessionDocRef,
            any(),
          )).called(1);
      verify(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .called(1);
    });

    test('throws Exception when vehicle type has no available slots', () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data())
          .thenReturn({'availableSlots': 0});

      await expectLater(
        repository.checkIn(
          lotId: 'lot_a',
          vehicleType: 'car',
          vehiclePlate: '59A-12345',
          staffId: 'staff_1',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws Exception when duplicate active session already exists',
        () async {
      final mockExistingSessionDoc = MockQueryDocumentSnapshot();
      when(() => mockSessionQuerySnapshot.docs).thenReturn([mockExistingSessionDoc]);

      await expectLater(
        repository.checkIn(
          lotId: 'lot_a',
          vehicleType: 'car',
          vehiclePlate: '59A-12345',
          staffId: 'staff_1',
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Xe 59A-12345 đang trong bãi'),
          ),
        ),
      );
    });

    test('completes when repository receives an empty vehiclePlate', () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data())
          .thenReturn({'availableSlots': 1});
      when(() => mockTransaction.set<Map<String, dynamic>>(
            mockSessionDocRef,
            any(),
          )).thenReturn(mockTransaction);
      when(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .thenReturn(mockTransaction);

      await expectLater(
        repository.checkIn(
          lotId: 'lot_a',
          vehicleType: 'moto',
          vehiclePlate: '',
          staffId: 'staff_1',
        ),
        completes,
      );
    });
  });

  group('checkOut()', () {
    test('completes successfully when session is active', () async {
      final mockSessionSnapshot = MockDocumentSnapshot();
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockSessionDocRef))
          .thenAnswer((_) async => mockSessionSnapshot);
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockSessionSnapshot.exists).thenReturn(true);
      when(() => mockSessionSnapshot.data()).thenReturn({
        'lotId': 'lot_a',
        'vehicleType': 'car',
        'status': 'active',
      });
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data()).thenReturn({
        'availableSlots': 2,
        'totalSlots': 10,
      });
      when(() => mockTransaction.update(mockSessionDocRef, any()))
          .thenReturn(mockTransaction);
      when(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .thenReturn(mockTransaction);

      await expectLater(
        repository.checkOut(
          lotId: 'lot_a',
          sessionId: 'session_1',
          vehicleType: 'car',
          staffId: 'staff_1',
        ),
        completes,
      );

      verify(() => mockTransaction.update(mockSessionDocRef, any())).called(1);
      verify(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .called(1);
    });

    test('throws Exception when session is not active', () async {
      final mockSessionSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockSessionDocRef))
          .thenAnswer((_) async => mockSessionSnapshot);
      when(() => mockSessionSnapshot.exists).thenReturn(true);
      when(() => mockSessionSnapshot.data()).thenReturn({
        'lotId': 'lot_a',
        'vehicleType': 'moto',
        'status': 'completed',
      });

      await expectLater(
        repository.checkOut(
          lotId: 'lot_a',
          sessionId: 'session_1',
          vehicleType: 'moto',
          staffId: 'staff_1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('manualAdjust()', () {
    test('increments available slots and appends audit log', () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data()).thenReturn({
        'availableSlots': 4,
        'totalSlots': 10,
      });
      when(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .thenReturn(mockTransaction);
      when(() => mockTransaction.set<Map<String, dynamic>>(
            mockManualAdjustmentDocRef,
            any(),
          )).thenReturn(mockTransaction);

      await expectLater(
        repository.manualAdjust(
          lotId: 'lot_a',
          vehicleType: 'car',
          delta: 1,
          staffId: 'staff_1',
          reason: 'Xe ra ngoài hệ thống',
        ),
        completes,
      );

      verify(() => mockTransaction.update(mockVehicleTypeDocRef, any()))
          .called(1);
      verify(() => mockTransaction.set<Map<String, dynamic>>(
            mockManualAdjustmentDocRef,
            any(),
          )).called(1);
    });

    test('throws when decrementing with no available slots', () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data()).thenReturn({
        'availableSlots': 0,
        'totalSlots': 10,
      });

      await expectLater(
        repository.manualAdjust(
          lotId: 'lot_a',
          vehicleType: 'moto',
          delta: -1,
          staffId: 'staff_1',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when incrementing at total slots', () async {
      final mockVehicleTypeSnapshot = MockDocumentSnapshot();

      stubRunTransaction();
      when(() => mockTransaction.get(mockVehicleTypeDocRef))
          .thenAnswer((_) async => mockVehicleTypeSnapshot);
      when(() => mockVehicleTypeSnapshot.exists).thenReturn(true);
      when(() => mockVehicleTypeSnapshot.data()).thenReturn({
        'availableSlots': 10,
        'totalSlots': 10,
      });

      await expectLater(
        repository.manualAdjust(
          lotId: 'lot_a',
          vehicleType: 'car',
          delta: 1,
          staffId: 'staff_1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

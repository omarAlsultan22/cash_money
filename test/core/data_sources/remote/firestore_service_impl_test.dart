import 'package:cash_money/core/data/data_sources/remote/firestore_service_impl.dart';
import 'package:cash_money/core/domain/data_sources/firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreServiceImpl(firestore: fakeFirestore);
  });

  group('setData', () {
    test('writes data to the correct document', () async {
      await service.setData(
        docId: 'user-1',
        collectionPath: 'users',
        data: {'name': 'Ali', 'age': 25},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.exists, true);
      expect(snapshot.data(), {'name': 'Ali', 'age': 25});
    });

    test('overwrites existing document', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Old', 'age': 20});

      await service.setData(
        docId: 'user-1',
        collectionPath: 'users',
        data: {'name': 'New'},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.data(), {'name': 'New'}); // 'age' اختفى (set يستبدل)
    });
  });

  group('getDocument', () {
    test('returns the document snapshot when it exists', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali'});

      final snapshot = await service.getDocument(
        docId: 'user-1',
        collectionPath: 'users',
      );

      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Ali');
    });

    test('returns non-existing snapshot when document is missing', () async {
      final snapshot = await service.getDocument(
        docId: 'missing',
        collectionPath: 'users',
      );

      expect(snapshot.exists, false);
      expect(snapshot.data(), isNull);
    });

    test('handles null docId (document with null id)', () async {
      // ملاحظة: Firestore يرفض docId == null عادةً، لكن الكود يسمح به.
      // هذا الاختبار يوثق السلوك الفعلي.
      expect(
            () => service.getDocument(docId: null, collectionPath: 'users'),
        throwsA(anything),
      );
    });
  });

  group('getCollection', () {
    test('returns a Query for the correct subcollection path', () async {
      // نضع بيانات في المسار المتوقع
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .collection('posts')
          .doc('post-1')
          .set({'title': 'Hello'});

      final query = service.getCollection(
        docId: 'user-1',
        superCollectionPath: 'users',
        subCollectionPath: 'posts',
      );

      final result = await query.get();
      expect(result.docs.length, 1);
      expect(result.docs.first.data()['title'], 'Hello');
    });

    test('returns empty query when subcollection has no documents', () async {
      final query = service.getCollection(
        docId: 'user-1',
        superCollectionPath: 'users',
        subCollectionPath: 'posts',
      );

      final result = await query.get();
      expect(result.docs, isEmpty);
    });

    test('does not touch supercollection documents', () async {
      // نضع مستنداً في المستوى الأعلى
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali'});

      final query = service.getCollection(
        docId: 'user-1',
        superCollectionPath: 'users',
        subCollectionPath: 'posts',
      );

      final result = await query.get();
      // لا نرى مستند 'user-1' نفسه — فقط subcollection
      expect(result.docs, isEmpty);
    });
  });

  group('updateDocument', () {
    test('updates existing document fields', () async {
      await fakeFirestore
          .collection('users')
          .doc('user-1')
          .set({'name': 'Ali', 'age': 25});

      await service.updateDocument(
        docId: 'user-1',
        collectionPath: 'users',
        data: {'age': 26},
      );

      final snapshot =
      await fakeFirestore.collection('users').doc('user-1').get();
      expect(snapshot.data()?['name'], 'Ali'); // لم يتغير
      expect(snapshot.data()?['age'], 26); // تغير
    });

    test('throws when document does not exist', () async {
      expect(
            () =>
            service.updateDocument(
              docId: 'missing',
              collectionPath: 'users',
              data: {'name': 'X'},
            ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
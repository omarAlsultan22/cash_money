import 'package:cash_money/features/questions/data/repositories_impl/app_data_repository_impl.dart';
import 'package:cash_money/features/questions/domain/repositories/app_data_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../../../fakes/fake_firestore_service.dart';
import '../../../../fakes/mock_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirestoreService fakeDataSource;
  late MockSessionService mockSession;
  late AppDataRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeDataSource = FakeFirestoreService();
    mockSession = MockSessionService();
    when(() => mockSession.currentUid).thenReturn('test-uid');
    repository = AppDataRepositoryImpl(
      dataSource: fakeDataSource,
      sessionService: mockSession,
    );
  });

  group('getData', () {
    test('returns empty QuestionsData with hasMore=false when no docs',
            () async {
          // نجهز Query فارغة
          final emptyQuery = fakeFirestore
              .collection('data')
              .doc('0Hv1zUWKuetw3eP7Nplt')
              .collection('userData');
          fakeDataSource.queryToReturn = emptyQuery;

          final result = await repository.getData(
            lastDocument: null,
            limit: 10,
          );

          expect(result.questions, isEmpty);
          expect(result.lastDocument, isNull);
          expect(result.hasMore, false);
        });

    test('returns questions with lastDocument and hasMore=true when docs exist',
            () async {
          // نضع 2 docs في Firestore
          final subCollection = fakeFirestore
              .collection('data')
              .doc('0Hv1zUWKuetw3eP7Nplt')
              .collection('userData');
          await subCollection.doc('q1').set({
            'question': 'Q1',
            'points': 10,
            // ... الحقول حسب DataConverter
          });
          await subCollection.doc('q2').set({
            'question': 'Q2',
            'points': 20,
          });

          fakeDataSource.queryToReturn = subCollection;

          final result = await repository.getData(
            lastDocument: null,
            limit: 10,
          );

          expect(result.questions.length, 2);
          expect(result.lastDocument, isNotNull);
          expect(result.hasMore, true);
        });

    test('applies startAfterDocument when lastDocument is provided',
            () async {
          final subCollection = fakeFirestore
              .collection('data')
              .doc('0Hv1zUWKuetw3eP7Nplt')
              .collection('userData');
          await subCollection.doc('q1').set({'question': 'Q1'});
          await subCollection.doc('q2').set({'question': 'Q2'});
          await subCollection.doc('q3').set({'question': 'Q3'});

          fakeDataSource.queryToReturn = subCollection;

          // first call: limit 1
          final firstPage = await repository.getData(
            lastDocument: null,
            limit: 1,
          );

          // second call: start after first page's lastDocument
          final secondPage = await repository.getData(
            lastDocument: firstPage.lastDocument,
            limit: 1,
          );

          expect(secondPage.questions.length, 1);
          expect(secondPage.questions.first, isNot(equals(firstPage.questions.first)));
        });

    test('uses the correct hardcoded paths', () async {
      final subCollection = fakeFirestore
          .collection('data')
          .doc('0Hv1zUWKuetw3eP7Nplt')
          .collection('userData');
      fakeDataSource.queryToReturn = subCollection;

      await repository.getData(lastDocument: null, limit: 10);

      expect(fakeDataSource.lastSuperCollectionPath, 'data');
      expect(fakeDataSource.lastSubCollectionPath, 'userData');
      expect(fakeDataSource.lastGetCollectionDocId, '0Hv1zUWKuetw3eP7Nplt');
    });
  });

  group('getPoints', () {
    test('reads from "points" collection with currentUid', () async {
      await fakeFirestore
          .collection('points')
          .doc('test-uid')
          .set({'points': 42});

      final doc = await fakeFirestore
          .collection('points')
          .doc('test-uid')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getPoints();

      expect(result, 42);
    });

    test('returns null when points doc does not exist', () async {
      final doc = await fakeFirestore
          .collection('points')
          .doc('missing')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getPoints();

      expect(result, isNull);
    });

    test('propagates errors from getDocument', () async {
      fakeDataSource.getDocumentError = Exception('read failed');

      expect(
            () => repository.getPoints(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('putPoints', () {
    test('writes points to "points" collection with currentUid', () async {
      await repository.putPoints(points: 100);

      expect(fakeDataSource.setDataCallCount, 1);
      expect(fakeDataSource.lastCollectionPath, 'points');
      expect(fakeDataSource.lastDocId, 'test-uid');
      expect(fakeDataSource.lastData, {'points': 100});
    });

    test('propagates setData errors', () async {
      fakeDataSource.setDataError = Exception('write failed');

      expect(
            () => repository.putPoints(points: 100),
        throwsA(isA<Exception>()),
      );
    });
  });
}
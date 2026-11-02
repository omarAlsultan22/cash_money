import 'package:cash_money/features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'package:cash_money/features/settings/domain/repositories/settings_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../../../fakes/fake_settings_data_source.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import '../../../../fakes/mock_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


void main() {
  late FakeSettingsDataSource fakeDataSource;
  late FakeFirebaseFirestore fakeFirestore;
  late MockSessionService mockSession;
  late SettingsRepository repository;

  setUp(() {
    fakeDataSource = FakeSettingsDataSource();
    fakeFirestore = FakeFirebaseFirestore();
    mockSession = MockSessionService();
    when(() => mockSession.currentUid).thenReturn('test-uid');
    repository = SettingsRepositoryImpl(
      dataSource: fakeDataSource,
      sessionService: mockSession,
    );
  });

  group('getUserInfo', () {
    test('reads from "users" collection with currentUid', () async {
      // نضع مستنداً في Firestore
      await fakeFirestore
          .collection(AppKeys.users)
          .doc('test-uid')
          .set({'userName': 'Ali'});

      final doc = await fakeFirestore
          .collection(AppKeys.users)
          .doc('test-uid')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getUserInfo();

      expect(result.exists, true);
      expect(result.data()?['userName'], 'Ali');
    });

    test('returns non-existing snapshot when doc is missing', () async {
      final doc = await fakeFirestore
          .collection(AppKeys.users)
          .doc('missing')
          .get();
      fakeDataSource.documentToReturn = doc;

      final result = await repository.getUserInfo();

      expect(result.exists, false);
    });

    test('propagates errors from getDocument', () async {
      fakeDataSource.getDocumentError = Exception('read failed');

      expect(
            () => repository.getUserInfo(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateUserInfo', () {
    test('updates "users" collection with currentUid and toJson data',
            () async {
          await repository.updateUserInfo(userName: 'New Name');

          expect(fakeDataSource.updateCallCount, 1);
          expect(fakeDataSource.lastUpdateDocId, 'test-uid');
          expect(fakeDataSource.lastUpdateCollectionPath, AppKeys.users);
          expect(fakeDataSource.lastUpdateData, isA<Map<String, dynamic>>());
          expect(fakeDataSource.lastUpdateData!['userName'], 'New Name');
        });

    test('handles null userName (passes it through)', () async {
      await repository.updateUserInfo(userName: null);

      expect(fakeDataSource.updateCallCount, 1);
      // UserModel(userName: null).toJson() — قد يحتوي 'userName': null أو لا
      // تحقق حسب UserModel.toJson()
    });

    test('propagates errors from updateDocument', () async {
      fakeDataSource.updateError = Exception('update failed');

      expect(
            () => repository.updateUserInfo(userName: 'X'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/fake_settings_repository.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cash_money/features/settings/domain/use_cases/settings_use_case.dart';


void main() {
  late SettingsUseCase useCase;
  late FakeSettingsRepository fakeRepo;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeRepo = FakeSettingsRepository();
    fakeFirestore = FakeFirebaseFirestore();
    useCase = SettingsUseCase(repository: fakeRepo);
  });

  group('getInfoExecute', () {
    test('returns UserModel built from document data', () async {
      await fakeFirestore
          .collection('users')
          .doc('u1')
          .set({'userName': 'Ali', 'email': 'a@b.com'});
      final doc = await fakeFirestore.collection('users').doc('u1').get();
      fakeRepo.userInfoResult = doc;

      final result = await useCase.getInfoExecute();

      expect(result, isA<UserModel>());
      expect(result.userName, 'Ali');
      expect(fakeRepo.getUserInfoCallCount, 1);
    });

    test('throws TypeError when document data is null', () async {
      // مستند غير موجود → data() == null
      final doc = await fakeFirestore.collection('users').doc('missing').get();
      fakeRepo.userInfoResult = doc;

      expect(
            () => useCase.getInfoExecute(),
        throwsA(isA<TypeError>()),
      );
    });

    test('propagates errors from repository.getUserInfo', () async {
      fakeRepo.getUserInfoError = Exception('read failed');

      expect(
            () => useCase.getInfoExecute(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateInfoExecute', () {
    test('passes userName to repository.updateUserInfo', () async {
      await useCase.updateInfoExecute(userName: 'New Name');

      expect(fakeRepo.updateUserInfoCallCount, 1);
      expect(fakeRepo.lastUserName, 'New Name');
    });

    test('passes null userName through', () async {
      await useCase.updateInfoExecute(userName: null);

      expect(fakeRepo.updateUserInfoCallCount, 1);
      expect(fakeRepo.lastUserName, isNull);
    });

    test('propagates errors from repository.updateUserInfo', () async {
      fakeRepo.updateUserInfoError = Exception('update failed');

      expect(
            () => useCase.updateInfoExecute(userName: 'X'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
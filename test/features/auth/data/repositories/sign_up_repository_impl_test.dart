import 'package:mocktail/mocktail.dart';
import '../../../../fakes/mock_user_credential.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../fakes/fake_firestore_service.dart';
import 'package:cash_money/core/constants/app_keys.dart';
import 'package:cash_money/core/data/models/user_model.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cash_money/features/auth/domain/repositories/sign_up_repository.dart';
import 'package:cash_money/features/auth/data/repositories_impl/sign_up_repository_impl.dart';


void main() {
  late SignUpRepository repository;
  late FakeFirestoreService fakeService;

  final mockUser = MockUser(uid: 'uid-123', email: 'a@b.com');
  final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);

  final userModel = UserModel(
    userName: 'Ali',
  );

  late UserCredential validCredential;

  setUp(() async {
    fakeService = FakeFirestoreService();
    repository = SignUpRepositoryImpl(service: fakeService);

    validCredential = await mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com',
      password: 'password123',
    );
  });

  group('createUserInfo', () {
    test('calls setData with correct collection, docId, and data', () async {
      await repository.createUserInfo(
        userModel: userModel,
        userCredential: validCredential,
      );

      expect(fakeService.setDataCallCount, 1);
      expect(fakeService.lastCollectionPath, AppKeys.users);
      expect(fakeService.lastDocId, 'uid-123');
      expect(fakeService.lastData, userModel.toJson());
    });

    test('uses userCredential.user.uid as docId', () async {
      final customUser = MockUser(uid: 'custom-uid-999');
      final customAuth = MockFirebaseAuth(mockUser: customUser, signedIn: true);
      final customCredential = await customAuth.signInWithEmailAndPassword(
        email: 'x@y.com',
        password: 'p',
      );

      await repository.createUserInfo(
        userModel: userModel,
        userCredential: customCredential,
      );

      expect(fakeService.lastDocId, 'custom-uid-999');
    });

    test('throws TypeError when userCredential.user is null', () async {
      final emptyCredential = MockUserCredential();
      when(() => emptyCredential.user).thenReturn(null);

      expect(
            () => repository.createUserInfo(
          userModel: userModel,
          userCredential: emptyCredential,
        ),
        throwsA(isA<TypeError>()),  // ← لأن user! على null
      );

      // setData لم تُستدعَ
      expect(fakeService.setDataCallCount, 0);
    });

    test('propagates setData errors', () async {
      fakeService.setDataError = Exception('firestore write failed');

      expect(
            () => repository.createUserInfo(
          userModel: userModel,
          userCredential: validCredential,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('serializes UserModel via toJson', () async {
      await repository.createUserInfo(
        userModel: userModel,
        userCredential: validCredential,
      );

      // نتحقق أن lastData يحتوي حقول UserModel
      expect(fakeService.lastData, isA<Map<String, dynamic>>());
      expect(fakeService.lastData!['name'], 'Ali');
      expect(fakeService.lastData!['email'], 'a@b.com');
    });
  });
}
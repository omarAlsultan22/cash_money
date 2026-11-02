import '../../../../fakes/mock_user_credential.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../fakes/fake_cache_helper.dart';
import '../../../../fakes/fake_auth_repository.dart';
import '../../../../fakes/fake_sign_up_repository.dart';
import 'package:cash_money/features/auth/domain/use_cases/sign_up_use_case.dart';


void main() {
  late FakeSignUpRepository fakeSignUp;
  late FakeAuthRepository fakeAuth;
  late FakeCacheHelper fakeCache;
  late SignUpUseCase useCase;

  late UserCredential credential;

  setUp(() {
    fakeAuth = FakeAuthRepository();
    fakeSignUp = FakeSignUpRepository();
    fakeCache = FakeCacheHelper();
    useCase = SignUpUseCase(
      authRepository: fakeAuth,
      signUpRepository: fakeSignUp,
      cacheHelper: fakeCache,
    );

    credential = MockUserCredential();
  });

  group('execute', () {
    test('passes credentials to authRepository.signUp', () async {
      fakeAuth.signUpResult = credential;

      await useCase.execute(
        userName: 'Ali',
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(fakeAuth.signUpCallCount, 1);
      expect(fakeAuth.lastSignUpEmail, 'a@b.com');
      expect(fakeAuth.lastSignUpPassword, 'password123');
    });

    test('creates UserModel with the given userName', () async {
      fakeAuth.signUpResult = credential;

      await useCase.execute(
        userName: 'Ali',
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(fakeSignUp.createUserInfoCallCount, 1);
      expect(fakeSignUp.lastUserModel?.userName, 'Ali');
      expect(fakeSignUp.lastUserCredential, same(credential));
    });

    test('saves userName to cache after createUserInfo', () async {
      fakeAuth.signUpResult = credential;

      await useCase.execute(
        userName: 'Ali',
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(await fakeCache.getString(key: 'userName'), 'Ali');
    });

    test('saves userName even when createUserInfo fails (whenComplete)',
            () async {
          fakeAuth.signUpResult = credential;
          fakeSignUp.createUserInfoError = Exception('firestore failed');

          expect(
                () => useCase.execute(
              userName: 'Ali',
              userEmail: 'a@b.com',
              userPassword: 'password123',
            ),
            throwsA(isA<Exception>()),
          );

          // setString عملت رغم فشل createUserInfo (whenComplete)
          expect(await fakeCache.getString(key: 'userName'), 'Ali');
        });

    test('does not call createUserInfo when signUp fails', () async {
      fakeAuth.signUpError = FirebaseAuthException(code: 'email-already-in-use');

      expect(
            () => useCase.execute(
          userName: 'Ali',
          userEmail: 'a@b.com',
          userPassword: 'password123',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      expect(fakeSignUp.createUserInfoCallCount, 0);
      // cache لم يُكتب
      expect(await fakeCache.getString(key: 'userName'), isNull);
    });
  });
}
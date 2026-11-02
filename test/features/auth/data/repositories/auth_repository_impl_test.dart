import 'package:cash_money/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:cash_money/features/auth/domain/repositories/auth_repository.dart';
import 'package:cash_money/core/errors/exceptions/base/app_exception.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../fakes/fake_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/mock_user_credential.dart';
import 'package:mocktail/mocktail.dart';


class MockActionCodeSettings extends Mock implements ActionCodeSettings {}

void main() {
  late FakeAuthService fakeService;
  late AuthRepository repository;

  final mockUser = MockUser(uid: 'uid-1', email: 'a@b.com'); // firebase_auth_mocks
  final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);

  late UserCredential validCredential;

  setUp(() async {
    fakeService = FakeAuthService();
    repository = AuthRepositoryImpl(service: fakeService);

    validCredential = await mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com',
      password: 'password123',
    );
  });

  setUpAll(() {
    registerFallbackValue(MockActionCodeSettings());
  });

  group('signIn', () {
    test('returns UserCredential when user is not null', () async {
      fakeService.signInResult = validCredential;

      final result = await repository.signIn(
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(result.user, isNotNull);
      expect(result.user!.uid, 'uid-1');
      expect(fakeService.signInCallCount, 1);
      expect(fakeService.lastSignInEmail, 'a@b.com');
      expect(fakeService.lastSignInPassword, 'password123');
    });

    test('throws AuthException when user is null', () async {
      final emptyCredential = MockUserCredential();
      when(() => emptyCredential.user).thenReturn(null);
      fakeService.signInResult = emptyCredential;

      expect(
            () => repository.signIn(
          userEmail: 'a@b.com',
          userPassword: 'p',
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('propagates AuthService errors', () async {
      fakeService.signInError = FirebaseAuthException(code: 'wrong-password');

      expect(
            () => repository.signIn(userEmail: 'a@b.com', userPassword: 'p'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('signUp', () {
    test('returns UserCredential from AuthService', () async {
      fakeService.signUpResult = validCredential;

      final result = await repository.signUp(
        userEmail: 'new@b.com',
        userPassword: 'p',
      );

      expect(result.user!.uid, 'uid-1');
      expect(fakeService.signUpCallCount, 1);
    });

    test('propagates AuthService errors', () async {
      fakeService.signUpError =
          FirebaseAuthException(code: 'email-already-in-use');

      expect(
            () => repository.signUp(userEmail: 'a@b.com', userPassword: 'p'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('updateProfile', () {
    test('returns updated User', () async {
      final updatedUser = MockUser(uid: 'uid-1', email: 'new@b.com');
      fakeService.updateProfileResult = updatedUser;

      final result = await repository.updateProfile(
        newEmail: 'new@b.com',
        currentPassword: 'old',
        newPassword: 'new',
      );

      expect(result, updatedUser);
    });

    test('returns null when AuthService returns null', () async {
      fakeService.updateProfileResult = null;

      final result = await repository.updateProfile(
        newEmail: 'new@b.com',
        currentPassword: 'old',
        newPassword: 'new',
      );

      expect(result, isNull);
    });
  });

  group('sendPasswordResetEmail', () {
    test('passes email and actionCodeSettings to AuthService', () async {
      final settings = MockActionCodeSettings();

      await repository.sendPasswordResetEmail(
        userEmail: 'a@b.com',
        actionCodeSettings: settings,
      );

      expect(fakeService.sendResetEmailCallCount, 1);
      expect(fakeService.lastResetEmail, 'a@b.com');
      expect(fakeService.lastActionCodeSettings, settings);
    });

    test('propagates AuthService errors', () async {
      fakeService.sendResetEmailError =
          FirebaseAuthException(code: 'user-not-found');

      expect(
            () => repository.sendPasswordResetEmail(
          userEmail: 'a@b.com',
          actionCodeSettings: MockActionCodeSettings(),
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });
}
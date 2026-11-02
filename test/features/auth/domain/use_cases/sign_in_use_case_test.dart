import 'package:mocktail/mocktail.dart';
import '../../../../fakes/mock_user_credential.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../fakes/fake_auth_repository.dart';
import '../../../../fakes/mock_session_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cash_money/features/auth/domain/use_cases/sign_in_use_case.dart';


void main() {
  late MockSessionService mockSession;
  late FakeAuthRepository fakeRepo;
  late SignInUseCase useCase;

  setUp(() {
    fakeRepo = FakeAuthRepository();
    mockSession = MockSessionService();
    useCase = SignInUseCase(
      authRepository: fakeRepo,
      sessionService: mockSession,
    );
  });

  group('execute', () {
    test('passes credentials to authRepository.signIn', () async {
      final credential = MockUserCredential();
      final mockUser = MockUser(uid: 'uid-123');
      when(() => credential.user).thenReturn(mockUser);
      fakeRepo.signInResult = credential;

      when(() => mockSession.login(any())).thenAnswer((_) async {});

      await useCase.execute(
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(fakeRepo.signInCallCount, 1);
      expect(fakeRepo.lastSignInEmail, 'a@b.com');
      expect(fakeRepo.lastSignInPassword, 'password123');
    });

    test('calls sessionService.login with the user uid', () async {
      final credential = MockUserCredential();
      final mockUser = MockUser(uid: 'uid-456');
      when(() => credential.user).thenReturn(mockUser);
      fakeRepo.signInResult = credential;

      String? capturedUid;
      when(() => mockSession.login(any())).thenAnswer((invocation) async {
        capturedUid = invocation.positionalArguments[0] as String;
      });

      await useCase.execute(
        userEmail: 'a@b.com',
        userPassword: 'password123',
      );

      expect(capturedUid, 'uid-456');
    });

    test('throws when userCredential.user is null', () async {
      final credential = MockUserCredential();
      when(() => credential.user).thenReturn(null);
      fakeRepo.signInResult = credential;

      expect(
            () => useCase.execute(
          userEmail: 'a@b.com',
          userPassword: 'password123',
        ),
        throwsA(isA<TypeError>()),  // ← user! على null
      );

      // login لم تُستدعَ
      verifyNever(() => mockSession.login(any()));
    });

    test('propagates errors from authRepository.signIn', () async {
      fakeRepo.signInError = FirebaseAuthException(code: 'wrong-password');

      expect(
            () => useCase.execute(
          userEmail: 'a@b.com',
          userPassword: 'wrong',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );

      // login لم تُستدعَ
      verifyNever(() => mockSession.login(any()));
    });
  });
}
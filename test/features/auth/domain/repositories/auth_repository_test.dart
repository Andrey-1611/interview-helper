import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  const password = 'testPassword';
  final testUser = MyUser(email: email, name: name, id: id);

  final emailVerifiedResult = EmailVerificationResult(
    isEmailVerified: true,
    user: testUser,
  );
  final emailNotVerifiedResult = EmailVerificationResult(
    isEmailVerified: false,
    user: testUser,
  );

  group('auth repository', () {
    test('sign in', () async {
      when(
        () => mockRepository.signIn(any(), password),
      ).thenAnswer((_) async => testUser);

      final user = await mockRepository.signIn(testUser, password);

      verify(() => mockRepository.signIn(any(), password)).called(1);
      expect(user, testUser);
    });

    test('change password', () async {
      when(
        () => mockRepository.changePassword(any()),
      ).thenAnswer((_) async => {});

      await mockRepository.changePassword(testUser);

      verify(() => mockRepository.changePassword(any())).called(1);
    });

    group('get user', () {
      test('user exists', () async {
        when(() => mockRepository.getUser()).thenAnswer((_) async => testUser);

        final user = await mockRepository.getUser();

        verify(() => mockRepository.getUser()).called(1);
        expect(user, testUser);
      });

      test('user not exists', () async {
        when(() => mockRepository.getUser()).thenAnswer((_) async => null);

        final user = await mockRepository.getUser();

        verify(() => mockRepository.getUser()).called(1);
        expect(user, null);
      });
    });

    test('sign up', () async {
      when(
        () => mockRepository.signUp(any(), password),
      ).thenAnswer((_) async => testUser);

      final user = await mockRepository.signUp(testUser, password);

      verify(() => mockRepository.signUp(any(), password)).called(1);
      expect(user, testUser);
    });

    test('send email verification', () async {
      when(
        () => mockRepository.sendEmailVerification(),
      ).thenAnswer((_) async => {});

      await mockRepository.sendEmailVerification();

      verify(() => mockRepository.sendEmailVerification()).called(1);
    });

    group('check email verified', () {
      test('email verified', () async {
        when(
          () => mockRepository.checkEmailVerified(),
        ).thenAnswer((_) async => emailVerifiedResult);

        final result = await mockRepository.checkEmailVerified();

        verify(() => mockRepository.checkEmailVerified()).called(1);
        expect(result, emailVerifiedResult);
      });

      test('email not verified', () async {
        when(
          () => mockRepository.checkEmailVerified(),
        ).thenAnswer((_) async => emailNotVerifiedResult);

        final result = await mockRepository.checkEmailVerified();

        verify(() => mockRepository.checkEmailVerified()).called(1);
        expect(result, emailNotVerifiedResult);
      });
    });

    test('watch email verified', () async {
      when(
        () => mockRepository.watchEmailVerified(),
      ).thenAnswer((_) async => emailVerifiedResult);

      final result = await mockRepository.watchEmailVerified();

      verify(() => mockRepository.watchEmailVerified()).called(1);
      expect(result, emailVerifiedResult);
    });

    test('delete account', () async {
      when(() => mockRepository.deleteAccount()).thenAnswer((_) async => {});

      await mockRepository.deleteAccount();

      verify(() => mockRepository.deleteAccount()).called(1);
    });

    test('sign out', () async {
      when(() => mockRepository.signOut()).thenAnswer((_) async => {});

      await mockRepository.signOut();

      verify(() => mockRepository.signOut()).called(1);
    });
  });
}

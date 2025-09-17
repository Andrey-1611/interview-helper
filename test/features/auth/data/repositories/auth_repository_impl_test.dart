import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/data/models/my_user.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late AuthRepositoryImpl mockRepositoryImpl;
  late FirebaseAuthDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockDataSource = MockFirebaseAuthDataSource();
    mockRepositoryImpl = AuthRepositoryImpl(mockDataSource);
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

  group('auth repository impl', () {
    test('sign in', () async {
      when(
        () => mockDataSource.signIn(any(), password),
      ).thenAnswer((_) async => testUser);

      final user = await mockRepositoryImpl.signIn(testUser, password);

      verify(() => mockDataSource.signIn(any(), password)).called(1);
      expect(user, testUser);
    });

    test('change password', () async {
      when(
        () => mockDataSource.changePassword(any()),
      ).thenAnswer((_) async => {});

      await mockRepositoryImpl.changePassword(testUser);

      verify(() => mockDataSource.changePassword(any())).called(1);
    });

    group('get user', () {
      test('user exists', () async {
        when(
          () => mockDataSource.getUser(),
        ).thenAnswer((_) async => testUser);

        final user = await mockRepositoryImpl.getUser();

        verify(() => mockDataSource.getUser()).called(1);
        expect(user, testUser);
      });

      test('user not exists', () async {
        when(() => mockDataSource.getUser()).thenAnswer((_) async => null);

        final user = await mockRepositoryImpl.getUser();

        verify(() => mockDataSource.getUser()).called(1);
        expect(user, null);
      });
    });

    test('sign up', () async {
      when(
        () => mockDataSource.signUp(any(), password),
      ).thenAnswer((_) async => testUser);

      final user = await mockRepositoryImpl.signUp(testUser, password);

      verify(() => mockDataSource.signUp(any(), password)).called(1);
      expect(user, testUser);
    });

    test('send email verification', () async {
      when(
        () => mockDataSource.sendEmailVerification(),
      ).thenAnswer((_) async => {});

      await mockRepositoryImpl.sendEmailVerification();

      verify(() => mockDataSource.sendEmailVerification()).called(1);
    });

    group('check email verified', () {
      test('email verified', () async {
        when(
          () => mockDataSource.checkEmailVerified(),
        ).thenAnswer((_) async => emailVerifiedResult);

        final result = await mockRepositoryImpl.checkEmailVerified();

        verify(() => mockDataSource.checkEmailVerified()).called(1);
        expect(result, emailVerifiedResult);
      });

      test('email not verified', () async {
        when(
          () => mockDataSource.checkEmailVerified(),
        ).thenAnswer((_) async => emailNotVerifiedResult);

        final result = await mockRepositoryImpl.checkEmailVerified();

        verify(() => mockDataSource.checkEmailVerified()).called(1);
        expect(result, emailNotVerifiedResult);
      });
    });

    test('watch email verified', () async {
      when(
        () => mockDataSource.watchEmailVerified(),
      ).thenAnswer((_) async => emailVerifiedResult);

      final result = await mockRepositoryImpl.watchEmailVerified();

      verify(() => mockDataSource.watchEmailVerified()).called(1);
      expect(result, emailVerifiedResult);
    });

    test('delete account', () async {
      when(
        () => mockDataSource.deleteAccount(),
      ).thenAnswer((_) async => {});

      await mockRepositoryImpl.deleteAccount();

      verify(() => mockDataSource.deleteAccount()).called(1);
    });

    test('sign out', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async => {});

      await mockRepositoryImpl.signOut();

      verify(() => mockDataSource.signOut()).called(1);
    });
  });
}

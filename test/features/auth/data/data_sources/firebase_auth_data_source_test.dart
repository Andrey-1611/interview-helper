import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/data/models/my_user.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late FirebaseAuth mockFirebaseAuth;
  late User mockUser;
  late UserCredential mockUserCredential;
  late FirebaseAuthDataSource dataSource;

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

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    dataSource = FirebaseAuthDataSource(mockFirebaseAuth);

    when(() => mockUser.email).thenReturn(email);
    when(() => mockUser.displayName).thenReturn(name);
    when(() => mockUser.uid).thenReturn(id);
    when(() => mockUser.reload()).thenAnswer((_) async => {});

    when(() => mockUserCredential.user).thenReturn(mockUser);
  });

  group('firebase auth data source', () {
    test('sign in', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      final user = await dataSource.signIn(testUser, password);

      expect(user, testUser);
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
    });

    group('get user', () {
      test('user exists', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final user = await dataSource.getUser();

        expect(user, testUser);
        verify(() => mockFirebaseAuth.currentUser).called(2);
        verify(() => mockUser.reload()).called(1);
      });

      test('user not exists', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final user = await dataSource.getUser();

        expect(user, isNull);
        verify(() => mockFirebaseAuth.currentUser).called(2);
        verifyNever(() => mockFirebaseAuth.currentUser?.reload());
      });
    });

    test('sign up', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUser.updateDisplayName(name)).thenAnswer((_) async => {});
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final user = await dataSource.signUp(testUser, password);

      expect(user, testUser);
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(() => mockUser.updateDisplayName(name)).called(1);
      verify(() => mockFirebaseAuth.currentUser).called(1);
      verify(() => mockUser.reload()).called(1);
    });

    group('send email verification', () {
      test('email verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(true);

        await dataSource.sendEmailVerification();

        verify(() => mockFirebaseAuth.currentUser).called(1);
        verifyNever(() => mockUser.sendEmailVerification());
      });

      test('email not verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
        when(() => mockUser.emailVerified).thenReturn(false);

        await dataSource.sendEmailVerification();

        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockUser.sendEmailVerification()).called(1);
      });
    });

    group('check email verification', () {
      test('email verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(true);

        final result = await dataSource.checkEmailVerified();

        expect(result, emailVerifiedResult);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });

      test('email not verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(false);

        final result = await dataSource.checkEmailVerified();

        expect(result, emailNotVerifiedResult);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });
    });

    test('watch email verified', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(true);

      final result = await dataSource.watchEmailVerified();

      expect(result, emailVerifiedResult);
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('change password', () async {
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) async => {});

      await dataSource.changePassword(testUser);

      verify(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
      ).called(1);
    });

    test('sign out', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      await dataSource.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('delete account', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.delete()).thenAnswer((_) async => {});

      await dataSource.deleteAccount();

      verify(() => mockUser.delete()).called(1);
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/repositories/auth_repository/auth_data_source.dart';
import 'package:mocktail/mocktail.dart';
import '../../tests_data.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late FirebaseAuth mockFirebaseAuth;
  late User mockUser;
  late UserCredential mockUserCredential;
  late FirebaseAuthDataSource dataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    dataSource = FirebaseAuthDataSource(mockFirebaseAuth);

    when(() => mockUser.email).thenReturn(TestsData.email);
    when(() => mockUser.displayName).thenReturn(TestsData.name);
    when(() => mockUser.uid).thenReturn(TestsData.id);
    when(() => mockUser.reload()).thenAnswer((_) async => {});

    when(() => mockUserCredential.user).thenReturn(mockUser);
  });

  group('firebase auth data source', () {
    test('sign in', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: TestsData.email,
          password: TestsData.password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      final user = await dataSource.signIn(TestsData.user, TestsData.password);

      expect(user, TestsData.user);
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: TestsData.email,
          password: TestsData.password,
        ),
      ).called(1);
    });

    group('get user', () {
      test('user exists', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final user = await dataSource.getUser();

        expect(user, TestsData.user);
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
          email: TestsData.email,
          password: TestsData.password,
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(
        () => mockUser.updateDisplayName(TestsData.name),
      ).thenAnswer((_) async => {});
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final user = await dataSource.signUp(TestsData.user, TestsData.password);

      expect(user, TestsData.user);
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: TestsData.email,
          password: TestsData.password,
        ),
      ).called(1);
      verify(() => mockUser.updateDisplayName(TestsData.name)).called(1);
      verify(() => mockFirebaseAuth.currentUser).called(1);
      verify(() => mockUser.reload()).called(1);
    });

    group('send email verification', () {
      test('email verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(TestsData.emailVerified);

        await dataSource.sendEmailVerification();

        verify(() => mockFirebaseAuth.currentUser).called(1);
        verifyNever(() => mockUser.sendEmailVerification());
      });

      test('email not verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
        when(
          () => mockUser.emailVerified,
        ).thenReturn(TestsData.emailNotVerified);

        await dataSource.sendEmailVerification();

        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockUser.sendEmailVerification()).called(1);
      });
    });

    group('check email verification', () {
      test('email verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(TestsData.emailVerified);

        final result = await dataSource.checkEmailVerified();

        expect(result, TestsData.emailVerified);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });

      test('email not verified', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(
          () => mockUser.emailVerified,
        ).thenReturn(TestsData.emailNotVerified);

        final result = await dataSource.checkEmailVerified();

        expect(result, TestsData.emailNotVerified);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      });
    });

    test('watch email verified', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(TestsData.emailVerified);

      final result = await dataSource.watchEmailVerified();

      expect(result, TestsData.emailVerified);
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('change password', () async {
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: TestsData.email),
      ).thenAnswer((_) async => {});

      await dataSource.changePassword(TestsData.user);

      verify(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: TestsData.email),
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

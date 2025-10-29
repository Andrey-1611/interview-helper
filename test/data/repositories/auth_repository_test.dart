import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/data/repositories/auth_repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../tests_data.dart';

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

  group('auth repository', () {
    test('sign in', () async {
      when(
        () => mockRepository.signIn(any(), TestsData.password),
      ).thenAnswer((_) async => TestsData.user);

      final user = await mockRepository.signIn(
        TestsData.user,
        TestsData.password,
      );

      verify(() => mockRepository.signIn(any(), TestsData.password)).called(1);
      expect(user, TestsData.user);
    });

    test('change password', () async {
      when(
        () => mockRepository.changePassword(any()),
      ).thenAnswer((_) async => {});

      await mockRepository.changePassword(TestsData.user);

      verify(() => mockRepository.changePassword(any())).called(1);
    });

    group('get user', () {
      test('user exists', () async {
        when(
          () => mockRepository.getUser(),
        ).thenAnswer((_) async => TestsData.user);

        final user = await mockRepository.getUser();

        verify(() => mockRepository.getUser()).called(1);
        expect(user, TestsData.user);
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
        () => mockRepository.signUp(any(), TestsData.password),
      ).thenAnswer((_) async => TestsData.user);

      final user = await mockRepository.signUp(
        TestsData.user,
        TestsData.password,
      );

      verify(() => mockRepository.signUp(any(), TestsData.password)).called(1);
      expect(user, TestsData.user);
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
        ).thenAnswer((_) async => TestsData.emailVerified);

        final result = await mockRepository.checkEmailVerified();

        verify(() => mockRepository.checkEmailVerified()).called(1);
        expect(result, TestsData.emailVerified);
      });

      test('email not verified', () async {
        when(
          () => mockRepository.checkEmailVerified(),
        ).thenAnswer((_) async => TestsData.emailNotVerified);

        final result = await mockRepository.checkEmailVerified();

        verify(() => mockRepository.checkEmailVerified()).called(1);
        expect(result, TestsData.emailNotVerified);
      });
    });

    test('watch email verified', () async {
      when(
        () => mockRepository.watchEmailVerified(),
      ).thenAnswer((_) async => TestsData.emailVerified);

      final result = await mockRepository.watchEmailVerified();

      verify(() => mockRepository.watchEmailVerified()).called(1);
      expect(result, TestsData.emailVerified);
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

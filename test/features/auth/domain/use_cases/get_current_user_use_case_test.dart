import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late GetCurrentUserUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';
  final testUser = MyUser(email: email, name: name);
  final emailVerifiedResult = EmailVerificationResult(
    isEmailVerified: true,
    user: testUser,
  );
  final emailNotVerifiedResult = EmailVerificationResult(
    isEmailVerified: false,
    user: testUser,
  );

  group('get current user use case', () {
    test('user not exists', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => null);

      await useCase.call();

      verify(() => mockRepository.getUser()).called(1);
    });

    test('user exists and email verified', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => testUser);
      when(
        () => mockRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailVerifiedResult);

      await useCase.call();

      verify(() => mockRepository.getUser()).called(1);
      verify(() => mockRepository.checkEmailVerified()).called(1);
    });

    test('user exists, but email not verified', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => testUser);
      when(
        () => mockRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailNotVerifiedResult);
      when(() => mockRepository.signOut()).thenAnswer((_) async => {});

      await useCase.call();

      verify(() => mockRepository.getUser()).called(1);
      verify(() => mockRepository.checkEmailVerified()).called(1);
      verify(() => mockRepository.signOut()).called(1);
    });
  });
}

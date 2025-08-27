import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late SignInUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';
  const password = 'testPassword';
  final testUser = MyUser(email: email, name: name);
  final emailVerifiedResult = EmailVerificationResult(
    isEmailVerified: true,
    user: testUser,
  );
  final emailNotVerifiedResult = EmailVerificationResult(
    isEmailVerified: false,
    user: testUser,
  );

  group('sign in use case', () {
    test('email verified', () async {
      when(
        () => mockRepository.signIn(any(), password),
      ).thenAnswer((_) async => testUser);
      when(
        () => mockRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailVerifiedResult);

      final user = await useCase.call(testUser, password);

      verify(
        () => mockRepository.signIn(
          any(
            that: isA<MyUser>()
                .having((e) => e.email, 'email', email)
                .having((e) => e.name, 'name', name),
          ),
          password,
        ),
      ).called(1);
      verify(() => mockRepository.checkEmailVerified()).called(1);
      expect(user, testUser);
    });

    test('email not verified', () async {
      when(
        () => mockRepository.signIn(any(), password),
      ).thenAnswer((_) async => testUser);
      when(
        () => mockRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailNotVerifiedResult);
      when(
        () => mockRepository.sendEmailVerification(),
      ).thenAnswer((_) async => {});

      final user = await useCase.call(testUser, password);

      verify(
        () => mockRepository.signIn(
          any(
            that: isA<MyUser>()
                .having((e) => e.email, 'email', email)
                .having((e) => e.name, 'name', name),
          ),
          password
        ),
      ).called(1);
      verify(() => mockRepository.checkEmailVerified()).called(1);
      verify(() => mockRepository.sendEmailVerification()).called(1);
      expect(user, null);
    });
  });
}

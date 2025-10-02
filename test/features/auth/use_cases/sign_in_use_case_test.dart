import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:interview_master/features/interview/data/models/interview_data.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late SignInUseCase useCase;
  late AuthRepository mockAuthRepository;
  late RemoteRepository mockRemoteRepository;
  late LocalRepository mockLocalRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockRemoteRepository = MockRemoteRepository();
    mockLocalRepository = MockLocalRepository();
    useCase = SignInUseCase(
      mockAuthRepository,
      mockRemoteRepository,
      mockLocalRepository,
    );
  });

  const email = 'testEmail';
  const name = 'testName';
  const password = 'testPassword';
  const id = 'testId'
;  final testUser = MyUser(email: email, name: name, id: id);
  final emailVerifiedResult = EmailVerificationResult(
    isEmailVerified: true,
    userBox: testUser,
  );
  final emailNotVerifiedResult = EmailVerificationResult(
    isEmailVerified: false,
    userBox: testUser,
  );

  final interviews = <Interview>[];

  group('sign in use case', () {
    test('email verified', () async {
      when(
        () => mockAuthRepository.signIn(any(), password),
      ).thenAnswer((_) async => testUser);
      when(
        () => mockAuthRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailVerifiedResult);
      when(
            () => mockRemoteRepository.showInterviews(id),
      ).thenAnswer((_) async => interviews);
      when(
            () => mockLocalRepository.loadInterviews(interviews),
      ).thenAnswer((_) async => {});

      final user = await useCase.call(testUser, password);

      verify(
        () => mockAuthRepository.signIn(
          any(
            that: isA<MyUser>()
                .having((e) => e.email, 'email', email)
                .having((e) => e.name, 'name', name),
          ),
          password,
        ),
      ).called(1);
      verify(() => mockAuthRepository.checkEmailVerified()).called(1);
      verify(() => mockRemoteRepository.showInterviews(id)).called(1);
      verify(() => mockLocalRepository.loadInterviews(interviews)).called(1);
      expect(user, testUser);
    });

    test('email not verified', () async {
      when(
        () => mockAuthRepository.signIn(any(), password),
      ).thenAnswer((_) async => testUser);
      when(
        () => mockAuthRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailNotVerifiedResult);
      when(
        () => mockAuthRepository.sendEmailVerification(),
      ).thenAnswer((_) async => {});

      final user = await useCase.call(testUser, password);

      verify(
        () => mockAuthRepository.signIn(
          any(
            that: isA<MyUser>()
                .having((e) => e.email, 'email', email)
                .having((e) => e.name, 'name', name),
          ),
          password,
        ),
      ).called(1);
      verify(() => mockAuthRepository.checkEmailVerified()).called(1);
      verify(() => mockAuthRepository.sendEmailVerification()).called(1);
      expect(user, null);
    });
  });
}

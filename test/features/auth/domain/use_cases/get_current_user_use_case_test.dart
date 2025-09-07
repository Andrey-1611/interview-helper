import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/use_cases/get_current_user_use_case.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late GetCurrentUserUseCase useCase;
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
    useCase = GetCurrentUserUseCase(
      mockAuthRepository,
      mockRemoteRepository,
      mockLocalRepository,
    );
  });

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, id: id);
  final emailVerifiedResult = EmailVerificationResult(
    isEmailVerified: true,
    user: testUser,
  );
  final emailNotVerifiedResult = EmailVerificationResult(
    isEmailVerified: false,
    user: testUser,
  );

  final interviews = <Interview>[];

  group('get current user use case', () {
    test('user not exists', () async {
      when(() => mockAuthRepository.getUser()).thenAnswer((_) async => null);

      await useCase.call();

      verify(() => mockAuthRepository.getUser()).called(1);
    });

    test('user exists and email verified', () async {
      when(
        () => mockAuthRepository.getUser(),
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

      await useCase.call();

      verify(() => mockAuthRepository.getUser()).called(1);
      verify(() => mockRemoteRepository.showInterviews(id)).called(1);
      verify(() => mockLocalRepository.loadInterviews(interviews)).called(1);
      verify(() => mockAuthRepository.checkEmailVerified()).called(1);
    });

    test('user exists, but email not verified', () async {
      when(
        () => mockAuthRepository.getUser(),
      ).thenAnswer((_) async => testUser);
      when(
        () => mockAuthRepository.checkEmailVerified(),
      ).thenAnswer((_) async => emailNotVerifiedResult);
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async => {});

      await useCase.call();

      verify(() => mockAuthRepository.getUser()).called(1);
      verify(() => mockAuthRepository.checkEmailVerified()).called(1);
      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });
}

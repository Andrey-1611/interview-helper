import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MyUserFake extends Fake implements UserData {}

void main() {
  late WatchEmailVerifiedUseCase useCase;
  late AuthRepository mockAuthRepository;
  late RemoteRepository mockRemoteRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockRemoteRepository = MockRemoteRepository();
    useCase = WatchEmailVerifiedUseCase(
      mockAuthRepository,
      mockRemoteRepository,
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

  test('watch email verified use case', () async {
    when(
      () => mockAuthRepository.watchEmailVerified(),
    ).thenAnswer((_) async => emailVerifiedResult);
    when(
          () => mockRemoteRepository.saveUser(any()),
    ).thenAnswer((_) async => {});

    final user = await useCase.call();

    verify(() => mockAuthRepository.watchEmailVerified()).called(1);
    verify(
      () => mockRemoteRepository.saveUser(
        any(
          that: isA<UserData>()
              .having((e) => e.name, 'name', name)
        ),
      ),
    ).called(1);
    expect(user, testUser);
  });
}

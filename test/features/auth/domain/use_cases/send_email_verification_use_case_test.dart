import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/send_email_verification_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late SendEmailVerificationUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendEmailVerificationUseCase(mockRepository);
  });

  test('send email verification use case', () async {
    when(
      () => mockRepository.sendEmailVerification(),
    ).thenAnswer((_) async => {});

    await useCase.call();

    verify(() => mockRepository.sendEmailVerification()).called(1);
  });
}

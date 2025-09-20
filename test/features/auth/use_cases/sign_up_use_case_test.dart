import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late SignUpUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';
  const password = 'testPassword';
  final testUser = MyUser(email: email, name: name);

  test('sign up use case', () async {
    when(
      () => mockRepository.signUp(any(), password),
    ).thenAnswer((_) async => testUser);
    when(
          () => mockRepository.sendEmailVerification(),
    ).thenAnswer((_) async => {});

    final user = await useCase.call(testUser, password);

    verify(
      () => mockRepository.signUp(
        any(
          that: isA<MyUser>()
              .having((e) => e.email, 'email', email)
              .having((e) => e.name, 'name', name),
        ),
        password,
      ),
    ).called(1);
    verify(() => mockRepository.sendEmailVerification()).called(1);
    expect(user, testUser);
  });
}

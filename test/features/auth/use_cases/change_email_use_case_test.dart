import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_email_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late ChangeEmailUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ChangeEmailUseCase(mockRepository);
  });

  const oldEmail = 'testOldEmail';
  const newEmail = 'testNewEmail';
  const password = 'testPassword';
  const name = 'testName';

  final testOldUser = MyUser(email: oldEmail, name: name);
  final testNewUser = MyUser(email: newEmail, name: name);

  test('change email use case', () async {
    when(() => mockRepository.getUser()).thenAnswer((_) async => testOldUser);
    when(() => mockRepository.deleteAccount()).thenAnswer((_) async => {});
    when(
      () => mockRepository.signUp(any(), any()),
    ).thenAnswer((_) async => testNewUser);
    when(
      () => mockRepository.sendEmailVerification(),
    ).thenAnswer((_) async => {});

    await useCase.call(newEmail, password);

    verify(() => mockRepository.getUser()).called(1);
    verify(() => mockRepository.deleteAccount()).called(1);
    verify(
      () => mockRepository.signUp(
        any(
          that: isA<MyUser>()
              .having((e) => e.email, 'email', newEmail)
              .having((e) => e.name, 'name', name),
        ),
        password,
      ),
    ).called(1);
    verify(() => mockRepository.sendEmailVerification()).called(1);
  });
}

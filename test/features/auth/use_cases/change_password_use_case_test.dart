import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late ChangePasswordUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ChangePasswordUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';
  final testUser = MyUser(email: email, name: name);

  test('change password use case', () async {
    when(
      () => mockRepository.changePassword(any()),
    ).thenAnswer((_) async => {});

    await useCase.call(testUser);

    verify(
      () => mockRepository.changePassword(
        any(
          that: isA<MyUser>()
              .having((e) => e.email, 'email', email)
              .having((e) => e.name, 'name', name),
        ),
      ),
    ).called(1);
  });
}

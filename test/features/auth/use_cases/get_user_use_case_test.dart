import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth.dart';
import 'package:interview_master/features/users/use_cases/get_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late GetUserUseCase useCase;
  late AuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';

  final testUser = MyUser(email: email, name: name);

  group('get user use case', () {
    test('user exists', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => testUser);

      final user = await useCase.call();

      verify(() => mockRepository.getUser()).called(1);
      expect(user, testUser);
    });

    test('user not exists', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => null);

      final user = await useCase.call();

      verify(() => mockRepository.getUser()).called(1);
      expect(user, null);
    });
  });
}

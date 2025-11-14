import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class FakeMyUser extends Fake implements MyUser {}

void main() {
  late SignInUseCase useCase;
  late SignInBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMyUser());
  });

  setUp(() {
    useCase = MockSignInUseCase();
    mockBloc = SignInBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  const password = 'testPassword';
  final testUser = MyUser(email: email, name: name, profile: id);

  group('sign in bloc', () {
    test('initial state', () {
      expect(mockBloc.state, SignInInitial());
    });

    blocTest<SignInBloc, SignInState>(
      'sign in',
      setUp: () {
        when(
          () => useCase.call(any(), password),
        ).thenAnswer((_) async => testUser);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(SignIn(userBox: testUser, password: password)),
      expect: () => <SignInState>[
        SignInLoading(),
        SignInSuccess(userBox: testUser),
      ],
      verify: (_) {
        verify(() => useCase.call(any(), password)).called(1);
      },
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class FakeMyUser extends Fake implements MyUser {}

void main() {
  late SignUpUseCase useCase;
  late SignUpBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMyUser());
  });

  setUp(() {
    useCase = MockSignUpUseCase();
    mockBloc = SignUpBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  const password = 'testPassword';
  final testUser = MyUser(email: email, name: name, id: id);

  group('sign up bloc', () {
    test('initial state', () {
      expect(mockBloc.state, SignUpInitial());
    });

    blocTest<SignUpBloc, SignUpState>(
      'sign up',
      setUp: () {
        when(
          () => useCase.call(any(), password),
        ).thenAnswer((_) async => testUser);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(SignUp(myUser: testUser, password: password)),
      expect: () => <SignUpState>[
        SignUpLoading(),
        SignUpSuccess(user: testUser),
      ],
      verify: (_) {
        verify(() => useCase.call(any(), password)).called(1);
      },
    );
  });
}

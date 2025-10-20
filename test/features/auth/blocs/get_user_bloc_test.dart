import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/users/use_cases/get_user_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/get_user_bloc/get_user_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

void main() {
  late GetUserUseCase useCase;
  late GetUserBloc mockBloc;

  setUp(() {
    useCase = MockGetUserUseCase();
    mockBloc = GetUserBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, user: id);

  group('get user bloc', () {
    test('initial state', () {
      expect(mockBloc.state, GetUserInitial());
    });

    group('get user', () {
      blocTest<GetUserBloc, GetUserState>(
        'user exists',
        setUp: () {
          when(() => useCase.call()).thenAnswer((_) async => testUser);
        },
        build: () => mockBloc,
        act: (bloc) => bloc.add(GetUser()),
        expect: () => <GetUserState>[
          GetUserLoading(),
          GetUserSuccess(userBox: testUser),
        ],
        verify: (_) {
          verify(() => useCase.call()).called(1);
        },
      );

      blocTest<GetUserBloc, GetUserState>(
        'user not exists',
        setUp: () {
          when(() => useCase.call()).thenAnswer((_) async => null);
        },
        build: () => mockBloc,
        act: (bloc) => bloc.add(GetUser()),
        expect: () => <GetUserState>[GetUserLoading(), GetUserNotAuth()],
        verify: (_) {
          verify(() => useCase.call()).called(1);
        },
      );
    });
  });
}

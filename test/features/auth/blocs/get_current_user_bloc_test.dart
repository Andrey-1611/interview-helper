import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/home/use_cases/get_current_user_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/get_current_user_bloc/get_current_user_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}


void main() {
  late GetCurrentUserUseCase useCase;
  late GetCurrentUserBloc mockBloc;

  setUp(() {
    useCase = MockGetCurrentUserUseCase();
    mockBloc = GetCurrentUserBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, user: id);

  group('get current user bloc', () {
    test('initial state', () {
      expect(mockBloc.state, GetCurrentUserInitial());
    });

    group('get current user', () {
      blocTest<GetCurrentUserBloc, GetCurrentUserState>(
        'user exists',
        setUp: () {
          when(() => useCase.call()).thenAnswer((_) async => testUser);
        },
        build: () => mockBloc,
        act: (bloc) => bloc.add(GetCurrentUser()),
        expect: () => <GetCurrentUserState>[
          GetCurrentUserLoading(),
          GetCurrentUserSuccess(userBox: testUser),
        ],
        verify: (_) {
          verify(() => useCase.call()).called(1);
        },
      );

      blocTest<GetCurrentUserBloc, GetCurrentUserState>(
        'user not exists',
        setUp: () {
          when(() => useCase.call()).thenAnswer((_) async => null);
        },
        build: () => mockBloc,
        act: (bloc) => bloc.add(GetCurrentUser()),
        expect: () => <GetCurrentUserState>[
          GetCurrentUserLoading(),
          GetCurrentUserNotAuth(),
        ],
        verify: (_) {
          verify(() => useCase.call()).called(1);
        },
      );
    });
  });
}

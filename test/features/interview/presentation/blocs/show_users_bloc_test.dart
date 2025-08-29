import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_users_bloc/show_users_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockShowUsersUseCase extends Mock implements ShowUsersUseCase {}

void main() {
  late ShowUsersUseCase useCase;
  late ShowUsersBloc mockBloc;

  setUp(() {
    useCase = MockShowUsersUseCase();
    mockBloc = ShowUsersBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const name = 'testName';
  const id = 'testId';
  const totalInterviews = 0;
  const totalScore = 0;
  const averageScore = 0;
  const bestScore = 0;

  final testUsers = [
    UserData(
      name: name,
      id: id,
      totalInterviews: totalInterviews,
      totalScore: totalScore,
      averageScore: averageScore,
      bestScore: bestScore,
    ),
  ];

  group('show users bloc', () {
    test('initial state', () {
      expect(mockBloc.state, ShowUsersInitial());
    });

    blocTest<ShowUsersBloc, ShowUsersState>(
      'show users',
      setUp: () {
        when(() => useCase.call()).thenAnswer((_) async => testUsers);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(ShowUsers()),
      expect: () => <ShowUsersState>[
        ShowUsersLoading(),
        ShowUsersSuccess(users: testUsers),
      ],
      verify: (_) {
        verify(() => useCase.call()).called(1);
      },
    );
  });
}

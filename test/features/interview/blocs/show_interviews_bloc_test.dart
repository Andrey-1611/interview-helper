import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/models/interview_data.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/history/use_cases/show_interviews_use_case.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_interviews_bloc/show_interviews_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockShowInterviewsUseCase extends Mock implements ShowInterviewsUseCase {}

void main() {
  late ShowInterviewsUseCase useCase;
  late ShowInterviewsBloc mockBloc;

  setUp(() {
    useCase = MockShowInterviewsUseCase();
    mockBloc = ShowInterviewsBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const id = 'testId';
  const score = 0;
  const difficulty = 'testDifficulty';
  const direction = 'testDirection';
  const questions = <Question>[];
  final date = DateTime.now();
  final interview = Interview(
    id: id,
    score: score,
    difficulty: difficulty,
    direction: direction,
    date: date,
    questions: questions,
  );
  final testInterviews = <Interview>[interview, interview];

  group('show interviews bloc', () {
    test('initial state', () {
      expect(mockBloc.state, ShowInterviewsInitial());
    });

    blocTest<ShowInterviewsBloc, ShowInterviewsState>(
      'show interviews',
      setUp: () {
        when(() => useCase.call(id)).thenAnswer((_) async => testInterviews);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(ShowInterviews(userId: id)),
      expect: () => <ShowInterviewsState>[
        ShowInterviewsLoading(),
        ShowInterviewsSuccess(interviewsBox: testInterviews),
      ],
      verify: (_) {
        verify(() => useCase.call(id)).called(1);
      },
    );
  });
}

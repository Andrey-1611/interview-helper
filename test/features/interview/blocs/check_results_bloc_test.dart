import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/models/interview_data.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/use_cases/check_results_use_case.dart';
import 'package:interview_master/features/interview/presentation/blocs/check_results_bloc/check_results_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckResultsUseCase extends Mock implements CheckResultsUseCase {}

class FakeInterviewInfo extends Fake implements InterviewInfo {}

void main() {
  late CheckResultsUseCase useCase;
  late CheckResultsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeInterviewInfo());
  });

  setUp(() {
    useCase = MockCheckResultsUseCase();
    mockBloc = CheckResultsBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const direction = 'testDirection';
  const id = 'testId';
  const difficulty = 'testDifficulty';
  const score = 0;
  final questions = <Question>[];
  final date = DateTime.now();

  final testInterviewInfo = InterviewInfo(
    direction: direction,
    difficulty: difficulty,
  );
  final testInterview = Interview(
    id: id,
    score: score,
    difficulty: difficulty,
    direction: direction,
    date: date,
    questions: questions,
  );

  group('check results bloc', () {
    test('initial state', () {
      expect(mockBloc.state, CheckResultsInitial());
    });

    blocTest<CheckResultsBloc, CheckResultsState>(
      'check results',
      setUp: () {
        when(() => useCase.call(any())).thenAnswer((_) async => testInterview);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(CheckResults(interviewInfo: testInterviewInfo)),
      expect: () => <CheckResultsState>[
        CheckResultsLoading(),
        CheckResultsSuccess(interview: testInterview),
      ],
      verify: (_) {
        verify(() => useCase.call(any())).called(1);
      },
    );
  });
}

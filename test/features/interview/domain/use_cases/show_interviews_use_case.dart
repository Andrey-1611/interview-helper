import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:interview_master/features/history/use_cases/show_interviews_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

void main() {
  late ShowInterviewsUseCase useCase;
  late RemoteRepository mockRemoteRepository;
  late MockLocalRepository mockLocalRepository;

  setUp(() {
    mockRemoteRepository = MockRemoteRepository();
    mockLocalRepository = MockLocalRepository();
    useCase = ShowInterviewsUseCase(mockRemoteRepository, mockLocalRepository);
  });

  final testId = 'testId';

  const score = 0;
  const id = 'testId';
  const difficulty = 'testDifficulty';
  const direction = 'testDirection';
  const question = 'testQuestion';
  const userAnswer = 'testUserAnswer';
  const correctAnswer = 'testCorrectAnswer';
  final questions = [
    Question(
      score: score,
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    ),
  ];
  final date = DateTime.now();
  final testInterviews = [
    Interview(
      id: id,
      score: score,
      difficulty: difficulty,
      direction: direction,
      date: date,
      questions: questions,
    ),
  ];

  group('show interviews use case', () {
    test('show remote interviews', () async {
      when(
        () => mockRemoteRepository.showInterviews(testId),
      ).thenAnswer((_) async => testInterviews);

      final interviews = await useCase.call(testId);

      verify(
        () => mockRemoteRepository.showInterviews(any(that: isA<String>())),
      ).called(1);
      expect(interviews, testInterviews);
    });

    test('show local interviews', () async {
      when(
        () => mockLocalRepository.showInterviews(),
      ).thenAnswer((_) async => testInterviews);

      final interviews = await useCase.call(null);

      verify(() => mockLocalRepository.showInterviews()).called(1);
      expect(interviews, testInterviews);
    });
  });
}

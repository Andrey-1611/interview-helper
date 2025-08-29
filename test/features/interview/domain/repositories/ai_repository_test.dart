import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAIRepository extends Mock implements AIRepository {}

class UserInputFake extends Fake implements UserInput {}

void main() {
  late AIRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserInputFake());
  });

  setUp(() {
    mockRepository = MockAIRepository();
  });

  const score = 0;
  const question = 'testQuestion';
  const userAnswer = 'testUserAnswer';
  const correctAnswer = 'testCorrectAnswer';
  const answer = 'testAnswer';

  final testQuestion = Question(
    score: score,
    question: question,
    userAnswer: userAnswer,
    correctAnswer: correctAnswer,
  );
  final testUserInput = UserInput(question: question, answer: answer);

  final testQuestions = [testQuestion, testQuestion];
  final testUserInputs = [testUserInput, testUserInput];

  group('ai repository', () {
    test('check results', () async {
      when(
        () => mockRepository.checkAnswers(any()),
      ).thenAnswer((_) async => testQuestions);

      final result = await mockRepository.checkAnswers(testUserInputs);

      verify(() => mockRepository.checkAnswers(any())).called(1);
      expect(result, testQuestions);
    });
  });
}

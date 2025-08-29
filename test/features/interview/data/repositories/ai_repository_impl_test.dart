import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/data_sources/gemini_data_source.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/data/repositories/ai_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockGeminiDataSource extends Mock implements GeminiDataSource {}

class UserInputFake extends Fake implements UserInput {}

void main() {
  late AIRepositoryImpl mockRepositoryImpl;
  late GeminiDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(UserInputFake());
  });

  setUp(() {
    mockDataSource = MockGeminiDataSource();
    mockRepositoryImpl = AIRepositoryImpl(mockDataSource);
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
        () => mockDataSource.checkAnswers(any()),
      ).thenAnswer((_) async => testQuestions);

      final result = await mockRepositoryImpl.checkAnswers(testUserInputs);

      verify(() => mockDataSource.checkAnswers(any())).called(1);
      expect(result, testQuestions);
    });
  });
}

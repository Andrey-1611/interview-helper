import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/interview/data/data_sources/gemini_data_source.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:mocktail/mocktail.dart';

class MockGemini extends Mock implements Gemini {}

void main() {
  late Gemini mockGemini;
  late GeminiDataSource dataSource;

  setUp(() {
    mockGemini = MockGemini();
    dataSource = GeminiDataSource(mockGemini);
  });

  const score = 0;
  const question = 'testQuestion';
  const userAnswer = 'testUserAnswer';
  const correctAnswer = 'testCorrectAnswer';

  final testUserInput = UserInput(question: question, answer: userAnswer);
  final testUserInputs = [testUserInput];

  final geminiResponse = {
    'evaluations': [
      {
        'score': score,
        'question': question,
        'userAnswer': userAnswer,
        'correctAnswer': correctAnswer,
      },
    ],
  };
  final jsonString = jsonEncode(geminiResponse);

  group('gemini data source', () {
    test('check results', () async {
      final candidates = Candidates(content: Content(parts: [TextPart(jsonString)]));

      when(() => mockGemini.prompt(parts: any(named: 'parts')))
          .thenAnswer((_) async => candidates);

      final result = await dataSource.checkAnswers(testUserInputs);

      verify(() => mockGemini.prompt(parts: any(named: 'parts'))).called(1);
      expect(result, isA<List<Question>>());
    });
  });
}
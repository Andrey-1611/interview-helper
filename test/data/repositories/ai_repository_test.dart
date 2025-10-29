import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/repositories/ai_repository/models/user_input.dart';
import 'package:interview_master/data/repositories/ai_repository/ai_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../tests_data.dart';

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

  group('ai repository', () {
    test('check results', () async {
      when(
        () => mockRepository.checkAnswers(any()),
      ).thenAnswer((_) async => [TestsData.questionData]);

      final result = await mockRepository.checkAnswers([TestsData.userInput]);

      verify(() => mockRepository.checkAnswers(any())).called(1);
      expect(result, [TestsData.questionData]);
    });
  });
}

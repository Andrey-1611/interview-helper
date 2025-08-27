import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_results_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockAIRepository extends Mock implements AIRepository {}

class MyUserFake extends Fake implements MyUser {}

class UserInputFake extends Fake implements UserInput {}

class InterviewFake extends Fake implements Interview {}

void main() {
  late CheckResultsUseCase useCase;
  late AuthRepository mockAuthRepository;
  late RemoteRepository mockRemoteRepository;
  late AIRepository mockAIRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
    registerFallbackValue(UserInputFake());
    registerFallbackValue(InterviewFake());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockRemoteRepository = MockRemoteRepository();
    mockAIRepository = MockAIRepository();
    useCase = CheckResultsUseCase(
      mockAIRepository,
      mockAuthRepository,
      mockRemoteRepository,
    );
  });

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, id: id);

  const direction = 'testDirection';
  const difficulty = 'testDifficulty';
  const question = 'testQuestion';
  const userAnswer = 'testUserAnswer';
  final userInputs = [UserInput(question: question, answer: userAnswer)];
  final testInterviewInfo = InterviewInfo(
    direction: direction,
    difficulty: difficulty,
    userInputs: userInputs,
  );

  const score = 0;
  const correctAnswer = 'testCorrectAnswer';
  final questions = [
    Question(
      score: score,
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    ),
  ];

  test('check results use case', () async {
    when(
      () => mockAIRepository.checkAnswers(any()),
    ).thenAnswer((_) async => questions);
    when(() => mockAuthRepository.getUser()).thenAnswer((_) async => testUser);
    when(
      () => mockRemoteRepository.addInterview(any(), testUser.id!),
    ).thenAnswer((_) async => {});

    await useCase.call(testInterviewInfo);

    verify(
      () => mockAIRepository.checkAnswers(
        any(
          that: isA<List<UserInput>>()
              .having((e) => e.first.answer, 'userAnswer', userAnswer)
              .having((e) => e.first.question, 'question', question),
        ),
      ),
    ).called(1);
    verify(() => mockAuthRepository.getUser()).called(1);
    verify(
      () => mockRemoteRepository.addInterview(
        any(
          that: isA<Interview>()
              .having((e) => e.score, 'score', score)
              .having((e) => e.direction, 'direction', direction)
              .having((e) => e.difficulty, 'difficulty', difficulty)
              .having((e) => e.questions, 'questions', questions),
        ),
        any(that: equals(testUser.id)),
      ),
    ).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth.dart';
import 'package:interview_master/features/interview/data/models/interview_data.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/domain/repositories/ai.dart';
import 'package:interview_master/features/interview/domain/repositories/local.dart';
import 'package:interview_master/features/interview/domain/repositories/remote.dart';
import 'package:interview_master/features/interview/use_cases/check_results_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockAIRepository extends Mock implements AIRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MyUserFake extends Fake implements MyUser {}

class UserInputFake extends Fake implements UserInput {}

class InterviewFake extends Fake implements Interview {}

void main() {
  late CheckResultsUseCase useCase;
  late AuthRepository mockAuthRepository;
  late RemoteRepository mockRemoteRepository;
  late AIRepository mockAIRepository;
  late LocalRepository mockLocalRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
    registerFallbackValue(UserInputFake());
    registerFallbackValue(InterviewFake());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockRemoteRepository = MockRemoteRepository();
    mockAIRepository = MockAIRepository();
    mockLocalRepository = MockLocalRepository();
    useCase = CheckResultsUseCase(
      mockAIRepository,
      mockAuthRepository,
      mockRemoteRepository,
      mockLocalRepository,
    );
  });

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, user: id);

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
      () => mockRemoteRepository.addInterview(any(), testUser.user!),
    ).thenAnswer((_) async => {});
    when(
      () => mockLocalRepository.addInterview(any()),
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
        any(that: equals(testUser.user)),
      ),
    ).called(1);
    verify(() => mockLocalRepository.addInterview(any())).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_interviews_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MyUserFake extends Fake implements MyUser {}

void main() {
  late ShowInterviewsUseCase useCase;
  late RemoteRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MyUserFake());
  });

  setUp(() {
    mockRepository = MockRemoteRepository();
    useCase = ShowInterviewsUseCase(mockRepository);
  });

  const email = 'testEmail';
  const name = 'testName';
  final id = 'testId';
  final testUser = MyUser(email: email, name: name, id: id);

  const score = 0;
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
      score: score,
      difficulty: difficulty,
      direction: direction,
      date: date,
      questions: questions,
    ),
  ];

  test('show interviews use case', () async {
    when(
      () => mockRepository.showInterviews(testUser.id!),
    ).thenAnswer((_) async => testInterviews);

    final interviews = await useCase.call(testUser.id!);

    verify(
      () => mockRepository.showInterviews(any(that: isA<String>())),
    ).called(1);
    expect(interviews, testInterviews);
  });
}

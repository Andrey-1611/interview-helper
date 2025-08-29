import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

class UserDataFake extends Fake implements UserData {}

class InterviewFake extends Fake implements Interview {}

void main() {
  late RemoteRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserDataFake());
    registerFallbackValue(InterviewFake());
  });

  setUp(() {
    mockRepository = MockRemoteRepository();
  });

  const name = 'testName';
  const id = 'testId';
  const totalInterviews = 0;
  const totalScore = 0;
  const averageScore = 0;
  const bestScore = 0;
  const score = 0;
  const difficulty = 'testDifficulty';
  const direction = 'testDirection';
  const question = 'testQuestion';
  const userAnswer = 'testUserAnswer';
  const correctAnswer = 'testCorrectAnswer';
  final date = DateTime.now();

  final testUser = UserData(
    name: name,
    id: id,
    totalInterviews: totalInterviews,
    totalScore: totalScore,
    averageScore: averageScore,
    bestScore: bestScore,
  );
  final testUsers = [testUser, testUser];
  final questions = [
    Question(
      score: score,
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    ),
  ];
  final testInterview = Interview(
    score: score,
    difficulty: difficulty,
    direction: direction,
    date: date,
    questions: questions,
  );
  final testInterviews = [testInterview, testInterview];

  group('remote repository', () {
    test('save user', () async {
      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => {});

      await mockRepository.saveUser(testUser);

      verify(() => mockRepository.saveUser(any())).called(1);
    });

    test('show users', () async {
      when(() => mockRepository.showUsers()).thenAnswer((_) async => testUsers);

      final users = await mockRepository.showUsers();

      verify(() => mockRepository.showUsers()).called(1);
      expect(users, testUsers);
    });

    test('add interview', () async {
      when(
        () => mockRepository.addInterview(any(), testUser.id),
      ).thenAnswer((_) async => {});

      await mockRepository.addInterview(testInterview, testUser.id);

      verify(() => mockRepository.addInterview(any(), testUser.id)).called(1);
    });

    test('show interviews', () async {
      when(
        () => mockRepository.showInterviews(testUser.id),
      ).thenAnswer((_) async => testInterviews);

      final interviews = await mockRepository.showInterviews(testUser.id);

      verify(() => mockRepository.showInterviews(testUser.id)).called(1);
      expect(interviews, testInterviews);
    });
  });
}

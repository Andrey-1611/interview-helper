import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreDataSource extends Mock implements FirestoreDataSource {}

class UserDataFake extends Fake implements UserData {}

class InterviewFake extends Fake implements Interview {}

void main() {
  late RemoteRepositoryImpl mockRepositoryImpl;
  late FirestoreDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(UserDataFake());
    registerFallbackValue(InterviewFake());
  });

  setUp(() {
    mockDataSource = MockFirestoreDataSource();
    mockRepositoryImpl = RemoteRepositoryImpl(mockDataSource);
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

  group('remote repository impl', () {
    test('save user', () async {
      when(() => mockDataSource.saveUser(any())).thenAnswer((_) async => {});

      await mockRepositoryImpl.saveUser(testUser);

      verify(() => mockDataSource.saveUser(any())).called(1);
    });

    test('show users', () async {
      when(() => mockDataSource.showUsers()).thenAnswer((_) async => testUsers);

      final users = await mockRepositoryImpl.showUsers();

      verify(() => mockDataSource.showUsers()).called(1);
      expect(users, testUsers);
    });

    test('add interview', () async {
      when(
            () => mockDataSource.addInterview(any(), testUser.id),
      ).thenAnswer((_) async => {});

      await mockRepositoryImpl.addInterview(testInterview, testUser.id);

      verify(() => mockDataSource.addInterview(any(), testUser.id)).called(1);
    });

    test('show interviews', () async {
      when(
            () => mockDataSource.showInterviews(testUser.id),
      ).thenAnswer((_) async => testInterviews);

      final interviews = await mockRepositoryImpl.showInterviews(testUser.id);

      verify(() => mockDataSource.showInterviews(testUser.id)).called(1);
      expect(interviews, testInterviews);
    });
  });
}

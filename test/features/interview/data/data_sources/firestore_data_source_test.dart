import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreDataSource dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = FirestoreDataSource(fakeFirestore);
  });

  final testUser = UserData(
    name: 'testName',
    id: 'testId',
    totalInterviews: 0,
    totalScore: 0,
    averageScore: 0,
    bestScore: 0,
  );

  final testInterview = Interview(
    id: 'testId',
    score: 5,
    difficulty: 'testDifficulty',
    direction: 'testDirection',
    date: DateTime.now(),
    questions: [
      Question(
        score: 5,
        question: 'testQuestion',
        userAnswer: 'testUserAnswer',
        correctAnswer: 'testCorrectAnswer',
      )
    ],
  );

  group('firestore data source', () {
    test('save user', () async {
      await dataSource.saveUser(testUser);

      final doc = await fakeFirestore.collection('users').doc(testUser.id).get();
      expect(doc.exists, isTrue);
    });

    test('show users', () async {
      await dataSource.saveUser(testUser);

      final users = await dataSource.showUsers();
      expect(users, isA<List<UserData>>());
    });

    test('add and show interviews', () async {
      await dataSource.saveUser(testUser);

      await dataSource.addInterview(testInterview, testUser.id);

      final interviews = await dataSource.showInterviews(testUser.id);

      expect(interviews, isA<List<Interview>>());
      expect(interviews.isNotEmpty, true);
    });
  });
}
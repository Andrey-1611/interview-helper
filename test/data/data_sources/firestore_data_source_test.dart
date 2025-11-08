import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/repositories/remote_repository/remote_data_source.dart';
import 'package:interview_master/data/models/interview_data.dart';
import '../../tests_data.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreDataSource dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = FirestoreDataSource(fakeFirestore);
  });

  group('firestore data source', () {
    test('save user and show users', () async {
      await dataSource.setUser(TestsData.userData);
      final users = await dataSource.getUsers();

      expect(users, [TestsData.userData]);
    });

    test('save user and get user', () async {
      await dataSource.setUser(TestsData.userData);
      final user = await dataSource.getUserData(TestsData.id);

      expect(user, TestsData.userData);
    });

    test('add interview and show interviews', () async {
      await dataSource.setUser(TestsData.userData);
      await dataSource.addInterview(
        TestsData.interviewData,
        TestsData.userData,
      );

      final interviews = await dataSource.getInterviews(TestsData.userData.id);

      expect(interviews, isA<List<InterviewData>>());
      expect(interviews.isNotEmpty, true);
    });
  });
}

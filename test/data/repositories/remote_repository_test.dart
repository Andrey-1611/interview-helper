import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/interview/interview_data.dart';
import 'package:interview_master/data/models/user/user_data.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../tests_data.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

class UserDataFake extends Fake implements UserData {}

class InterviewDataFake extends Fake implements InterviewData {}

void main() {
  late RemoteRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserDataFake());
    registerFallbackValue(InterviewDataFake());
  });

  setUp(() {
    mockRepository = MockRemoteRepository();
  });

  group('remote repository', () {
    test('save user', () async {
      when(() => mockRepository.saveUser(any())).thenAnswer((_) async => {});

      await mockRepository.saveUser(TestsData.userData);

      verify(() => mockRepository.saveUser(any())).called(1);
    });

    test('show users', () async {
      when(
        () => mockRepository.showUsers(),
      ).thenAnswer((_) async => [TestsData.userData]);

      final users = await mockRepository.showUsers();

      verify(() => mockRepository.showUsers()).called(1);
      expect(users, [TestsData.userData]);
    });

    test('add interview', () async {
      when(
        () => mockRepository.addInterview(any(),any()),
      ).thenAnswer((_) async => {});

      await mockRepository.addInterview(
        TestsData.interviewData,
        TestsData.userData,
      );

      verify(
        () => mockRepository.addInterview(any(), any()),
      ).called(1);
    });

    test('show interviews', () async {
      when(
        () => mockRepository.showInterviews(TestsData.userData.id),
      ).thenAnswer((_) async => [TestsData.interviewData]);

      final interviews = await mockRepository.showInterviews(TestsData.userData.id);

      verify(() => mockRepository.showInterviews(TestsData.userData.id)).called(1);
      expect(interviews, [TestsData.interviewData]);
    });
  });
}

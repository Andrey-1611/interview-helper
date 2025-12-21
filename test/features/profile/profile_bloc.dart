import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/features/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../tests_data.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}
class MockLocalRepository extends Mock implements LocalRepository {}
class MockNetworkInfo extends Mock implements NetworkService {}
class MockTalker extends Mock implements Talker {}

class FakeUserData extends Fake implements UserData {}
class FakeInterviewData extends Fake implements InterviewData {}

void main() {
  late MockRemoteRepository remoteRepository;
  late MockLocalRepository localRepository;
  late MockNetworkInfo networkInfo;
  late MockTalker talker;
  late ProfileBloc profileBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserData());
    registerFallbackValue(FakeInterviewData());
  });

  setUp(() {
    remoteRepository = MockRemoteRepository();
    localRepository = MockLocalRepository();
    networkInfo = MockNetworkInfo();
    talker = MockTalker();

    when(() => networkInfo.isConnected).thenAnswer((_) async => true);

    profileBloc = ProfileBloc(remoteRepository, localRepository, networkInfo, talker);
  });

  tearDown(() => profileBloc.close());

  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'GetProfile from localRepository',
      setUp: () {
        when(() => localRepository.getUser()).thenAnswer((_) async => TestsData.userData);
        when(() => localRepository.getInterviews()).thenAnswer((_) async => [TestsData.interviewData]);
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(GetProfile(userId: null)),
      expect: () => [
        ProfileLoading(),
        ProfileSuccess(user: TestsData.userData, interviews: [TestsData.interviewData]),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'GetProfile from remoteRepository',
      setUp: () {
        when(() => remoteRepository.getUserData(any())).thenAnswer((_) async => TestsData.userData);
        when(() => remoteRepository.getInterviews(any())).thenAnswer((_) async => [TestsData.interviewData]);
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(GetProfile(userId: TestsData.id)),
      expect: () => [
        ProfileLoading(),
        ProfileSuccess(user: TestsData.userData, interviews: [TestsData.interviewData]),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ChangeIsFavouriteInterview',
      setUp: () {
        when(() => localRepository.changeIsFavouriteInterview(any())).thenAnswer((_) async {});
        when(() => localRepository.getUser()).thenAnswer((_) async => TestsData.userData);
        when(() => localRepository.getInterviews()).thenAnswer((_) async => [TestsData.interviewData]);
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(ChangeIsFavouriteInterview(interviewId: TestsData.id)),
      expect: () => [
        ProfileSuccess(user: TestsData.userData, interviews: [TestsData.interviewData]),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ChangeIsFavouriteQuestion',
      setUp: () {
        when(() => localRepository.changeIsFavouriteQuestion(any())).thenAnswer((_) async {});
        when(() => localRepository.getUser()).thenAnswer((_) async => TestsData.userData);
        when(() => localRepository.getInterviews()).thenAnswer((_) async => [TestsData.interviewData]);
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(ChangeIsFavouriteQuestion(questionId: TestsData.id)),
      expect: () => [
        ProfileSuccess(user: TestsData.userData, interviews: [TestsData.interviewData]),
      ],
    );
  });
}

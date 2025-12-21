import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/core/utils/services/stopwatch_service.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/models/interview_info.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/data/repositories/ai_repository.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:interview_master/features/interview/blocs/interview_bloc/interview_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../tests_data.dart';

class MockAIRepository extends Mock implements AIRepository {}
class MockRemoteRepository extends Mock implements RemoteRepository {}
class MockLocalRepository extends Mock implements LocalRepository {}
class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockNetworkInfo extends Mock implements NetworkService {}
class MockStopwatchInfo extends Mock implements StopwatchService {}
class MockTalker extends Mock implements Talker {}
class FakeInterviewInfo extends Fake implements InterviewInfo {}
class FakeInterviewData extends Fake implements InterviewData {}
class FakeUserData extends Fake implements UserData {}

void main() {
  late MockAIRepository aiRepository;
  late MockRemoteRepository remoteRepository;
  late MockLocalRepository localRepository;
  late MockSettingsRepository settingsRepository;
  late MockNetworkInfo networkInfo;
  late MockStopwatchInfo stopwatchInfo;
  late MockTalker talker;
  late InterviewBloc interviewBloc;

  setUpAll(() {
    registerFallbackValue(FakeInterviewInfo());
    registerFallbackValue(FakeInterviewData());
    registerFallbackValue(FakeUserData());
  });

  setUp(() {
    aiRepository = MockAIRepository();
    remoteRepository = MockRemoteRepository();
    localRepository = MockLocalRepository();
    settingsRepository = MockSettingsRepository();
    networkInfo = MockNetworkInfo();
    stopwatchInfo = MockStopwatchInfo();
    talker = MockTalker();

    when(() => networkInfo.isConnected).thenAnswer((_) async => true);

    interviewBloc = InterviewBloc(
      aiRepository,
      remoteRepository,
      localRepository,
      settingsRepository,
      networkInfo,
      stopwatchInfo,
      talker,
    );
  });

  tearDown(() => interviewBloc.close());

  group('InterviewBloc', () {
    blocTest<InterviewBloc, InterviewState>(
      'StartInterview',
      setUp: () {
        when(() => localRepository.getTotalInterviewsToady())
            .thenAnswer((_) async => 5);
      },
      build: () => interviewBloc,
      act: (bloc) => bloc.add(StartInterview()),
      expect: () => [InterviewLoading(), InterviewStartSuccess()],
    );

    blocTest<InterviewBloc, InterviewState>(
      'GetQuestions',
      setUp: () {
        when(() => settingsRepository.isVoiceEnable()).thenReturn(false);
        when(() => localRepository.getInterviews()).thenAnswer((_) async => []);
      },
      build: () => interviewBloc,
      act: (bloc) => bloc.add(GetQuestions(interviewInfo: TestsData.interviewInfo)),
      expect: () => [
        InterviewLoading(),
        isA<InterviewQuestionsSuccess>(),
      ],
    );


    blocTest<InterviewBloc, InterviewState>(
      'FinishInterview',
      setUp: () {
        when(() => stopwatchInfo.stop()).thenReturn(TestsData.score);
        when(() => aiRepository.checkAnswers(any()))
            .thenAnswer((_) async => [TestsData.questionData]);
        when(() => localRepository.getUser())
            .thenAnswer((_) async => TestsData.userData);
        when(() => remoteRepository.addInterview(any(), any()))
            .thenAnswer((_) async {});
        when(() => localRepository.addInterview(any(), any()))
            .thenAnswer((_) async {});
      },
      build: () => interviewBloc,
      act: (bloc) =>
          bloc.add(FinishInterview(interviewInfo: TestsData.interviewInfo)),
      expect: () => [
        InterviewLoading(),
        InterviewFinishSuccess(interview: InterviewData.fromQuestions(
          [TestsData.questionData],
          TestsData.interviewInfo,
          TestsData.score,
        )),
      ],
    );
  });
}

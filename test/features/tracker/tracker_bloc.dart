import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/features/tracker/blocs/tracker_bloc/tracker_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../tests_data.dart';

class MockLocalRepository extends Mock implements LocalRepository {}
class MockRemoteRepository extends Mock implements RemoteRepository {}
class MockNetworkInfo extends Mock implements NetworkService {}
class MockTalker extends Mock implements Talker {}

class FakeTask extends Fake implements Task {}

void main() {
  late MockLocalRepository localRepository;
  late MockRemoteRepository remoteRepository;
  late MockNetworkInfo networkInfo;
  late MockTalker talker;
  late TrackerBloc trackerBloc;

  setUpAll(() {
    registerFallbackValue(FakeTask());
    registerFallbackValue(TestsData.userData);
  });

  setUp(() {
    localRepository = MockLocalRepository();
    remoteRepository = MockRemoteRepository();
    networkInfo = MockNetworkInfo();
    talker = MockTalker();

    trackerBloc = TrackerBloc(
      localRepository,
      remoteRepository,
      networkInfo,
      talker,
    );
  });

  tearDown(() => trackerBloc.close());

  group('TrackerBloc', () {
    blocTest<TrackerBloc, TrackerState>(
      'GetTasks',
      setUp: () {
        when(() => localRepository.getTasks())
            .thenAnswer((_) async => [TestsData.task]);
      },
      build: () => trackerBloc,
      act: (bloc) => bloc.add(GetTasks()),
      expect: () => [
        TrackerLoading(),
        TrackerSuccess(tasks: [TestsData.task]),
      ],
    );

    blocTest<TrackerBloc, TrackerState>(
      'CreateTask',
      setUp: () {
        when(() => localRepository.createTask(any())).thenAnswer((_) async {});
        when(() => localRepository.getTasks())
            .thenAnswer((_) async => [TestsData.task]);
      },
      build: () => trackerBloc,
      act: (bloc) => bloc.add(CreateTask(
        targetValue: 10,
        type: TestsData.type,
        direction: TestsData.direction,
      )),
      expect: () => [
        TrackerLoading(),
        TrackerSuccess(tasks: [TestsData.task]),
      ],
    );

    blocTest<TrackerBloc, TrackerState>(
      'DeleteTask',
      setUp: () {
        when(() => localRepository.deleteTask(any())).thenAnswer((_) async {});
        when(() => localRepository.getTasks())
            .thenAnswer((_) async => [TestsData.task]);
      },
      build: () => trackerBloc,
      act: (bloc) => bloc.add(DeleteTask(id: TestsData.id)),
      expect: () => [
        TrackerSuccess(tasks: [TestsData.task]),
      ],
    );

    blocTest<TrackerBloc, TrackerState>(
      'SetDirections',
      setUp: () {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => localRepository.getUser())
            .thenAnswer((_) async => TestsData.userData);
        when(() => localRepository.setUser(any())).thenAnswer((_) async {});
        when(() => remoteRepository.setUser(any())).thenAnswer((_) async {});
      },
      build: () => trackerBloc,
      act: (bloc) => bloc.add(SetDirections(directions: [TestsData.direction])),
      expect: () => [TrackerLoading(), TrackerDirectionsSuccess()],
    );
  });
}

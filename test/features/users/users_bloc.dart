import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/features/users/blocs/users_bloc/users_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../tests_data.dart';

class MockLocalRepository extends Mock implements LocalRepository {}
class MockRemoteRepository extends Mock implements RemoteRepository {}
class MockNetworkInfo extends Mock implements NetworkService {}
class MockTalker extends Mock implements Talker {}

class FakeUserData extends Fake implements UserData {}

void main() {
  late MockLocalRepository localRepository;
  late MockRemoteRepository remoteRepository;
  late MockNetworkInfo networkInfo;
  late MockTalker talker;
  late UsersBloc usersBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserData());
  });

  setUp(() {
    localRepository = MockLocalRepository();
    remoteRepository = MockRemoteRepository();
    networkInfo = MockNetworkInfo();
    talker = MockTalker();

    when(() => networkInfo.isConnected).thenAnswer((_) async => true);

    usersBloc = UsersBloc(
      remoteRepository,
      localRepository,
      networkInfo,
      talker,
    );
  });

  tearDown(() => usersBloc.close());

  group('UsersBloc', () {
    blocTest<UsersBloc, UsersState>(
      'GetUser returns UserSuccess',
      setUp: () {
        when(() => localRepository.getUser())
            .thenAnswer((_) async => TestsData.userData);
      },
      build: () => usersBloc,
      act: (bloc) => bloc.add(GetUser()),
      expect: () => [
        UsersLoading(),
        UserSuccess(user: TestsData.userData),
      ],
    );

    blocTest<UsersBloc, UsersState>(
      'GetUsers returns UsersSuccess',
      setUp: () {
        when(() => remoteRepository.getUsers())
            .thenAnswer((_) async => [TestsData.userData]);
        when(() => localRepository.getUser())
            .thenAnswer((_) async => TestsData.userData);
      },
      build: () => usersBloc,
      act: (bloc) => bloc.add(GetUsers()),
      expect: () => [
        UsersLoading(),
        UsersSuccess(
          users: [TestsData.userData],
          currentUser: TestsData.userData,
        ),
      ],
    );

    blocTest<UsersBloc, UsersState>(
      'GetCurrentUser returns UserSuccess when user has directions',
      setUp: () {
        when(() => localRepository.getUser())
            .thenAnswer((_) async => TestsData.userData);
      },
      build: () => usersBloc,
      act: (bloc) => bloc.add(GetCurrentUser()),
      expect: () => [
        UsersLoading(),
        UserSuccess(user: TestsData.userData),
      ],
    );
  });
}

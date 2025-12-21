import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/data/repositories/auth_repository.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:interview_master/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../tests_data.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockNetworkInfo extends Mock implements NetworkService {}

class MockTalker extends Mock implements Talker {}

class FakeUserData extends Fake implements UserData {}

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteRepository remoteRepository;
  late MockLocalRepository localRepository;
  late MockSettingsRepository settingsRepository;
  late MockNetworkInfo networkInfo;
  late MockTalker talker;
  late AuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserData());
  });

  setUp(() {
    authRepository = MockAuthRepository();
    remoteRepository = MockRemoteRepository();
    localRepository = MockLocalRepository();
    settingsRepository = MockSettingsRepository();
    networkInfo = MockNetworkInfo();
    talker = MockTalker();
    mockAuthBloc = AuthBloc(
      authRepository,
      remoteRepository,
      localRepository,
      settingsRepository,
      networkInfo,
      talker,
    );

    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  });

  tearDown(() => mockAuthBloc.close());

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'SignIn',
      setUp: () {
        when(
          () => authRepository.signIn(any(), any()),
        ).thenAnswer((_) async => TestsData.id);
        when(
          () => authRepository.checkEmailVerified(),
        ).thenAnswer((_) async => true);
        when(
          () => remoteRepository.getUserData(any()),
        ).thenAnswer((_) async => TestsData.userData);
        when(
          () => remoteRepository.getInterviews(any()),
        ).thenAnswer((_) async => [TestsData.interviewData]);
        when(
          () => remoteRepository.getTasks(any()),
        ).thenAnswer((_) async => [TestsData.task]);
        when(() => localRepository.setUser(any())).thenAnswer((_) async {});
        when(
          () => localRepository.setInterviews(any()),
        ).thenAnswer((_) async {});
        when(() => localRepository.setTasks(any())).thenAnswer((_) async {});
        when(() => settingsRepository.setAuth(true)).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(
        SignIn(email: TestsData.email, password: TestsData.password),
      ),
      expect: () => [AuthLoading(), AuthSuccess()],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInWithGoogle (new user)',
      setUp: () {
        when(
          () => authRepository.signInWithGoogle(),
        ).thenAnswer((_) async => TestsData.userData);
        when(() => remoteRepository.setUser(any())).thenAnswer((_) async {});
        when(() => localRepository.setUser(any())).thenAnswer((_) async {});
        when(() => settingsRepository.setAuth(true)).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(SignInWithGoogle()),
      expect: () => [AuthLoading(), AuthWithoutDirections()],
    );

    blocTest<AuthBloc, AuthState>(
      'SignUp',
      setUp: () {
        when(
          () => authRepository.signUp(any(), any(), any()),
        ).thenAnswer((_) async => TestsData.userData);
        when(
          () => authRepository.sendEmailVerification(),
        ).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(
        SignUp(
          name: TestsData.name,
          email: TestsData.email,
          password: TestsData.password,
        ),
      ),
      expect: () => [AuthLoading(), AuthSuccess()],
    );

    blocTest<AuthBloc, AuthState>(
      'ChangeEmail',
      setUp: () {
        when(
          () => authRepository.changeEmail(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => authRepository.sendEmailVerification(),
        ).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(
        ChangeEmail(email: TestsData.email, password: TestsData.password),
      ),
      expect: () => [AuthLoading(), AuthSuccess()],
    );

    blocTest<AuthBloc, AuthState>(
      'ChangePassword',
      setUp: () {
        when(
          () => authRepository.changePassword(any()),
        ).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(ChangePassword(email: TestsData.email)),
      expect: () => [AuthLoading(), AuthSuccess()],
    );

    blocTest<AuthBloc, AuthState>(
      'SendEmailVerification',
      setUp: () {
        when(
          () => authRepository.sendEmailVerification(),
        ).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(SendEmailVerification()),
      expect: () => [AuthLoading()],
    );

    blocTest<AuthBloc, AuthState>(
      'WatchEmailVerified',
      setUp: () {
        when(
          () => authRepository.watchEmailVerified(),
        ).thenAnswer((_) async => true);
        when(
          () => authRepository.getUser(),
        ).thenAnswer((_) async => TestsData.userData);
        when(() => remoteRepository.setUser(any())).thenAnswer((_) async {});
        when(() => localRepository.setUser(any())).thenAnswer((_) async {});
        when(() => settingsRepository.setAuth(true)).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(WatchEmailVerified()),
      expect: () => [AuthLoading(), AuthWithoutDirections()],
    );

    blocTest<AuthBloc, AuthState>(
      'SignOut',
      setUp: () {
        when(
          () => localRepository.getUser(),
        ).thenAnswer((_) async => TestsData.userData);
        when(
          () => localRepository.getInterviews(),
        ).thenAnswer((_) async => [TestsData.interviewData]);
        when(
          () => localRepository.getTasks(),
        ).thenAnswer((_) async => [TestsData.task]);
        when(
          () => remoteRepository.updateInterviews(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => remoteRepository.updateTasks(any(), any()),
        ).thenAnswer((_) async {});
        when(() => authRepository.signOut()).thenAnswer((_) async {});
        when(() => localRepository.deleteData()).thenAnswer((_) async {});
        when(() => settingsRepository.setAuth(false)).thenAnswer((_) async {});
      },
      build: () => mockAuthBloc,
      act: (bloc) => bloc.add(SignOut()),
      expect: () => [AuthLoading(), AuthSuccess()],
    );
  });
}

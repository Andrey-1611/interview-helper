import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'app_dependencies.config.dart';

@InjectableInit(
  initializerName: 'setup',
  asExtension: true,
  preferRelativeImports: true,
)
void setupDependencies() => GetIt.I.setup();

@module
abstract class Modules {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @lazySingleton
  HiveInterface get hive => Hive;

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

/*
class AppDependencies {
  static final GetIt _getIt = GetIt.instance;

  static void setup() async {
    _setupUtils();
    _setupRepositories();
    _setupAuthUseCases();
    _setupHistoryUseCases();
    _setupHomeUseCases();
    _setupInterviewUseCases();
    _setupUsersUseCases();
  }

  static void _setupUtils() {
    _getIt.registerLazySingleton(() => NetworkInfo(Connectivity()));
  }

  static void _setupRepositories() {
    _getIt.registerLazySingleton<AuthRepository>(
          () => FirebaseAuthDataSource(FirebaseAuth.instance),
    );
    _getIt.registerLazySingleton<RemoteRepository>(
          () => FirestoreDataSource(FirebaseFirestore.instance),
    );
    _getIt.registerLazySingleton<LocalRepository>(() => HiveDataSource(Hive));
    _getIt.registerLazySingleton<AIRepository>(() => ChatGPTDataSource(Dio()));
  }

  static void _setupAuthUseCases() {
    _getIt.registerFactory(
          () =>
          ChangeEmailUseCase(_getIt<AuthRepository>(), _getIt<NetworkInfo>()),
    );
    _getIt.registerFactory(
          () =>
          ChangePasswordUseCase(
            _getIt<AuthRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );

    _getIt.registerFactory(
          () =>
          SendEmailVerificationUseCase(
            _getIt<AuthRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
    _getIt.registerFactory(
          () =>
          SignInUseCase(
            _getIt<AuthRepository>(),
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
    _getIt.registerFactory(
          () =>
          SignOutUseCase(
            _getIt<AuthRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
    _getIt.registerFactory(
          () => SignUpUseCase(_getIt<AuthRepository>(), _getIt<NetworkInfo>()),
    );
    _getIt.registerFactory(
          () =>
          WatchEmailVerifiedUseCase(
            _getIt<AuthRepository>(),
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
  }

  static void _setupHistoryUseCases() {
    _getIt.registerFactory(
          () =>
          ShowInterviewsUseCase(
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
  }

  static void _setupHomeUseCases() {
    _getIt.registerFactory(
          () =>
          GetCurrentUserUseCase(
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
  }

  static void _setupInterviewUseCases() {
    _getIt.registerFactory(
          () =>
          CheckResultsUseCase(
            _getIt<AIRepository>(),
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
    _getIt.registerFactory(
          () =>
          StartInterviewUseCase(
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
  }

  static void _setupUsersUseCases() {
    _getIt.registerFactory(() => GetUserUseCase(_getIt<LocalRepository>()));
    _getIt.registerFactory(
          () =>
          ShowUsersUseCase(_getIt<RemoteRepository>(), _getIt<NetworkInfo>()),
    );
  }
*/

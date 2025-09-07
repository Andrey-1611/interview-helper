import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/core/utils/mobile_ads.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/get_current_user_use_case.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/gemini_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/hive_data_source.dart';
import 'package:interview_master/features/interview/data/repositories/ai_repository_impl.dart';
import 'package:interview_master/features/interview/data/repositories/local_repository_impl.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository_impl.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_results_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/start_interview_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_interviews_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';
import '../../core/utils/network_info.dart';
import '../../features/auth/domain/use_cases/change_email_use_case.dart';
import '../../features/auth/domain/use_cases/send_email_verification_use_case.dart';
import '../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import '../../features/interview/domain/repositories/remote_repository.dart';
import '../../features/interview/domain/repositories/ai_repository.dart';
import '../../features/interview/domain/use_cases/get_user_use_case.dart';

class AppDependencies {
  static final GetIt _getIt = GetIt.instance;

  static void setup() async {
    _setupUtils();
    _setupRepositories();
    _setupAuthUseCases();
    _setupInterviewUseCases();
  }

  static void _setupUtils() {
    _getIt.registerLazySingleton(() => NetworkInfo(Connectivity()));
    _getIt.registerLazySingleton(() => MobileAds());
  }

  static void _setupRepositories() {
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance)),
    );
    _getIt.registerLazySingleton<RemoteRepository>(
      () =>
          RemoteRepositoryImpl(FirestoreDataSource(FirebaseFirestore.instance)),
    );
    _getIt.registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImpl(HiveDataSource(Hive)),
    );
    _getIt.registerLazySingleton<AIRepository>(
      () => AIRepositoryImpl(GeminiDataSource(Gemini.instance)),
    );
  }

  static void _setupAuthUseCases() {
    _getIt.registerLazySingleton(
      () => ChangeEmailUseCase(_getIt<AuthRepository>(), _getIt<NetworkInfo>()),
    );
    _getIt.registerLazySingleton(
      () => ChangePasswordUseCase(
        _getIt<AuthRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => GetCurrentUserUseCase(
        _getIt<RemoteRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => GetUserUseCase(_getIt<LocalRepository>()),
    );
    _getIt.registerLazySingleton(
      () => SendEmailVerificationUseCase(
        _getIt<AuthRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignInUseCase(
        _getIt<AuthRepository>(),
        _getIt<RemoteRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignOutUseCase(
        _getIt<AuthRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignUpUseCase(_getIt<AuthRepository>(), _getIt<NetworkInfo>()),
    );
    _getIt.registerLazySingleton(
      () => WatchEmailVerifiedUseCase(
        _getIt<AuthRepository>(),
        _getIt<RemoteRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
  }

  static void _setupInterviewUseCases() {
    _getIt.registerLazySingleton(
      () => CheckResultsUseCase(
        _getIt<AIRepository>(),
        _getIt<RemoteRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => ShowInterviewsUseCase(
        _getIt<RemoteRepository>(),
        _getIt<LocalRepository>(),
        _getIt<NetworkInfo>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => ShowUsersUseCase(_getIt<RemoteRepository>(), _getIt<NetworkInfo>()),
    );
    _getIt.registerLazySingleton(
      () => StartInterviewUseCase(_getIt<NetworkInfo>(), _getIt<MobileAds>()),
    );
  }
}

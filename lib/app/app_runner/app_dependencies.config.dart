// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/adapters.dart' as _i744;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/utils/network_info.dart' as _i668;
import '../../data/data_sources/chat_gpt_data_source.dart' as _i241;
import '../../data/data_sources/firebase_auth_data_source.dart' as _i891;
import '../../data/data_sources/firestore_data_source.dart' as _i1001;
import '../../data/data_sources/hive_data_source.dart' as _i858;
import '../../data/repositories/ai_repository.dart' as _i504;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/local_repository.dart' as _i29;
import '../../data/repositories/remote_repository.dart' as _i137;
import '../../features/auth/use_cases/change_email_use_case.dart' as _i333;
import '../../features/auth/use_cases/change_password_use_case.dart' as _i408;
import '../../features/auth/use_cases/send_email_verification_use_case.dart'
    as _i290;
import '../../features/auth/use_cases/sign_in_use_case.dart' as _i887;
import '../../features/auth/use_cases/sign_up_use_case.dart' as _i49;
import '../../features/auth/use_cases/watch_email_verified_user_case.dart'
    as _i226;
import '../../features/history/use_cases/show_interviews_use_case.dart'
    as _i855;
import '../../features/home/use_cases/get_current_user_use_case.dart' as _i941;
import '../../features/home/use_cases/sign_out_use_case.dart' as _i327;
import '../../features/interview/use_cases/check_results_use_case.dart'
    as _i911;
import '../../features/interview/use_cases/start_interview_use_case.dart'
    as _i782;
import '../../features/users/use_cases/get_user_use_case.dart' as _i547;
import '../../features/users/use_cases/show_users_use_case.dart' as _i293;
import 'app_dependencies.dart' as _i469;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt setup({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final modules = _$Modules();
    gh.lazySingleton<_i59.FirebaseAuth>(() => modules.firebaseAuth);
    gh.lazySingleton<_i361.Dio>(() => modules.dio);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => modules.firebaseFirestore);
    gh.lazySingleton<_i744.HiveInterface>(() => modules.hive);
    gh.lazySingleton<_i895.Connectivity>(() => modules.connectivity);
    gh.lazySingleton<_i504.AIRepository>(
        () => _i241.ChatGPTDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i29.LocalRepository>(
        () => _i858.HiveDataSource(gh<_i986.HiveInterface>()));
    gh.lazySingleton<_i137.RemoteRepository>(
        () => _i1001.FirestoreDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i668.NetworkInfo>(
        () => _i668.NetworkInfo(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i481.AuthRepository>(
        () => _i891.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()));
    gh.factory<_i782.StartInterviewUseCase>(() => _i782.StartInterviewUseCase(
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i887.SignInUseCase>(() => _i887.SignInUseCase(
          gh<_i481.AuthRepository>(),
          gh<_i137.RemoteRepository>(),
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i226.WatchEmailVerifiedUseCase>(
        () => _i226.WatchEmailVerifiedUseCase(
              gh<_i481.AuthRepository>(),
              gh<_i137.RemoteRepository>(),
              gh<_i29.LocalRepository>(),
              gh<_i668.NetworkInfo>(),
            ));
    gh.factory<_i547.GetUserUseCase>(
        () => _i547.GetUserUseCase(gh<_i29.LocalRepository>()));
    gh.factory<_i293.ShowUsersUseCase>(() => _i293.ShowUsersUseCase(
          gh<_i137.RemoteRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i333.ChangeEmailUseCase>(() => _i333.ChangeEmailUseCase(
          gh<_i668.NetworkInfo>(),
          gh<_i481.AuthRepository>(),
        ));
    gh.factory<_i327.SignOutUseCase>(() => _i327.SignOutUseCase(
          gh<_i481.AuthRepository>(),
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i855.ShowInterviewsUseCase>(() => _i855.ShowInterviewsUseCase(
          gh<_i137.RemoteRepository>(),
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i941.GetCurrentUserUseCase>(() => _i941.GetCurrentUserUseCase(
          gh<_i137.RemoteRepository>(),
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i408.ChangePasswordUseCase>(() => _i408.ChangePasswordUseCase(
          gh<_i481.AuthRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i290.SendEmailVerificationUseCase>(
        () => _i290.SendEmailVerificationUseCase(
              gh<_i481.AuthRepository>(),
              gh<_i668.NetworkInfo>(),
            ));
    gh.factory<_i49.SignUpUseCase>(() => _i49.SignUpUseCase(
          gh<_i481.AuthRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    gh.factory<_i911.CheckResultsUseCase>(() => _i911.CheckResultsUseCase(
          gh<_i504.AIRepository>(),
          gh<_i137.RemoteRepository>(),
          gh<_i29.LocalRepository>(),
          gh<_i668.NetworkInfo>(),
        ));
    return this;
  }
}

class _$Modules extends _i469.Modules {}

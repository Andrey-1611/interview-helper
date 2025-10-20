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
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../core/utils/network_info.dart' as _i668;
import '../../core/utils/stopwatch_info.dart' as _i742;
import '../../data/data_sources/chat_gpt_data_source.dart' as _i241;
import '../../data/data_sources/firebase_auth_data_source.dart' as _i891;
import '../../data/data_sources/firestore_data_source.dart' as _i1001;
import '../../data/data_sources/hive_data_source.dart' as _i858;
import '../../data/repositories/ai_repository.dart' as _i504;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/local_repository.dart' as _i29;
import '../../data/repositories/remote_repository.dart' as _i137;
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
    gh.singleton<_i207.Talker>(() => modules.talker);
    gh.singletonAsync<_i655.PackageInfo>(() => modules.packageInfo);
    gh.lazySingleton<_i59.FirebaseAuth>(() => modules.firebaseAuth);
    gh.lazySingleton<_i361.Dio>(() => modules.dio);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => modules.firebaseFirestore);
    gh.lazySingleton<_i744.HiveInterface>(() => modules.hive);
    gh.lazySingleton<_i895.Connectivity>(() => modules.connectivity);
    gh.lazySingleton<Stopwatch>(() => modules.stopWatch);
    gh.lazySingleton<_i504.AIRepository>(
        () => _i241.ChatGPTDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i29.LocalRepository>(
        () => _i858.HiveDataSource(gh<_i986.HiveInterface>()));
    gh.lazySingleton<_i742.StopwatchInfo>(
        () => _i742.StopwatchInfo(gh<Stopwatch>()));
    gh.lazySingleton<_i137.RemoteRepository>(
        () => _i1001.FirestoreDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i668.NetworkInfo>(
        () => _i668.NetworkInfo(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i481.AuthRepository>(
        () => _i891.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()));
    return this;
  }
}

class _$Modules extends _i469.Modules {}

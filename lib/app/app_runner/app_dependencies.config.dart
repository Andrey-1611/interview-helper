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
import 'package:flutter_tts/flutter_tts.dart' as _i50;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:hive_flutter/adapters.dart' as _i744;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:share_plus/share_plus.dart' as _i998;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:speech_to_text/speech_to_text.dart' as _i941;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../core/utils/device_info.dart' as _i168;
import '../../core/utils/network_info.dart' as _i668;
import '../../core/utils/share_info.dart' as _i502;
import '../../core/utils/stopwatch_info.dart' as _i742;
import '../../core/utils/url_launch.dart' as _i1057;
import '../../data/data_sources/ai_data_source.dart' as _i982;
import '../../data/data_sources/auth_data_source.dart' as _i315;
import '../../data/data_sources/local_data_source.dart' as _i466;
import '../../data/data_sources/remote_data_source.dart' as _i264;
import '../../data/data_sources/settings_data_source.dart' as _i504;
import '../../data/repositories/ai_repository.dart' as _i504;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/local_repository.dart' as _i29;
import '../../data/repositories/remote_repository.dart' as _i137;
import '../../data/repositories/settings_repository.dart' as _i373;
import 'app_dependencies.dart' as _i469;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> setup({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final modules = _$Modules();
    gh.singleton<_i207.Talker>(() => modules.talker);
    gh.singletonAsync<_i655.PackageInfo>(() => modules.packageInfo);
    gh.lazySingleton<_i59.FirebaseAuth>(() => modules.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => modules.googleSignIn);
    gh.lazySingleton<_i361.Dio>(() => modules.dio);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => modules.firebaseFirestore);
    gh.lazySingleton<_i744.HiveInterface>(() => modules.hive);
    gh.lazySingleton<_i895.Connectivity>(() => modules.connectivity);
    gh.lazySingleton<Stopwatch>(() => modules.stopWatch);
    gh.lazySingleton<_i941.SpeechToText>(() => modules.speechToText);
    gh.lazySingleton<_i50.FlutterTts>(() => modules.flutterTts);
    gh.lazySingleton<_i998.SharePlus>(() => modules.sharePlus);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => modules.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i168.DeviceInfo>(() => _i168.DeviceInfo());
    gh.lazySingleton<_i1057.UrlLaunch>(() => _i1057.UrlLaunch());
    gh.lazySingleton<_i29.LocalRepository>(
        () => _i466.LocalDataSource(gh<_i986.HiveInterface>()));
    gh.lazySingleton<_i504.AIRepository>(
        () => _i982.AIDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i137.RemoteRepository>(
        () => _i264.RemoteDataSource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i742.StopwatchInfo>(
        () => _i742.StopwatchInfo(gh<Stopwatch>()));
    gh.lazySingleton<_i373.SettingsRepository>(
        () => _i504.SettingsDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i502.ShareInfo>(
        () => _i502.ShareInfo(gh<_i998.SharePlus>()));
    gh.lazySingleton<_i481.AuthRepository>(() => _i315.AuthDataSource(
          gh<_i59.FirebaseAuth>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.lazySingleton<_i668.NetworkInfo>(
        () => _i668.NetworkInfo(gh<_i895.Connectivity>()));
    return this;
  }
}

class _$Modules extends _i469.Modules {}

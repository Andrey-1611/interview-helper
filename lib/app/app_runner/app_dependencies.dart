import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/core/utils/device_info.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/share_info.dart';
import 'package:interview_master/core/utils/stopwatch_info.dart';
import 'package:interview_master/core/utils/url_launch.dart';
import 'package:interview_master/data/data_sources/ai_data_source.dart';
import 'package:interview_master/data/data_sources/auth_data_source.dart';
import 'package:interview_master/data/data_sources/local_data_source.dart';
import 'package:interview_master/data/data_sources/remote_data_source.dart';
import 'package:interview_master/data/data_sources/settings_data_source.dart';
import 'package:interview_master/data/repositories/ai_repository.dart';
import 'package:interview_master/data/repositories/auth_repository.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:interview_master/features/users/blocs/users_bloc/users_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppDependencies {
  static final _getIt = GetIt.I;

  static Future<void> setup() async {
    _setupRepositories();
    _setupUtils();
  }

  static Future<void> _setupRepositories() async {
    _getIt.registerLazySingleton<Dio>(() => Dio());
    _getIt.registerLazySingleton<AuthRepository>(
          () => AuthDataSource(FirebaseAuth.instance, GoogleSignIn()),
    );
    _getIt.registerLazySingleton<AIRepository>(
          () => AIDataSource(_getIt<Dio>()),
    );
    _getIt.registerLazySingleton<LocalRepository>(() => LocalDataSource(Hive));
    _getIt.registerLazySingleton<RemoteRepository>(
          () => RemoteDataSource(FirebaseFirestore.instance),
    );
    _getIt.registerSingletonAsync<SettingsRepository>(
          () async => SettingsDataSource(await SharedPreferences.getInstance()),
    );
  }

  static void _setupUtils() {
    _getIt.registerLazySingleton<DeviceInfo>(() => DeviceInfo());
    _getIt.registerLazySingleton<NetworkInfo>(
          () => NetworkInfo(Connectivity()),
    );
    _getIt.registerLazySingleton<ShareInfo>(
          () => ShareInfo(SharePlus.instance),
    );
    _getIt.registerLazySingleton<StopwatchInfo>(
          () => StopwatchInfo(Stopwatch()),
    );
    _getIt.registerLazySingleton<UrlLaunch>(() => UrlLaunch());
    _getIt.registerLazySingleton<Talker>(() => TalkerFlutter.init());
    _getIt.registerSingletonAsync<PackageInfo>(
          () async => await PackageInfo.fromPlatform(),
    );
    _getIt.registerFactory(
          () =>
          UsersBloc(
            _getIt<RemoteRepository>(),
            _getIt<LocalRepository>(),
            _getIt<NetworkInfo>(),
          ),
    );
    _getIt.registerLazySingleton<SpeechToText>(() => SpeechToText());
    _getIt.registerLazySingleton<FlutterTts>(() => FlutterTts());
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interview_master/core/utils/services/device_service.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/core/utils/services/notifications_service.dart';
import 'package:interview_master/core/utils/services/share_service.dart';
import 'package:interview_master/core/utils/services/stopwatch_service.dart';
import 'package:interview_master/core/utils/services/url_service.dart';
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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppDependencies {
  static final _getIt = GetIt.I;

  static Future<void> setup() async {
    _setupRepositories();
    _setupPackages();
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
    _getIt.registerLazySingleton<NotificationsService>(
      () => NotificationsService(_getIt<FlutterLocalNotificationsPlugin>()),
    );
  }

  static void _setupUtils() {
    _getIt.registerLazySingleton<DeviceService>(() => DeviceService());
    _getIt.registerLazySingleton<NetworkService>(
      () => NetworkService(Connectivity()),
    );
    _getIt.registerLazySingleton<ShareService>(
      () => ShareService(SharePlus.instance),
    );
    _getIt.registerLazySingleton<StopwatchService>(
      () => StopwatchService(Stopwatch()),
    );
    _getIt.registerLazySingleton<UrlService>(() => UrlService());
    _getIt.registerLazySingleton<Talker>(() => TalkerFlutter.init());
  }

  static void _setupPackages() {
    _getIt.registerSingletonAsync<PackageInfo>(
      () async => await PackageInfo.fromPlatform(),
    );
    _getIt.registerLazySingleton<SpeechToText>(() => SpeechToText());
    _getIt.registerLazySingleton<FlutterTts>(() => FlutterTts());
    _getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin(),
    );
  }
}

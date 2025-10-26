import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/core/constants/hive_data.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/models/interview/interview.dart';
import '../../data/models/interview/interview_data.dart';
import '../../data/models/interview/question.dart';
import '../../data/models/user/user_data.dart';
import '../../firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initFirebase();
    await _initHive();
    await _loadApi();
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(InterviewAdapter());
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(QuestionAdapter());
    Hive.registerAdapter(InterviewDataAdapter());
    await Hive.openBox<InterviewData>(HiveData.interviewsBox);
    await Hive.openBox<UserData>(HiveData.userBox);
  }

  static Future<void> _loadApi() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<void> initTalker() async {
    final talker = GetIt.I<Talker>();
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: TalkerBlocLoggerSettings(printStateFullData: false),
    );
    GetIt.I<Dio>().interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(printResponseData: false),
      ),
    );
  }
}

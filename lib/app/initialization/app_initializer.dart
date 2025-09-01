import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/core/constants/hive_boxes.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import '../../core/secrets/api_key.dart';
import '../../firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initGemini();
    await _initFirebase();
    await _initHive();
  }

  static Future<void> _initGemini() async {
    Gemini.init(apiKey: GEMINI_API_KEY);
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(InterviewAdapter());
    Hive.registerAdapter(QuestionAdapter());
    await Hive.openBox<Interview>(HiveBoxes.interviews);
  }
}

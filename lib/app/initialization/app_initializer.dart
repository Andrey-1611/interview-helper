import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/infrastructure/global_data_sources/local_data_sources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/secrets/api_key.dart';
import '../../firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initGemini();
    await _initFirebase();
  }

  static Future<void> _initGemini() async {
    Gemini.init(apiKey: API_KEY);
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<LocalDataSource> initLocalDataSource() async {
    return LocalDataSource(sharedPreferences: await SharedPreferences.getInstance());
  }
}

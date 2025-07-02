import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../firebase_options.dart';
import '../secrets/api_key.dart';

class AppInitializer {
  static void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _initGemini();
    _initFirebase();
  }

  static Future<void> _initGemini() async {
    Gemini.init(apiKey: API_KEY);
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

}
import 'package:interview_master/app/app_runner/app_dependencies.dart';
import 'package:interview_master/app/app_runner/app_initializer.dart';

class AppRunner {
  static Future<void> run() async {
    await AppInitializer.init();
    AppDependencies.setup();
  }
}

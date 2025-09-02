import 'package:flutter/material.dart';
import 'package:interview_master/app/dependencies/app_dependencies.dart';
import 'app/app.dart';
import 'app/initialization/app_initializer.dart';

void main() async {
  await AppInitializer.init();
  AppDependencies.setUp();
  runApp(const App());
}

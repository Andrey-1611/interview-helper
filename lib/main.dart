import 'package:flutter/material.dart';
import 'package:interview_master/app/app_runner/app_dependencies.dart';
import 'package:interview_master/app/app_runner/app_initializer.dart';
import 'app/app.dart';

void main() async {
  await AppInitializer.init();
  setupDependencies();
  runApp(const App());
}

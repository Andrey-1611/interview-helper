import 'package:flutter/material.dart';
import 'package:interview_master/app/app_runner/app_runner.dart';
import 'app/app.dart';

void main() async {
  await AppRunner.run();
  runApp(const App());
}

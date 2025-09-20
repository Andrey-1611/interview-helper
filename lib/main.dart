import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_runner/app_runner.dart';

void main() async {
  await AppRunner.run();
  runApp(const App());
}

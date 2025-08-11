import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/initialization/app_initializer.dart';

void main() async {
  await AppInitializer.init();
  runApp(const App());
}

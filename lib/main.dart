import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/initialization/app_initializer.dart';

void main() async {
  AppInitializer.init();
  runApp(const MyApp());
}


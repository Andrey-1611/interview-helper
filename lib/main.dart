import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/app_runner/app_dependencies.dart';
import 'package:interview_master/app/app_runner/app_initializer.dart';
import 'package:interview_master/data/repositories/auth/auth.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'app/app.dart';

void main() {
  runZonedGuarded(() async {
    await AppInitializer.init();
    setupDependencies();
    await AppInitializer.initTalker();
    runApp(const App());
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}

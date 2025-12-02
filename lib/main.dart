import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/app_runner/app_initializer.dart';
import 'package:interview_master/core/utils/device_info.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'app/app.dart';
import 'app/app_runner/app_dependencies.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencies();
    await AppInitializer.init();
    await DeviceInfo().getLanguage();
    runApp(const App());
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}

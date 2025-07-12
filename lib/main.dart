import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_data_sources/local_data_sources_interface.dart';
import 'app/app.dart';
import 'app/initialization/app_initializer.dart';

void main() async {
  await AppInitializer.init();
  runApp(
    RepositoryProvider<LocalDataSourceInterface>.value(
      value: await AppInitializer.initLocalDataSource(),
      child: const MyApp(),
    ),
  );
}

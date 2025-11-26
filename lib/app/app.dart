import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/router/app_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/theme_cubit.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DataCubit()),
        BlocProvider(
          create: (context) => ThemeCubit(GetIt.I<SettingsRepository>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: state ? darkTheme : lightTheme,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}

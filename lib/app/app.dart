import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/router/app_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/device_info.dart';
import 'package:interview_master/core/utils/settings_cubit/settings_cubit.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import '../core/theme/app_theme.dart';
import '../generated/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DataCubit()),
        BlocProvider(
          create: (context) => SettingsCubit(
            GetIt.I<SettingsRepository>(),
            GetIt.I<DeviceInfo>(),
          )..setSettings(),
        ),
      ],
      child: _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final width = MediaQuery.sizeOf(context).width;
    return MaterialApp.router(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(state.language ? 'ru' : 'en'),
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: state.theme ? darkTheme(width) : lightTheme(width),
      routerConfig: appRouter,
    );
  }
}

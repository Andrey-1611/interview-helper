import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/router/app_router.dart';
import 'package:interview_master/core/utils/cubits/data_cubit.dart';
import 'package:interview_master/core/utils/services/device_service.dart';
import 'package:interview_master/core/utils/cubits/settings_cubit.dart';
import 'package:interview_master/core/utils/services/notifications_service.dart';
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
            GetIt.I<DeviceService>(),
            GetIt.I<NotificationsService>(),
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
    return FutureBuilder(
      future: context.read<SettingsCubit>().setNotifications(
        state.notifications,
      ),
      builder: (context, asyncSnapshot) {
        return ScreenUtilInit(
          designSize: const Size(427, 952),
          builder: (context, child) => MaterialApp.router(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale(state.language ? 'ru' : 'en'),
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: state.theme ? darkTheme : lightTheme,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/app/router/app_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, _) {
        return ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(),
            navigatorKey: AppRouter.navigatorKey,
            initialRoute: AppRouterNames.splash,
            routes: AppRouter.routes,
          ),
        );
      },
    );
  }
}

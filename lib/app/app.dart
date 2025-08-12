import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'navigation/app_router_names.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(),
          navigatorKey: AppRouter.navigatorKey,
          initialRoute: AppRouterNames.splash,
          routes: AppRouter.routes,
        );
      },
    );
  }
}

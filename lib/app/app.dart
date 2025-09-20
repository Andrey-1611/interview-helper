import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/app/router/app_router.dart';
import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (_, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(),
          routerConfig: appRouter,
        );
      },
    );
  }
}

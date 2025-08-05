import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/app/global_bloc_providers/global_bloc_provider.dart';
import '../core/theme/theme.dart';
import 'navigation/app_router.dart';
import 'navigation/app_router_names.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProvider(
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
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
      ),
    );
  }
}

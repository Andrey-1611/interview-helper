import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'navigation/app_router_names.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRouterNames.splash,
      routes: AppRouter.routes,
    );;
  }
}

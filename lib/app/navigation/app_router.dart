import 'dart:math';
import 'package:flutter/material.dart';
import 'package:interview_master/features/auth/presentation/pages/sign_in_page.dart';
import 'package:interview_master/features/auth/presentation/pages/sign_up_page.dart';
import 'package:interview_master/features/auth/presentation/pages/splash_page.dart';
import 'package:interview_master/features/auth/presentation/pages/user_profile_page.dart';
import '../../features/interview/views/pages/home_page.dart';
import '../../features/interview/views/pages/interview_info_page.dart';
import '../../features/interview/views/pages/interview_page.dart';
import '../../features/interview/views/pages/results_page.dart';

class AppRouterNames {
  static const splash = '/';
  static const signIn = '/sign_in';
  static const signUp = '/sign_up';
  static const userProfile = '/user_profile';
  static const home = '/home';
  static const interview = '/interview';
  static const results = '/results';
  static const interviewInfo = '/interview_info';
}

class AppRouter {
  static Map<String, Widget Function(BuildContext context)> routes = {
    AppRouterNames.splash: (context) => const SplashPage(),
    AppRouterNames.signIn: (context) => const SignInPage(),
    AppRouterNames.signUp: (context) => const SignUpPage(),
    AppRouterNames.userProfile: (context) => const UserProfilePage(),
    AppRouterNames.home: (context) => const HomePage(),
    AppRouterNames.interview: (context) => InterviewPage(random: Random()),
    AppRouterNames.results: (context) => const ResultsPage(),
    AppRouterNames.interviewInfo: (context) => const InterviewInfoPage(),
  };
}

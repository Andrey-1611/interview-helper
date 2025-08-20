import 'package:flutter/material.dart';
import 'package:interview_master/features/auth/presentation/pages/change_email_page.dart';
import 'package:interview_master/features/auth/presentation/pages/change_password_page.dart';
import 'package:interview_master/features/auth/presentation/pages/email_verification_page.dart';
import 'package:interview_master/features/auth/presentation/pages/sign_in_page.dart';
import 'package:interview_master/features/auth/presentation/pages/sign_up_page.dart';
import 'package:interview_master/features/auth/presentation/pages/splash_page.dart';
import 'package:interview_master/features/auth/presentation/pages/my_user_profile_page.dart';
import 'package:interview_master/features/interview/presentation/pages/interviews_history_page.dart';
import 'package:interview_master/features/interview/presentation/pages/question_info_page.dart';
import 'package:interview_master/features/interview/presentation/pages/user_info_page.dart';
import '../../features/interview/presentation/pages/home_page.dart';
import '../../features/interview/presentation/pages/interview_info_page.dart';
import '../../features/interview/presentation/pages/interview_page.dart';
import '../../features/interview/presentation/pages/results_page.dart';
import 'app_router_names.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Map<String, Widget Function(BuildContext context)> routes = {
    AppRouterNames.splash: (context) => const SplashPage(),
    AppRouterNames.signIn: (context) => const SignInPage(),
    AppRouterNames.signUp: (context) => const SignUpPage(),
    AppRouterNames.emailVerification: (context) => const EmailVerificationPage(),
    AppRouterNames.changeEmail: (context) => const ChangeEmailPage(),
    AppRouterNames.changePassword: (context) => const ChangePasswordPage(),
    AppRouterNames.myUserProfile: (context) => const MyUserProfilePage(),
    AppRouterNames.home: (context) => const HomePage(),
    AppRouterNames.interview: (context) => const InterviewPage(),
    AppRouterNames.results: (context) => const ResultsPage(),
    AppRouterNames.interviewInfo: (context) => const InterviewInfoPage(),
    AppRouterNames.questionInfo: (context) => const QuestionInfoPage(),
    AppRouterNames.userInfo: (context) => const UserInfoPage(),
  };

  static void pushNamed(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  static void pushReplacementNamed(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(
      route,
      arguments: arguments,
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}

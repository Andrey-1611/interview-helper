import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/features/users/pages/profile_page.dart';
import '../../data/models/interview/interview_data.dart';
import '../../data/models/interview/interview_info.dart';
import '../../data/models/interview/question.dart';
import '../../data/models/user/user_data.dart';
import '../../features/auth/pages/change_email_page.dart';
import '../../features/auth/pages/change_password_page.dart';
import '../../features/auth/pages/email_verification_page.dart';
import '../../features/auth/pages/sign_in_page.dart';
import '../../features/auth/pages/sign_up_page.dart';
import '../../features/history/pages/interview_info_page.dart';
import '../../features/history/pages/question_info_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/interview/pages/initial_page.dart';
import '../../features/interview/pages/interview_page.dart';
import '../../features/interview/pages/results_page.dart';
import '../../features/home/pages/splash_page.dart';
import '../../features/users/pages/user_page.dart';
import '../../features/users/pages/users_rating_page.dart';
import 'app_router_names.dart';

final appRouter = GoRouter(
  initialLocation: AppRouterNames.splash,
  routes: [
    GoRoute(
      path: AppRouterNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRouterNames.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: AppRouterNames.changePassword,
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: AppRouterNames.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRouterNames.emailVerification,
      builder: (context, state) {
        final password = state.extra as String;
        return EmailVerificationPage(password: password);
      },
    ),
    GoRoute(
      path: AppRouterNames.changeEmail,
      builder: (context, state) {
        final password = state.extra as String;
        return ChangeEmailPage(password: password);
      },
    ),
    GoRoute(
      path: AppRouterNames.interview,
      builder: (context, state) {
        final interviewInfo = state.extra as InterviewInfo;
        return InterviewPage(interviewInfo: interviewInfo);
      },
    ),
    GoRoute(
      path: AppRouterNames.results,
      builder: (context, state) {
        final interviewInfo = state.extra as InterviewInfo;
        return ResultsPage(interviewInfo: interviewInfo);
      },
    ),
    GoRoute(
      path: AppRouterNames.interviewInfo,
      builder: (context, state) {
        final interview = state.extra as InterviewData;
        return InterviewInfoPage(interview: interview);
      },
    ),
    GoRoute(
      path: AppRouterNames.questionInfo,
      builder: (context, state) {
        final question = state.extra as Question;
        return QuestionInfoPage(question: question);
      },
    ),
    GoRoute(
      path: AppRouterNames.user,
      builder: (context, state) {
        final user = state.extra as UserData?;
        return UserPage(user: user);
      },
    ),
    StatefulShellRoute(
      navigatorContainerBuilder: (context, navigationShell, branchNavigators) {
        return IndexedStack(
          index: navigationShell.currentIndex,
          children: branchNavigators,
        );
      },
      builder: (context, state, navigationShell) {
        return HomePage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.initial,
              builder: (context, state) => const InitialPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.currentUser,
              builder: (context, state) => const UserPage(user: null),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.usersRating,
              builder: (context, state) => const UsersRatingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

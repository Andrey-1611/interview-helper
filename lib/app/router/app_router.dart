import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:interview_master/features/tracker/pages/directions_page.dart';
import 'package:interview_master/features/tracker/pages/task_page.dart';
import 'package:interview_master/features/users/pages/analysis_page.dart';
import 'package:interview_master/features/users/pages/friend_requests_page.dart';
import 'package:interview_master/features/settings/pages/settings_page.dart';
import 'package:interview_master/features/users/pages/rating_page.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/models/interview_info.dart';
import '../../data/models/question.dart';
import '../../data/models/user_data.dart';
import '../../features/auth/pages/change_email_page.dart';
import '../../features/auth/pages/change_password_page.dart';
import '../../features/auth/pages/email_verification_page.dart';
import '../../features/auth/pages/sign_in_page.dart';
import '../../features/auth/pages/sign_up_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/interview/pages/initial_page.dart';
import '../../features/interview/pages/interview_page.dart';
import '../../features/interview/pages/results_page.dart';
import '../../features/home/pages/splash_page.dart';
import '../../features/profile/pages/interview_info_page.dart';
import '../../features/profile/pages/question_info_page.dart';
import '../../features/tracker/pages/tracker_page.dart';
import '../../features/profile/pages/profile_page.dart';
import 'app_router_names.dart';

final appRouter = GoRouter(
  observers: [TalkerRouteObserver(GetIt.I<Talker>())],
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
      path: AppRouterNames.directions,
      builder: (context, state) => DirectionsPage(),
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
      path: AppRouterNames.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRouterNames.task,
      builder: (context, state) {
        final task = state.extra as Task;
        return TaskPage(task: task);
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
      path: AppRouterNames.profile,
      builder: (context, state) {
        final user = state.extra as UserData?;
        return ProfilePage(user: user);
      },
    ),
    GoRoute(
      path: AppRouterNames.analysis,
      builder: (context, state) {
        final user = state.extra as UserData;
        return AnalysisPage(selectedUser: user);
      },
    ),
    GoRoute(
      path: AppRouterNames.friendRequests,
      builder: (context, state) => FriendRequestsPage(),
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
              path: AppRouterNames.currentProfile,
              builder: (context, state) => const ProfilePage(user: null),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.tracker,
              builder: (context, state) => const TrackerPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRouterNames.rating,
              builder: (context, state) => const RatingPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

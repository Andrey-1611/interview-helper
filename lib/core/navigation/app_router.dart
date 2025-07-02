import 'package:flutter/material.dart';
import '../../features/interview/views/pages/home_page.dart';
import '../../features/interview/views/pages/interview_info_page.dart';
import '../../features/interview/views/pages/interview_page.dart';
import '../../features/interview/views/pages/results_page.dart';

class AppRouterNames {
  static const home = '/home';
  static const interview = '/interview';
  static const results = '/results';
  static const interviewInfo = '/interview_info';
}

class AppRouter {
  static Map<String, Widget Function(BuildContext context)> routes = {
    AppRouterNames.home: (context) => const HomePage(),
    AppRouterNames.interview: (context) => const InterviewPage(),
    AppRouterNames.results: (context) => const ResultsPage(),
    AppRouterNames.interviewInfo: (context) => const InterviewInfoPage(),
  };
}

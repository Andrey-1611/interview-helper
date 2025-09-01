import 'package:flutter/material.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/interview/presentation/pages/users_rating_page.dart';
import '../../../../app/navigation/app_router_names.dart';
import 'initial_page.dart';
import 'interviews_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _HomePageView(
      currentIndex: _currentIndex,
      changeIndex: _changeIndex,
    );
  }

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _HomePageView extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> changeIndex;

  const _HomePageView({required this.currentIndex, required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              AppRouter.pushNamed(AppRouterNames.myUserProfile);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(
        currentIndex: currentIndex,
        changeIndex: changeIndex,
      ),
      body: switch (currentIndex) {
        0 => InitialPage(),
        1 => InterviewsHistoryPage(userId: null),
        2 => UsersRatingPage(),
        _ => CustomLoadingIndicator(),
      },
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> changeIndex;

  const _BottomNavigationBar({
    required this.currentIndex,
    required this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: changeIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Собеседование'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'История'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Рейтинг'),
      ],
    );
  }
}

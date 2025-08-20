import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/interview/presentation/pages/interviews_history_page.dart';
import 'package:interview_master/features/interview/presentation/pages/user_info_main_page.dart';

import '../../../../app/global/providers/user_provider.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _UserInfoPageView(
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

class _UserInfoPageView extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> changeIndex;

  const _UserInfoPageView({
    required this.currentIndex,
    required this.changeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: _BottomNavigationBar(
        currentIndex: currentIndex,
        changeIndex: changeIndex,
      ),
      body: switch (currentIndex) {
        0 => UserInfoMainPage(user: user!),
        1 => InterviewsHistoryPage(userId: user!.id),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Статистика',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'История'),
      ],
    );
  }
}

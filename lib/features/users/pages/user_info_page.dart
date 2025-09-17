import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/users/pages/user_profile_page.dart';
import '../../../../data/models/user_data.dart';
import '../../history/pages/interviews_history_page.dart';

class UserInfoPage extends StatefulWidget {
  final UserData user;

  const UserInfoPage({super.key, required this.user});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'История'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: switch (_currentIndex) {
          0 => UserProfilePage(user: widget.user),
          1 => InterviewsHistoryPage(userId: widget.user.id),
          _ => CustomLoadingIndicator(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPalette.cardBackground,
        type: BottomNavigationBarType.shifting,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Собеседование',
            backgroundColor: AppPalette.cardBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Аналитика',
            backgroundColor: AppPalette.cardBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'Трекер',
            backgroundColor: AppPalette.cardBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Рейтинг',
            backgroundColor: AppPalette.cardBackground,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      'Собеседование',
      'Аналитика',
      'Рейтинг',
      'Профиль',
    ];
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppPalette.cardBackground,
        title: Text(
          labels[navigationShell.currentIndex],
          style: theme.textTheme.displayLarge,
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: SizedBox(
        height: size.height * 0.08,
        child: BottomNavigationBar(
          backgroundColor: AppPalette.cardBackground,
          type: BottomNavigationBarType.shifting,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: labels[0],
              backgroundColor: AppPalette.cardBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: labels[1],
              backgroundColor: AppPalette.cardBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: labels[2],
              backgroundColor: AppPalette.cardBackground,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: labels[3],
              backgroundColor: AppPalette.cardBackground,
            ),
          ],
        ),
      ),
    );
  }
}

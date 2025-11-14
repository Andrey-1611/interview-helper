import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      backgroundColor: AppPalette.cardBackground,
      bottomNavigationBar: GNav(
        selectedIndex: navigationShell.currentIndex,
        onTabChange: (index) => navigationShell.goBranch(index),
        gap: 4,
       tabMargin: EdgeInsets.symmetric(vertical: 8),
        haptic: false,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        activeColor: AppPalette.primary,
        color: Colors.grey[600],
        tabBackgroundColor: AppPalette.primary.withOpacity(0.1),
        backgroundColor: AppPalette.cardBackground,
        tabs: [
          GButton(icon: Icons.chat, text: 'Интервью'),
          GButton(icon: Icons.bar_chart, text: 'Профиль'),
          GButton(icon: Icons.workspace_premium, text: 'Трекер'),
          GButton(icon: Icons.star, text: 'Рейтинг'),
        ],
      ),
    );
  }
}

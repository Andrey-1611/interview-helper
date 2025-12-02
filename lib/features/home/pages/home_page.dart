import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: s.interview),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: s.profile,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: s.tracker,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: s.rating),
        ],
      ),
    );
  }
}

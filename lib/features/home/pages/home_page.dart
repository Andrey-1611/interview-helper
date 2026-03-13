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
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(icon: Icon(Icons.chat), label: s.interview),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: s.profile),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium),
            label: s.tracker,
          ),
          NavigationDestination(icon: Icon(Icons.star), label: s.rating),
        ],
      ),
    );
  }
}

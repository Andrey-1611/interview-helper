import 'package:flutter/material.dart';

import 'history_page.dart';
import 'initial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Собеседование',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'История',
          ),
        ],
      ),
      body: _currentIndex == 0 ? InitialPage() : HistoryPage(),
    );
  }
}

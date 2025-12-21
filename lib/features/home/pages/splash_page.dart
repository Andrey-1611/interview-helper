import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.splashColor,
      body: Center(
        child: Image.asset('play_store_512.png', fit: BoxFit.contain),
      ),
    );
  }
}

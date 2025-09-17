import 'package:flutter/material.dart';

class NetworkFailure extends StatelessWidget {
  const NetworkFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Нет подключения к интернету',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

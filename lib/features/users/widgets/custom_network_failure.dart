import 'package:flutter/material.dart';

class CustomNetworkFailure extends StatelessWidget {
  const CustomNetworkFailure({super.key});

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

import 'package:flutter/material.dart';

class CustomNetworkFailure extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomNetworkFailure({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Нет подключения к интернету',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text('Попробовать еще раз'),
          ),
        ],
      ),
    );
  }
}

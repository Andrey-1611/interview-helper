import 'package:flutter/material.dart';

class CustomUnknownFailure extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomUnknownFailure({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Незвестная ошибка', style: theme.textTheme.displayLarge),
          TextButton(
            onPressed: onPressed,
            child: const Text('Попробовать еще раз'),
          ),
        ],
      ),
    );
  }
}

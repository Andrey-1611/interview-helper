import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomLoadingIndicator(),
          Text('Подождите...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

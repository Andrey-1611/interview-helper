import 'package:flutter/material.dart';
import 'package:interview_master/core/theme/app_colors.dart';

class CustomResultPanel extends StatelessWidget {
  final int score;
  const CustomResultPanel({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppPalette.primary, width: 4.0),
      ),
      child: Text(
        'Результат: $score ⭐️',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

import 'custom_score_indicator.dart';

class CustomQuestionCard extends StatelessWidget {
  final String text;
  final int? score;
  final bool isQuestionCard;

  const CustomQuestionCard({
    super.key,
    required this.text,
    required this.isQuestionCard,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppPalette.primary, width: 4.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: isQuestionCard ? ScoreIndicator(score: score!) : null,
        title: Text(text),
        trailing: isQuestionCard ? Icon(Icons.chevron_right) : null,
      ),
    );
  }
}


import 'package:flutter/material.dart';
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
      child: ListTile(
        leading: isQuestionCard ? CustomScoreIndicator(score: score!) : null,
        title: Text(text),
        trailing: isQuestionCard ? Icon(Icons.chevron_right) : null,
      ),
    );
  }
}

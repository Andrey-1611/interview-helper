import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'custom_score_indicator.dart';


class CustomQuestionCard extends StatelessWidget {
  final String text;
  final int? score;
  final bool isQuestionCard;
  final Color? color;

  const CustomQuestionCard({
    super.key,
    required this.text,
    required this.isQuestionCard,
    this.score,
    this.color
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
        contentPadding: EdgeInsets.all(20.0),
        leading: isQuestionCard ? ScoreIndicator(score: score!, color: color!) : null,
        title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        trailing: isQuestionCard ? Icon(Icons.chevron_right) : null,
      ),
    );
  }
}


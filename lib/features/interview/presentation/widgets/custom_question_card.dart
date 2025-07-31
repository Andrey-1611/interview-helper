import 'package:flutter/material.dart';

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
        side: BorderSide(color: Colors.blue, width: 4.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20.0),
        leading: isQuestionCard ? _ScoreIndicator(score: score!) : null,
        title: Text(text),
        trailing: isQuestionCard ? Icon(Icons.chevron_right) : null,
      ),
    );
  }
}

class _ScoreIndicator extends StatelessWidget {
  final int score;

  const _ScoreIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: score / 100),
          Text('${score.toInt()} %'),
        ],
      ),
    );
  }
}

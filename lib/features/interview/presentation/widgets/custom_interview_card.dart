import 'package:flutter/material.dart';

class CustomInterviewCard extends StatelessWidget {
  final int score;
  final String titleText;
  final String firstText;
  final String? secondText;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const CustomInterviewCard({
    super.key,
    this.secondText,
    required this.score,
    required this.titleText,
    required this.firstText,
    required this.titleStyle,
    required this.subtitleStyle,
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
        leading: _ScoreIndicator(score: score),
        title: Text(titleText, style: titleStyle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(firstText, style: subtitleStyle),
            secondText != null ? Text(secondText!, style: subtitleStyle) : SizedBox(),
          ],
        ),
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

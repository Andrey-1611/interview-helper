import 'package:flutter/material.dart';

class ScoreIndicator extends StatelessWidget {
  final int score;
  final Color color;

  const ScoreIndicator({super.key, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: score / 100, color: color),
          Text('$score %'),
        ],
      ),
    );
  }
}

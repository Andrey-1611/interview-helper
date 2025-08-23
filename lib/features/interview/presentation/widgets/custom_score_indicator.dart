import 'package:flutter/material.dart';

class CustomScoreIndicator extends StatelessWidget {
  final int score;

  const CustomScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      width: MediaQuery.sizeOf(context).height * 0.1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: score / 100),
          Text('$score %'),
        ],
      ),
    );
  }
}

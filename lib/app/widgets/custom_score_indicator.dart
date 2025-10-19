import 'package:flutter/material.dart';

class CustomScoreIndicator extends StatelessWidget {
  final int score;

  const CustomScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.08,
      width: size.height * 0.08,
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

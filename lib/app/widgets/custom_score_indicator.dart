import 'package:flutter/material.dart';

class CustomScoreIndicator extends StatelessWidget {
  final int score;
  final double? height;

  const CustomScoreIndicator({super.key, required this.score, this.height});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: height ?? size.height * 0.06,
      width: height ?? size.height * 0.06,
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

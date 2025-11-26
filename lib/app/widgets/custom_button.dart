import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? percentsWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.percentsWidth,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * (percentsWidth ?? 1),
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}

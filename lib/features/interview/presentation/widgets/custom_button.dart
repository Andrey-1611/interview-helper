import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color selectedColor;
  final VoidCallback onPressed;
  final double percentsWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.selectedColor,
    required this.onPressed,
    required this.percentsWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.07,
        width: MediaQuery.sizeOf(context).width * percentsWidth,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: selectedColor),
          child: Text(text),
        ),
      ),
    );
  }
}

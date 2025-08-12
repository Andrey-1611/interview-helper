import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            MediaQuery.sizeOf(context).width * 1,
            MediaQuery.sizeOf(context).height * 0.055,
          ),
          fixedSize: Size(
            MediaQuery.sizeOf(context).width * 1,
            MediaQuery.sizeOf(context).height * 0.055,
          ),
        ),
        child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}

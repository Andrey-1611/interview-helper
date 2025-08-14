import 'package:flutter/material.dart';

class CustomMainResultPanel extends StatelessWidget {
  final String text;

  const CustomMainResultPanel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.25,
        child: Text(text, style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}

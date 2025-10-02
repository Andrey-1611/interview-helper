import 'package:flutter/material.dart';

class CustomInfoCard extends StatelessWidget {
  final String titleText;
  final String subtitleText;

  const CustomInfoCard({super.key, required this.titleText, required this.subtitleText});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        title: Text(titleText, style: textTheme.displayMedium),
        subtitle: Text(subtitleText, style: textTheme.bodyLarge),
      ),
    );
  }
}

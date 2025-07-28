import 'package:flutter/material.dart';

class CustomQuestionCard extends StatelessWidget {
  final String text;
  final bool trailing;

  const CustomQuestionCard({super.key, required this.text, required this.trailing});

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
        title: Text(text),
        trailing: trailing ? Icon(Icons.chevron_right) : null,
      ),
    );
  }
}

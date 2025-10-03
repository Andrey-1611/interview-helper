import 'package:flutter/material.dart';
import '../../../core/constants/questions/icons.dart';

class CustomUserInfo extends StatelessWidget {
  final List<String> data;

  const CustomUserInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              child: ListTile(
                leading: Icon(icons[index]),
                title: Text(
                  data[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomMainResultPanel extends StatelessWidget {
  final String? type;
  final String text;

  const CustomMainResultPanel({super.key, required this.text, this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (type != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(type!, style: Theme.of(context).textTheme.displayLarge),
              ),
            Text(text, style: Theme.of(context).textTheme.displayLarge),
          ],
        ),
      ),
    );
  }
}

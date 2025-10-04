import 'package:flutter/material.dart';

class CustomMainResultPanel extends StatelessWidget {
  final String? type;
  final String text;

  const CustomMainResultPanel({super.key, required this.text, this.type});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (type != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(type!, style: textTheme.displayLarge),
              ),
            Text(text, style: textTheme.displayLarge),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final T? value;
  final List<(T, String?)> data;
  final Function(T?) change;
  final String hintText;

  const CustomDropdownMenu({
    super.key,
    required this.value,
    required this.data,
    required this.change,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        style: theme.textTheme.displaySmall,
        initialValue: value,
        items: data.map((item) {
          return DropdownMenuItem<T>(
            value: item.$1,
            child: Text(item.$2 ?? item.$1.toString()),
          );
        }).toList(),
        onChanged: change,
        menuMaxHeight: size.height * 0.5,
        hint: Text(hintText),
      ),
    );
  }
}

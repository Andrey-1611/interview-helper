import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<String> data;
  final ValueChanged<String> change;
  final String hintText;
  final String? value;

  const CustomDropdownMenu({
    super.key,
    this.value,
    required this.data,
    required this.change,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        style: theme.textTheme.displaySmall,
        value: value,
        items: data
            .map(
              (String value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)),
            )
            .toList(),
        onChanged: (String? value) {
          if (value != null) change(value);
        },
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        menuMaxHeight: size.height * 0.5,
        hint: Text(hintText),
      ),
    );
  }
}

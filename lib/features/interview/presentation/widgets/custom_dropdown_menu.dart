import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<String> data;
  final ValueChanged<String> change;
  final String hintText;
  final String? initialValue;

  const CustomDropdownMenu({
    super.key,
    this.initialValue,
    required this.data,
    required this.change,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu(
        initialSelection: initialValue,
        enableSearch: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: data
            .map(
              (direction) =>
                  DropdownMenuEntry(value: direction, label: direction),
            )
            .toList(),
        onSelected: (String? value) {
          if (value != null) change(value);
        },
        width: MediaQuery.sizeOf(context).width,
        hintText: hintText,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<String> data;
  final ValueChanged<String> change;
  final String hintText;

  const CustomDropdownMenu({
    super.key,
    required this.data,
    required this.change,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
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
    );
  }
}

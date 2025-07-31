import 'package:flutter/material.dart';
import '../../../../core/utils/field_vaildator.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? prefixIcon;
  final IconButton? iconButton;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.iconButton,
    this.obscureText = false,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        validator: (value) => fieldValidator(value, hintText),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: iconButton,
          hintText: hintText,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color selectedColor;
  final VoidCallback onPressed;
  final Color textColor;
  final double percentsHeight;
  final double percentsWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.selectedColor,
    required this.onPressed,
    required this.textColor,
    required this.percentsHeight,
    required this.percentsWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedColor,
          minimumSize: Size(
            MediaQuery.sizeOf(context).width * percentsWidth,
            MediaQuery.sizeOf(context).height * percentsHeight,
          ),
          fixedSize: Size(
            MediaQuery.sizeOf(context).width * percentsWidth,
            MediaQuery.sizeOf(context).height * percentsHeight,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}

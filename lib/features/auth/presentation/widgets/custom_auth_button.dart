import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(
            MediaQuery.sizeOf(context).width * 1,
            MediaQuery.sizeOf(context).height * 0.055,
          ),
          fixedSize: Size(
            MediaQuery.sizeOf(context).width * 1,
            MediaQuery.sizeOf(context).height * 0.055,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    );
  }
}

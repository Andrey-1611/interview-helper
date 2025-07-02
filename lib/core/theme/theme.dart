import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  final theme = ThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Colors.blue,
      surface: Colors.grey.shade100,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 38.sp,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 26.sp,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22.sp,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18.sp,
      ),
      bodySmall: TextStyle(
        fontSize: 18.sp,
        color: Colors.grey,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        side: BorderSide(width: 2, color: Colors.blueAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );

}

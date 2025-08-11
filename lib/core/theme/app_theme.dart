import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: Colors.blue,
        surface: Colors.grey.shade100,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 38.sp),
        displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 26.sp),
        displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.sp),
        bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
        bodySmall: TextStyle(fontSize: 18.sp, color: Colors.grey),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(12),
        hintStyle: TextStyle(color: Colors.grey),
        errorStyle: TextStyle(color: Colors.red),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: BorderSide(width: 2.sp, color: Colors.blueAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.sp),
          ),
        ),
      ),
    );
  }
}

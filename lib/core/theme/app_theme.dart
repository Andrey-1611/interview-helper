import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_pallete.dart';

class AppTheme {
  static getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppPalette.primary,
        secondary: AppPalette.primary,
        surface: AppPalette.background,
        error: AppPalette.error,
      ),
      scaffoldBackgroundColor: AppPalette.background,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.sp,
          color: AppPalette.textPrimary,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 21.sp,
          color: AppPalette.textPrimary,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppPalette.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17.sp,
          color: AppPalette.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15.sp,
          color: AppPalette.textSecondary,
        ),
        bodySmall: TextStyle(fontSize: 13.sp, color: AppPalette.textSecondary),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
          color: AppPalette.textPrimary,
        ),
        labelSmall: TextStyle(fontSize: 12.sp, color: AppPalette.textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.cardBackground.withValues(alpha: 0.8),

        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0.sp)),

        contentPadding: EdgeInsets.all(12.sp),

        hintStyle: TextStyle(color: AppPalette.textSecondary),
        errorStyle: TextStyle(color: AppPalette.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppPalette.textPrimary,
          backgroundColor: AppPalette.primary,
          textStyle: TextStyle(color: AppPalette.textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.sp),
          ),
          side: BorderSide(width: 2.sp, color: AppPalette.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.primary,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppPalette.cardBackground,
        margin: EdgeInsets.all(8.0.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0.sp),
          side: BorderSide.none,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.all(8.0.sp)
      )
    );
  }
}

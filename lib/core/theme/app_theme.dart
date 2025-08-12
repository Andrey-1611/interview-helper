import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/core/theme/app_colors.dart';

class AppTheme {
  static getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppPalette.primary,
        surface: AppPalette.background,
        error: AppPalette.error,
      ),
      scaffoldBackgroundColor: AppPalette.background,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.sp,
          color: AppPalette.textPrimary,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20.sp,
          color: AppPalette.textPrimary,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17.sp,
          color: AppPalette.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
          color: AppPalette.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppPalette.textSecondary,
        ),
        bodySmall: TextStyle(fontSize: 12.sp, color: AppPalette.textSecondary),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: Colors.white,
        ),
        labelSmall: TextStyle(fontSize: 11.sp, color: AppPalette.textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.cardBackground.withValues(alpha: 0.9),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.sp)),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPalette.primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPalette.error, width: 2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPalette.error, width: 2),
        ),

        contentPadding: EdgeInsets.all(12.sp),

        hintStyle: TextStyle(color: AppPalette.textSecondary),
        errorStyle: TextStyle(color: AppPalette.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: Colors.white,
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppPalette.cardBackground,
        selectedItemColor: AppPalette.primary,
        unselectedItemColor: AppPalette.textSecondary,
        showUnselectedLabels: true,
      ),
    );
  }
}

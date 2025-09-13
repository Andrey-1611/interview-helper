import 'package:flutter/material.dart';

/*class AppPalette {
  static const Color primary = Color(0xFF6366F1);

  static const Color background = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF2A2A2A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  static const transparent = Colors.transparent;
}*/

class AppPalette {
  static bool isDark = true;

  static const Color primary = Color(0xFF6366F1);
  static const Color error = Color(0xFFF44336);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const transparent = Colors.transparent;

  static Color get background =>
      isDark ? DarkPalette.background : LightPalette.background;

  static Color get cardBackground =>
      isDark ? DarkPalette.cardBackground : LightPalette.cardBackground;

  static Color get textPrimary =>
      isDark ? DarkPalette.textPrimary : LightPalette.textPrimary;
}

class DarkPalette {
  static const Color background = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
}

class LightPalette {
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1E1E1E);
}

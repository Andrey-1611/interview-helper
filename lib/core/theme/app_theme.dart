import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _primary = Color(0xFF6366F1);
const _darkCard = Color(0xFF2A2A2A);

const _splashColor = Color(0xFF0E1525);

const _hintColor = Color(0xFFB3B3B3);
const _lightBackground = Color(0xFFE8EAED);
const _darkBackground = Color(0xFF1E1E1E);

final darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _primary,
  inputDecorationTheme: _inputDecorationTheme(_darkCard),
  appBarTheme: _appBarTheme(_darkCard, Colors.white),
  listTileTheme: _listTileTheme,
  splashColor: _splashColor,
  cardTheme: _cardTheme(_darkCard),
  cardColor: _darkCard,
  textTheme: _textTheme,
  switchTheme: _switchTheme,
  navigationBarTheme: _navigationBarTheme(_darkCard, Colors.white),
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  scaffoldBackgroundColor: _darkBackground,
  hintColor: _hintColor,
  iconTheme: _iconTheme,
  colorScheme: ColorScheme.dark(primary: _primary, error: Colors.red),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _primary,
  splashColor: _splashColor,
  inputDecorationTheme: _inputDecorationTheme(Colors.white),
  appBarTheme: _appBarTheme(Colors.white, Colors.black),
  listTileTheme: _listTileTheme,
  cardTheme: _cardTheme(Colors.white),
  cardColor: _darkCard,
  textTheme: _textTheme,
  switchTheme: _switchTheme,
  navigationBarTheme: _navigationBarTheme(Colors.white, Colors.black),
  textButtonTheme: _textButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  scaffoldBackgroundColor: _lightBackground,
  bottomSheetTheme: _bottomSheetTheme(_lightBackground),
  hintColor: _hintColor,
  iconTheme: _iconTheme,
  colorScheme: ColorScheme.light(primary: _primary, error: Colors.red),
);

final _textTheme = TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 56.sp),
  titleMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 42.sp),
  displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp),
  displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
  displaySmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
  bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: _hintColor,
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: _hintColor,
  ),
  labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
);

InputDecorationTheme _inputDecorationTheme(Color color) => InputDecorationTheme(
  filled: true,
  fillColor: color,
  hintStyle: TextStyle(fontSize: 15.sp, color: _hintColor),
  contentPadding: EdgeInsets.all(12),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(8.0),
  ),
);

final _listTileTheme = ListTileThemeData(
  contentPadding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
  subtitleTextStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: _hintColor,
  ),
);

CardThemeData _cardTheme(Color color) => CardThemeData(
  color: color,
  margin: EdgeInsets.all(8.sp),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.sp),
    side: BorderSide.none,
  ),
);

AppBarTheme _appBarTheme(Color color, Color titleColor) => AppBarTheme(
  centerTitle: true,
  backgroundColor: color,
  titleTextStyle: TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: titleColor,
  ),
  surfaceTintColor: Colors.transparent,
);

NavigationBarThemeData _navigationBarTheme(Color color, Color iconColor) =>
    NavigationBarThemeData(
      backgroundColor: color,
      indicatorColor: _primary,
      iconTheme: WidgetStateProperty.all(IconThemeData(color: iconColor)),
    );

final _textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
    foregroundColor: _primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: _primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
);

final _switchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith((states) {
    return states.contains(WidgetState.selected) ? Colors.white : _primary;
  }),
);

BottomSheetThemeData _bottomSheetTheme(Color color) =>
    BottomSheetThemeData(backgroundColor: color);

final _iconTheme = IconThemeData(color: Colors.white);

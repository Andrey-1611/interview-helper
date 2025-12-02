import 'package:flutter/material.dart';

const _primary = Color(0xFF6366F1);
const _darkCard = Color(0xFF2A2A2A);

const _hintColor = Color(0xFFB3B3B3);
const _lightBackground = Color(0xFFE8EAED);
const _darkBackground = Color(0xFF1E1E1E);

ThemeData darkTheme(double width) => ThemeData(
  useMaterial3: true,
  primaryColor: _primary,
  inputDecorationTheme: _inputDecorationTheme(_darkCard),
  appBarTheme: _appBarTheme(_darkCard, Colors.white),
  listTileTheme: _listTileTheme,
  cardTheme: _cardTheme(_darkCard),
  cardColor: _darkCard,
  textTheme: _textTheme(width),
  switchTheme: _switchTheme,
  bottomNavigationBarTheme: _bottomNavigationBarTheme(_darkCard),
  textButtonTheme: _textButtonTheme(width),
  elevatedButtonTheme: _elevatedButtonTheme,
  scaffoldBackgroundColor: _darkBackground,
  hintColor: _hintColor,
  iconTheme: _iconTheme,
  colorScheme: ColorScheme.dark(primary: _primary, error: Colors.red),
);

ThemeData lightTheme(double width) => ThemeData(
  useMaterial3: true,
  primaryColor: _primary,
  inputDecorationTheme: _inputDecorationTheme(Colors.white),
  appBarTheme: _appBarTheme(Colors.white, Colors.black),
  listTileTheme: _listTileTheme,
  cardTheme: _cardTheme(Colors.white),
  cardColor: _darkCard,
  textTheme: _textTheme(width),
  switchTheme: _switchTheme,
  bottomNavigationBarTheme: _bottomNavigationBarTheme(Colors.white),
  textButtonTheme: _textButtonTheme(width),
  elevatedButtonTheme: _elevatedButtonTheme,
  scaffoldBackgroundColor: _lightBackground,
  bottomSheetTheme: _bottomSheetTheme(_lightBackground),
  hintColor: _hintColor,
  iconTheme: _iconTheme,
  colorScheme: ColorScheme.light(primary: _primary, error: Colors.red),
);

TextTheme _textTheme(double width) => TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 60.a(width)),
  titleMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 45.a(width)),
  displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.a(width)),
  displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.a(width)),
  displaySmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.a(width)),
  bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.a(width)),
  bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.a(width)),
  labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.a(width)),
);

InputDecorationTheme _inputDecorationTheme(Color color) => InputDecorationTheme(
  filled: true,
  fillColor: color,
  hintStyle: TextStyle(fontSize: 15, color: _hintColor),
  contentPadding: EdgeInsets.all(12),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(8.0),
  ),
);

final _listTileTheme = ListTileThemeData(
  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
);

CardThemeData _cardTheme(Color color) => CardThemeData(
  color: color,
  margin: EdgeInsets.all(8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    side: BorderSide.none,
  ),
);

AppBarTheme _appBarTheme(Color color, Color titleColor) => AppBarTheme(
  centerTitle: true,
  backgroundColor: color,
  titleTextStyle: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: titleColor,
  ),
  surfaceTintColor: Colors.transparent,
);

BottomNavigationBarThemeData _bottomNavigationBarTheme(Color color) =>
    BottomNavigationBarThemeData(
      backgroundColor: color,
      selectedItemColor: _primary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12),
      selectedIconTheme: IconThemeData(size: 26),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );

TextButtonThemeData _textButtonTheme(double width) => TextButtonThemeData(
  style: TextButton.styleFrom(
    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.a(width)),
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

extension AdaptiveText on int {
  double a(double width) => width * this / 430;
}

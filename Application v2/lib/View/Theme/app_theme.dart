import 'package:flutter/material.dart';

class AppTheme
{

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF67B7DD),
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: DrawerThemeData(
        backgroundColor: Color(0xFFE3E3E3)
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF67B7DD),
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF67B7DD),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade700,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xFF67B7DD),
      selectionColor: Color(0xFF67B7DD).withValues(alpha: 0.3),
      selectionHandleColor: Color(0xFF67B7DD),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF7CC4E8),
      contentTextStyle: TextStyle(color: Colors.black),
    )
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF0874AC),
    scaffoldBackgroundColor: Color(0xFF151515),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E)
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0874AC),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0874AC),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade500,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xFF0874AC),
      selectionColor: Color(0xFF0874AC).withValues(alpha: 0.3),
      selectionHandleColor: Color(0xFF0874AC),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF0B92DA),
      contentTextStyle: TextStyle(color: Colors.white),
    )
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final setLightTheme = _buildLightTheme();
final setDarkTheme = _buildDarkTheme();

ThemeData _buildLightTheme() {
  return ThemeData(
    primaryColor: Color(0xFF2867B2),
    // brightness: Brightness.light,
    // accentColor: Colors.black, // problem solved - color
    // dividerColor: Colors.black12,
    splashColor: Colors.white54,
    // scaffoldBackgroundColor: Colors.white,
    cursorColor: Color(0xFF2867B2),
  );
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    primaryColor: Color(0xFF272727),
    brightness: Brightness.dark,
    // backgroundColor: const Color(0xFF212121), // aa sena mate
    accentColor: Colors.white54, // problem solved - color
    splashColor: Colors.white54,
    dividerColor: Colors.black12,
    scaffoldBackgroundColor: Color(0xFF121212), // find appropriate color

    cursorColor: Colors.white,

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF272727),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

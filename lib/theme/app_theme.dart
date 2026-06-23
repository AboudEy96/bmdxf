import 'package:flutter/material.dart';

abstract class AppTheme {
  static const primary  = Color(0xFF00FF41);
  static const surface  = Color(0xFF0D1117);
  static const scaffold = Color(0xFF0A0A0A);

  static const radius = 8.0;

  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primary,
      surface: surface,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: scaffold,
    fontFamily: 'monospace',
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: const Color(0xFF0D1117),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: const Color(0xFF00FF41), width: 1),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF00FF41).withOpacity(0.15),
        blurRadius: 10,
        offset: const Offset(0, 0),
      ),
    ],
  );
}
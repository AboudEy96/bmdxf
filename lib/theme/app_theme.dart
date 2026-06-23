import 'package:flutter/material.dart';


abstract class AppTheme {
  static const scaffold   = Color(0xFF05080A);
  static const surface    = Color(0xFF0D1411);
  static const surfaceAlt = Color(0xFF121A16);
  static const appBar     = Color(0xFF0A0F0C);
  static const primary    = Color(0xFF4ADE80);
  static const primaryDim = Color(0xFF2E8F58);
  static const textPrimary   = Color(0xFFE6F4EA);
  static const textSecondary = Color(0xFF8FB39C);
  static const textMuted     = Color(0xFF55715F);
  static const danger  = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFC857);
  static const info    = Color(0xFF63C9E8);

  static const radius = 10.0;

  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primary,
      surface: surface,
      error: danger,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: scaffold,
    fontFamily: 'monospace',
    appBarTheme: const AppBarTheme(
      backgroundColor: appBar,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: true,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceAlt,
      behavior: SnackBarBehavior.floating,
      contentTextStyle: const TextStyle(
        color: textPrimary,
        fontFamily: 'monospace',
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceAlt,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: primary.withOpacity(0.3)),
      ),
    ),
  );

  static BoxDecoration cardDecoration({Color? accent}) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: (accent ?? primary).withOpacity(0.35),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: (accent ?? primary).withOpacity(0.08),
        blurRadius: 14,
        offset: const Offset(0, 0),
      ),
    ],
  );
}
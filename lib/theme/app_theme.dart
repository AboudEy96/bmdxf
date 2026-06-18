import 'package:flutter/material.dart';

abstract class AppTheme {
  static const primary   = Color(0xFF2563EB);
  static const surface   = Colors.white;
  static const scaffold  = Color(0xFFF8FAFC);

  static const radius = 12.0;

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
        scaffoldBackgroundColor: scaffold,
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/exif_reader_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPLOAD FILE AND READ THE DATA BEHIND -',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ExifReaderPage(),
    );
  }
}

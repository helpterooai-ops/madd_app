import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MaddApp());
}

class MaddApp extends StatelessWidget {
  const MaddApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مَــدّ',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'IBMPlexSansArabic',
        scaffoldBackgroundColor: const Color(0xFF0B0B0E),
        primaryColor: const Color(0xFFE2B858),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE2B858),
          secondary: Color(0xFFF5D77F),
          surface: Color(0xFF16161E),
          background: Color(0xFF0B0B0E),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

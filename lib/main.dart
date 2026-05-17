import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillBarter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1B3A2D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF72),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

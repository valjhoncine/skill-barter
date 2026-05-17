import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A2D),
      body: Stack(
        children: [
          Positioned(top: -60, right: -60,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(bottom: -80, left: -50,
            child: Container(width: 220, height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D),
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF72),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text('SB',
                      style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('SkillBarter',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text('SKILL EXCHANGE COMMUNITY',
                  style: TextStyle(fontSize: 12, color: Color(0xFFA3C4A8),
                    letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                const Text('Trade skills. Grow together.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A),
                    fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 60),
                Container(width: 80, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF72),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Loading......',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6AAD7A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

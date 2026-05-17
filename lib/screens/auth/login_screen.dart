import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  void setLoading(bool s) {
    setState(() {
      isLoading = s;
    });
  }

  Future<void> loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please make sure to fill all fields.')),
      );
      return;
    }
    setLoading(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String? error = e.message ?? "Login Failed";
      error = error.contains("auth credential is incorrect")
          ? "Invalid credentials."
          : error;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A2D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF72),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'SB',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Login to your account',
                style: TextStyle(fontSize: 13, color: Color(0xFFA3C4A8)),
              ),
              const SizedBox(height: 32),
              _buildInputField(
                'Email',
                'you@email.com',
                _emailController,
                false,
              ),
              const SizedBox(height: 14),
              _buildInputField(
                'Password',
                '••••••••',
                _passwordController,
                true,
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 12, color: Color(0xFF4CAF72)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loginUser,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B3A2D),
                          ),
                        ),
                ),
              ),
              // const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(child: Divider(color: const Color(0xFF2D5A3D))),
              //     const Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 10),
              //       child: Text(
              //         'or continue with',
              //         style: TextStyle(fontSize: 11, color: Color(0xFF6AAD7A)),
              //       ),
              //     ),
              //     Expanded(child: Divider(color: const Color(0xFF2D5A3D))),
              //   ],
              // ),
              // const SizedBox(height: 16),
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: OutlinedButton(
              //     style: OutlinedButton.styleFrom(
              //       side: const BorderSide(color: Color(0xFF2D5A3D)),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: const Text(
              //       'Sign in with Google',
              //       style: TextStyle(fontSize: 14, color: Color(0xFFA3C4A8)),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF72),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF6AAD7A), fontSize: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA3C4A8)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

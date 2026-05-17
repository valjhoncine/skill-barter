import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              const Text('Create an Account',
                style: TextStyle(fontSize: 26,
                  fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text('Join the Skill Community',
                style: TextStyle(fontSize: 13, color: Color(0xFFA3C4A8)),
              ),
              const SizedBox(height: 32),
              _buildInputField('Full Name', 'Juan dela Cruz', _nameController, false),
              const SizedBox(height: 14),
              _buildInputField('Email', 'you@email.com', _emailController, false),
              const SizedBox(height: 14),
              _buildInputField('Password', '••••••••', _passwordController, true),
              const SizedBox(height: 14),
              _buildInputField('Confirm Password', '••••••••', _confirmPasswordController, true),
              const SizedBox(height: 28),
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
                  onPressed: () {},
                  child: const Text('Create Account',
                    style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold, color: Color(0xFF1B3A2D)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an account? ",
                  style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A))),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Login',
                    style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.bold, color: Color(0xFF4CAF72))),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      TextEditingController controller, bool isPassword) {
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

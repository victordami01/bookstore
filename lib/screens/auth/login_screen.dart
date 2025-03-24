import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1), // Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Join Our Community of\nBook Lovers",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField("Name", "Enter your name"),
            _buildTextField("Email", "Enter your email"),
            _buildPasswordField("Password"),
            _buildPasswordField("Re-Password"),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 24),
            _buildSocialLoginOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black45),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: const TextStyle(color: Colors.black45),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.visibility_off, color: Colors.black45),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7857FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          minimumSize: const Size(double.infinity, 22),
        ),
        onPressed: () {},
        child: const Text(
          "Log In",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: Colors.black26)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("or Sign up via",
                  style: TextStyle(color: Colors.black54)),
            ),
            Expanded(child: Divider(color: Colors.black26)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon("assets/google.svg"),
            const SizedBox(width: 24),
            _buildSocialIcon("assets/apple.svg"),
            const SizedBox(width: 24),
            _buildSocialIcon("assets/facebook.svg"),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String assetName) {
    return InkWell(
      onTap: () {},
      child: SvgPicture.asset(assetName, width: 40, height: 40),
    );
  }
}

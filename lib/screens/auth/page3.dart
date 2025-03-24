import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Start Your Journey!",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const SizedBox(height: 10),
        const Text(
          "Join a community of book lovers",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Navigate to home or login
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Get Started"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/book.png",
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 20),
        const Text(
          "Book Stack",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const SizedBox(height: 10),
        const Text(
          "Your digital library",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}

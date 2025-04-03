import 'package:book/utils/theme.dart';
import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 243, 239),
      body: Center(
        // This centers the Column both horizontally & vertically
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensures content doesn't take full height
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/book.png",
              color: AppColors.primary,
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20), // Add some spacing
            Text(
              "Book Stack",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ],  
        ),
      ),
    );
  }
}

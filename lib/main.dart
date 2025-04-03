// main.dart
import 'package:flutter/material.dart';
import 'package:book/screens/auth/login_screen.dart';
import 'package:book/screens/auth/signup_screen.dart';
import 'package:book/utils/view.dart';
import 'package:book/screens/search/search_screen.dart';
import 'package:book/screens/shop/shopping_cart_screen.dart';
import 'package:book/components/navbar.dart';
import 'package:book/screens/profile/user_profile_screen.dart';
import 'package:book/screens/shop/checkout_screen.dart';
import 'package:book/screens/profile/order_history_screen.dart'; // Add this
import 'package:book/components/navbar.dart';

void main() {
  print("Firebase initialized!");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
        '/search': (context) => const SearchScreen(),
        '/cart': (context) => const CartScreen(),
        '/order_history': (context) => const OrderHistoryScreen(), // Optional
      },
    );
  }
}

import 'package:book/screens/auth/login_screen.dart';
import 'package:book/screens/auth/onboard.dart';
import 'package:book/screens/home/book_catalog_screen.dart';
import 'package:book/utils/view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

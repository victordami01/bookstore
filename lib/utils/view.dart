import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../screens/auth/page1.dart';
import '../screens/auth/page2.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 243, 239),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [
                  Page1(),
                  Page2(),
                ],
              ),
            ),

            // Page Indicator using smooth_page_indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.purple,
                dotColor: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

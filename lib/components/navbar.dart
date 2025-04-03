import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Add iconsax package for modern icons
import 'package:book/screens/home/book_catalog_screen.dart';
import 'package:book/screens/home/categories_page.dart';
import 'package:book/screens/shop/shopping_cart_screen.dart'; // Updated to new CartScreen
import 'package:book/screens/profile/user_profile_screen.dart';
import 'package:book/services/cart_manager.dart'; // Import CartManager for item count

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BookCatalogScreen(),
    CategoriesPage(),
    const CartScreen(),
    const UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF7857FC),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.category), label: 'Categories'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Iconsax.shopping_cart),
                  if (CartManager.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${CartManager.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.profile_circle), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

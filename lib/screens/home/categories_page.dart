import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'category_books_page.dart';

class CategoriesPage extends StatelessWidget {
  // Data for categories (12 categories)
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Fantasy',
      'books': '365 books',
      'icon': Iconsax.magicpen,
    },
    {
      'name': 'Mystery',
      'books': '298 books',
      'icon': Iconsax.mask,
    },
    {
      'name': 'Thriller',
      'books': '540 books',
      'icon': Iconsax.eye,
    },
    {
      'name': 'Fiction',
      'books': '167 books',
      'icon': Iconsax.star,
    },
    {
      'name': 'Science Fiction',
      'books': '121 books',
      'icon': Iconsax.cpu,
    },
    {
      'name': 'Romance',
      'books': "246 books",
      'icon': Iconsax.heart,
    },
    {
      'name': 'Historical Fiction',
      'books': '121 books',
      'icon': Iconsax.book,
    },
    {
      'name': 'Horror',
      'books': '68 books',
      'icon': Iconsax.ghost,
    },
    {
      'name': 'Young Adult',
      'books': '230 books',
      'icon': Iconsax.tree,
    },
    {
      'name': 'Adventure',
      'books': '180 books',
      'icon': Iconsax.map,
    },
    {
      'name': 'Non-Fiction',
      'books': '310 books',
      'icon': Iconsax.document,
    },
    {
      'name': 'Biography',
      'books': '150 books',
      'icon': Iconsax.profile_2user,
    },
  ];
 CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 248, 243, 239), // Light background color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 243, 239),
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65, // Adjusted for much larger icons
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              icon: categories[index]['icon'],
              name: categories[index]['name'],
              books: categories[index]['books'],
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String books;

  const CategoryCard({super.key, 
    required this.icon,
    required this.name,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryBooksPage(category: name),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 226, 231),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            books,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
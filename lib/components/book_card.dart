import 'package:book/utils/theme.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double price;
  final double rating;

  const BookCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    this.rating = 4, // Default rating
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6), // Rounded corners
            child: Image.network(
              imageUrl,
              height: 160,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6), // Space between image and rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 12, // Smaller stars
              );
            }),
          ),
          const SizedBox(height: 4), // Space between rating and title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800, // Bold title
              color: AppColors.primaryText, // Dark color for title
            ),
          ),
          const SizedBox(height: 2), // Space between title and author
          Text(
            author,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryText, // Grey author text
            ),
          ),
          const SizedBox(height: 4), // Space between author and price
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 43, 100), // Pink price color
            ),
          ),
        ],
      ),
    );
  }
}

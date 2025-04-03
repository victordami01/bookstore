import 'package:flutter/material.dart';
import 'package:book/screens/home/book_details_screen.dart'; // Import the detail screen

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double price;
  final double rating;
  final dynamic book;
  final VoidCallback? onBuy; // Add this for the Buy Now action

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    this.rating = 4.0,
    required this.book,
    this.onBuy, // Optional callback for buying
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
      child: Container(
        width: 120, // Fixed width
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Book Image
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/placeholder.png",
                    width: 120,
                    height: 160,
                  );
                },
              ),
            ),
            const SizedBox(height: 6),

            // Rating Row
            SizedBox(
              height: 14,
              child: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 12,
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),

            // Book Title
            SizedBox(
              height: 12,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Author Name
            Text(
              author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),

            // Price and Buy Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                // GestureDetector(
                //   onTap: onBuy, // Trigger the buy action
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                //     decoration: BoxDecoration(
                //       color: Colors.deepPurple,
                //       borderRadius: BorderRadius.circular(4),
                //     ),
                //     child: const Text(
                //       'Buy',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
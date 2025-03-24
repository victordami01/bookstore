import 'package:flutter/material.dart';
import 'package:book/components/book_card.dart';

class BookCatalogScreen extends StatefulWidget {
  const BookCatalogScreen({super.key});

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 2.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
          BookCard(
            imageUrl:
                "https://images.squarespace-cdn.com/content/v1/624da83e75ca872f189ffa42/aa45e942-f55d-432d-8217-17c7d98105ce/image001.jpg",
            title: "Displacement",
            author: "Kiku Hughes",
            price: 16.55,
            rating: 4.0,
          ),
        ],
      ),
    ));
  }
}

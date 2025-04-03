import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book/screens/home/book_details_screen.dart'; // Updated import

class CategoryBooksPage extends StatefulWidget {
  final String category;

  const CategoryBooksPage({super.key, required this.category});

  @override
  _CategoryBooksPageState createState() => _CategoryBooksPageState();
}

class _CategoryBooksPageState extends State<CategoryBooksPage> {
  List books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final url = Uri.parse(
        'https://openlibrary.org/subjects/${widget.category.toLowerCase()}.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          books = data['works']; // Open Library stores books under "works"
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Books'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text('No books found for this category'))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      leading: book['cover_id'] != null
                          ? Image.network(
                              'https://covers.openlibrary.org/b/id/${book['cover_id']}-M.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.book, size: 50),
                      title: Text(book['title'] ?? 'Unknown Title'),
                      subtitle: Text(
                        book['authors'] != null && book['authors'].isNotEmpty
                            ? book['authors'][0]['name']
                            : 'Unknown Author',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(book: book),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

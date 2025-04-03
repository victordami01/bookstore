// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book/screens/home/book_details_screen.dart'; // Adjust path

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List books = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      books = [];
    });

    final url = Uri.parse('https://openlibrary.org/search.json?q=${Uri.encodeQueryComponent(query)}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          books = data['docs'] ?? []; // Open Library search results are under "docs"
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching books. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      books = [];
                      errorMessage = null;
                    });
                  },
                ),
              ),
              onSubmitted: _searchBooks, // Trigger search on Enter
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : books.isEmpty
                        ? const Center(child: Text('No books found. Try a search!'))
                        : ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return ListTile(
                                leading: book['cover_i'] != null
                                    ? Image.network(
                                        'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.book, size: 50),
                                title: Text(book['title'] ?? 'Unknown Title'),
                                subtitle: Text(
                                  book['author_name'] != null && book['author_name'].isNotEmpty
                                      ? book['author_name'][0]
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
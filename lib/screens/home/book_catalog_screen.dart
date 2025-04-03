import 'dart:convert';
import 'package:book/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:book/components/book_card.dart'; // Adjust path
import 'package:book/services/cart_manager.dart'; // Import cart manager
import 'package:book/screens/shop/shopping_cart_screen.dart';

class BookCatalogScreen extends StatefulWidget {
  const BookCatalogScreen({super.key});

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
  List<String> categories = ["All Books", "Horror", "Comics", "History"];
  int selectedIndex = 0;

  List<dynamic> bestSellers = [];
  List<dynamic> trendingBooks = [];
  List<dynamic> newArrivals = [];
  List<dynamic> editorsPicks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllBooks();
  }

  Future<void> fetchBooks(
      String category, Function(List<dynamic>) updateList) async {
    final url = Uri.parse(
      'https://openlibrary.org/search.json?q=subject:$category&fields=key,title,author_name,cover_i,editions&limit=20',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      updateList(data["docs"] ?? []);
    } else {
      throw Exception("Failed to load books for $category");
    }
  }

  Future<void> fetchAllBooks() async { // Added missing '{'
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchBooks("bestsellers", (data) => bestSellers = data),
        fetchBooks("horror", (data) => trendingBooks = data),
        fetchBooks("new", (data) => newArrivals = data),
        fetchBooks("fiction", (data) => editorsPicks = data),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching books: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildBookSection(String title, List<dynamic> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 250,
          child: books.isEmpty
              ? const Center(child: Text("No books found"))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final bookTitle = book["title"] ?? "Unknown Title";
                    final author = (book["author_name"] != null &&
                            book["author_name"].isNotEmpty)
                        ? book["author_name"][0]
                        : "Unknown Author";
                    final coverId = book["cover_i"]?.toString();
                    final imageUrl = coverId != null
                        ? "https://covers.openlibrary.org/b/id/$coverId-M.jpg"
                        : "https://via.placeholder.com/150";

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: BookCard(
                        imageUrl: imageUrl,
                        title: bookTitle,
                        author: author,
                        price: 10.99,
                        rating: 4.0,
                        book: book,
                        onBuy: () {
                          CartManager.addToCart(book);
                          setState(() {}); // Update badge
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('$bookTitle added to cart!')),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bookstore",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset("assets/images/logo.png"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              String category = categories[index].toLowerCase();
                              if (category == "all books") {
                                fetchAllBooks();
                              } else {
                                fetchBooks(category, (data) {
                                  setState(() {
                                    bestSellers = data;
                                    trendingBooks = [];
                                    newArrivals = [];
                                    editorsPicks = [];
                                  });
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildBookSection("Best Selling Books", bestSellers),
                  buildBookSection("Trending Books", trendingBooks),
                  buildBookSection("New Arrivals", newArrivals),
                  buildBookSection("Editor's Picks", editorsPicks),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Stack(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
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
      ),
    );
  }
}
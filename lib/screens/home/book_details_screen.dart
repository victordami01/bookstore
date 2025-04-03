// screens/book_detail_screen.dart (partial update)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:book/services/cart_manager.dart';
import 'package:book/services/wishlist_manager.dart'; // Add this
import 'package:book/screens/shop/shopping_cart_screen.dart'; // Updated path
import 'package:book/services/utils.dart'; // Add this for mock pricing

class BookDetailScreen extends StatefulWidget {
  final dynamic book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _showFullDescription = false;

  @override
  void initState() {
    super.initState();
    // Assign mock price if not already set
    if (widget.book['price'] == null) {
      widget.book['price'] = generateMockPrice();
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart(dynamic book) {
    CartManager.addToCart(book);
    setState(() {}); // Update badge
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${book["title"]} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.book["title"] ?? "Unknown Title";
    final String author = (widget.book["author_name"] != null &&
            widget.book["author_name"].isNotEmpty)
        ? widget.book["author_name"][0]
        : "Unknown Author";
    final String coverId = widget.book["cover_i"]?.toString() ?? "";
    final String imageUrl = coverId.isNotEmpty
        ? "https://covers.openlibrary.org/b/id/$coverId-L.jpg"
        : "https://via.placeholder.com/300x400";
    final String key = widget.book["key"] ?? "";
    final bool isFavorited = WishlistManager.isInWishlist(widget.book);
    final double price = widget.book['price'] as double;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    Share.share(
                        'Check out "$title" by $author on Open Library: https://openlibrary.org$key');
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: Colors.black87, blurRadius: 6),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'book-cover-$key',
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, size: 120),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'by $author',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.grey[800],
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < 4
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber.shade700,
                                            size: 22,
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '4.0 (1.2K)',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.deepPurple.withOpacity(0.3)),
                              ),
                              child: Text(
                                'Fiction',
                                style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        FutureBuilder(
                          future: fetchBookDetails(key),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final pages = snapshot.data?['pages'] ?? 'N/A';
                            final year = snapshot.data?['year'] ?? 'N/A';
                            final language =
                                snapshot.data?['language'] ?? 'N/A';
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem('Pages', pages, Icons.book),
                                _buildStatItem(
                                    'Year', year, Icons.calendar_today),
                                _buildStatItem(
                                    'Language', language, Icons.language),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About this book',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[900],
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FutureBuilder(
                                future: fetchBookDetails(key),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.deepPurple),
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return Text(
                                      'No description available',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                  final description =
                                      snapshot.data?['description'] ??
                                          'No description available';
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedCrossFade(
                                        firstChild: SizedBox(
                                          height: 100,
                                          child: Text(
                                            description,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              height: 1.7,
                                              fontSize: 16,
                                              letterSpacing: 0.3,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        secondChild: Text(
                                          description,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            height: 1.7,
                                            fontSize: 16,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        crossFadeState: _showFullDescription
                                            ? CrossFadeState.showSecond
                                            : CrossFadeState.showFirst,
                                        duration:
                                            const Duration(milliseconds: 300),
                                      ),
                                      if (description.length > 100)
                                        const SizedBox(height: 12),
                                      if (description.length > 100)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showFullDescription =
                                                  !_showFullDescription;
                                            });
                                          },
                                          child: Text(
                                            _showFullDescription
                                                ? 'Show Less'
                                                : 'Show More',
                                            style: TextStyle(
                                              color: Colors.deepPurple[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isFavorited) {
                                        WishlistManager.removeFromWishlist(
                                            widget.book);
                                      } else {
                                        WishlistManager.addToWishlist(
                                            widget.book);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFavorited
                                        ? Colors.deepPurple[700]
                                        : Colors.white,
                                    foregroundColor: isFavorited
                                        ? Colors.white
                                        : Colors.deepPurple,
                                    elevation: 6,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: isFavorited
                                            ? Colors.deepPurple[700]!
                                            : Colors.deepPurple
                                                .withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    shadowColor:
                                        Colors.deepPurple.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isFavorited
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Wishlist',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isFavorited
                                              ? Colors.white
                                              : Colors.deepPurple[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: ElevatedButton(
                                  onPressed: () => _addToCart(widget.book),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[700],
                                    foregroundColor: Colors.white,
                                    elevation: 6,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadowColor:
                                        Colors.deepPurple.withOpacity(0.4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.shopping_cart, size: 24),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
          child: Icon(icon, color: Colors.deepPurple[700], size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> fetchBookDetails(String key) async {
    if (key.isEmpty) return {};
    try {
      final response =
          await http.get(Uri.parse('https://openlibrary.org$key.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String? description = data['description'] is String
            ? data['description']
            : data['description'] is Map
                ? data['description']['value']
                : 'No description available';
        return {
          'description': description,
          'pages': data['number_of_pages']?.toString() ?? 'N/A',
          'year': data['first_publish_date']?.substring(0, 4) ?? 'N/A',
          'language': data['languages']?.isNotEmpty ?? false
              ? data['languages'][0]['key'].split('/').last
              : 'N/A',
        };
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
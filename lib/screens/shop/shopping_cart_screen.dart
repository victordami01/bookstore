import 'package:flutter/material.dart';
import 'package:book/services/cart_manager.dart';
import 'package:book/screens/shop/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice =>
      CartManager.cart.fold(0, (sum, book) => sum + (book['price'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CartManager.itemCount == 0
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: CartManager.cart.length,
                    itemBuilder: (context, index) {
                      final book = CartManager.cart[index];
                      final title = book["title"] ?? "Unknown Title";
                      final author = (book["author_name"] != null &&
                              book["author_name"].isNotEmpty)
                          ? book["author_name"][0]
                          : (book["authors"] != null &&
                                  book["authors"].isNotEmpty)
                              ? book["authors"][0]['name']
                              : "Unknown Author";
                      final coverId =
                          book["cover_i"]?.toString() ?? book["cover_id"]?.toString();
                      final imageUrl = coverId != null && coverId.isNotEmpty
                          ? "https://covers.openlibrary.org/b/id/$coverId-M.jpg"
                          : "https://via.placeholder.com/150";
                      final price = book['price'] as double;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10), // Corrected typo
                        elevation: 2,
                        child: ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.book, size: 50),
                          ),
                          title: Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(author),
                              const SizedBox(height: 4),
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_shopping_cart,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                CartManager.removeFromCart(book);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('$title removed from cart')),
                              );
                            },
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: CartManager.itemCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutScreen(totalPrice: totalPrice),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
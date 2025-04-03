import 'package:flutter/material.dart';
import 'package:book/services/order_manager.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: OrderManager.orders.isEmpty
          ? const Center(
              child: Text(
                'No orders yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: OrderManager.orders.length,
              itemBuilder: (context, index) {
                final order = OrderManager.orders[index];
                final orderId = order['orderId'] as String;
                final totalPrice = order['totalPrice'] as double;
                final itemCount = order['itemCount'] as int;
                final date = order['date'] as DateTime;
                final items = order['items'] as List<dynamic>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10), // Fixed typo
                  elevation: 2,
                  child: ExpansionTile(
                    leading: const Icon(Icons.receipt, color: Colors.deepPurple),
                    title: Text(
                      'Order #$orderId',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Date: ${DateFormat('MMMM d, yyyy').format(date)}',
                    ),
                    trailing: Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Items ($itemCount):',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...items.map((book) {
                              final title = book['title'] ?? 'Unknown Title';
                              final author = (book['author_name'] != null &&
                                      book['author_name'].isNotEmpty)
                                  ? book['author_name'][0]
                                  : (book['authors'] != null &&
                                          book['authors'].isNotEmpty)
                                      ? book['authors'][0]['name']
                                      : 'Unknown Author';
                              final price = book['price'] as double;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4), // Fixed typo
                                child: Text(
                                  '• $title by $author - \$${price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
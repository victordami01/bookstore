// services/order_manager.dart
class OrderManager {
  static final List<Map<String, dynamic>> _orders = [];

  static List<Map<String, dynamic>> get orders => _orders;

  static void addOrder({
    required String orderId,
    required double totalPrice,
    required int itemCount,
    required DateTime date,
    required List<dynamic> items,
  }) {
    _orders.add({
      'orderId': orderId,
      'totalPrice': totalPrice,
      'itemCount': itemCount,
      'date': date,
      'items': items,
    });
  }

  static void clearOrders() {
    _orders.clear();
  }
}
// cart_manager.dart
class CartManager {
  static final List<dynamic> _cart = [];

  static List<dynamic> get cart => _cart;

  static void addToCart(dynamic book) {
    if (!_cart.contains(book)) {
      _cart.add(book);
    }
  }

  static void removeFromCart(dynamic book) {
    _cart.remove(book);
  }

  static void clearCart() {
    _cart.clear();
  }

  static int get itemCount => _cart.length;
}

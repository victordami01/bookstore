// services/wishlist_manager.dart
class WishlistManager {
  static final List<dynamic> _wishlist = [];

  static List<dynamic> get wishlist => _wishlist;

  static void addToWishlist(dynamic book) {
    if (!_wishlist.contains(book)) {
      _wishlist.add(book);
    }
  }

  static void removeFromWishlist(dynamic book) {
    _wishlist.remove(book);
  }

  static bool isInWishlist(dynamic book) => _wishlist.contains(book);

  static void clearWishlist() {
    _wishlist.clear();
  }
}
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => List.unmodifiable(_wishlistItems);
  int get itemCount => _wishlistItems.length;

  bool isInWishlist(Product product) {
    return _wishlistItems.any((item) => item.id == product.id);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      _wishlistItems.add(product);
    }
    notifyListeners();
  }

  void removeFromWishlist(Product product) {
    _wishlistItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}

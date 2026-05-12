import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get grossTotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => grossTotal * 0.18;

  double get total => grossTotal + tax;

  bool isInCart(String productId) =>
      _items.any((item) => item.productId == productId);

  void addItem({
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    required String size,
  }) {
    final existingIndex = _items.indexWhere(
        (item) => item.productId == productId && item.size == size);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        productId: productId,
        productName: productName,
        imageUrl: imageUrl,
        price: price,
        size: size,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId, String size) {
    _items.removeWhere(
        (item) => item.productId == productId && item.size == size);
    notifyListeners();
  }

  void increaseQuantity(String productId, String size) {
    final idx = _items.indexWhere(
        (item) => item.productId == productId && item.size == size);
    if (idx >= 0) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId, String size) {
    final idx = _items.indexWhere(
        (item) => item.productId == productId && item.size == size);
    if (idx >= 0) {
      if (_items[idx].quantity <= 1) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity--;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

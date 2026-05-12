import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class AppProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Banner> _banners = [];
  List<Order> _orders = [];
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _selectedCategory = 'cat_all';
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  List<Category> get categories => _categories;
  List<Banner> get banners => _banners;
  List<Order> get orders => _orders;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<Product> get _filteredProducts {
    List<Product> result = _products;
    if (_selectedCategory != 'cat_all') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> get newArrivals =>
      _products.where((p) => p.isNew).toList();

  Future<void> loadData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/products.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _products =
          (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      _categories = (data['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
      _banners =
          (data['banners'] as List).map((e) => Banner.fromJson(e)).toList();
      _orders =
          (data['orders'] as List).map((e) => Order.fromJson(e)).toList();
      _userProfile = UserProfile.fromJson(data['user']);
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateAddress(UserAddress address) {
    _userProfile?.billingAddress = address;
    notifyListeners();
  }

  void updatePaymentMethod(PaymentMethod method) {
    _userProfile?.paymentMethod = method;
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = Order(
        id: _orders[idx].id,
        orderNumber: _orders[idx].orderNumber,
        orderDate: _orders[idx].orderDate,
        status: 'Cancelled',
        items: _orders[idx].items,
        grossPrice: _orders[idx].grossPrice,
        tax: _orders[idx].tax,
        totalPrice: _orders[idx].totalPrice,
      );
      notifyListeners();
    }
  }

  void placeOrder(List<dynamic> cartItems) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final orderNumber = (1000 + _orders.length * 7 + 42).toString();
    final newOrder = Order(
      id: 'o${_orders.length + 1}',
      orderNumber: orderNumber,
      orderDate: dateStr,
      status: 'Order Placed',
      items: cartItems
          .map((c) => OrderItem(
                productId: c.productId,
                productName: c.productName,
                size: c.size,
                quantity: c.quantity,
                price: c.price,
              ))
          .toList(),
      grossPrice: cartItems.fold(0.0, (sum, c) => sum + c.totalPrice),
      tax: cartItems.fold(0.0, (sum, c) => sum + c.totalPrice) * 0.18,
      totalPrice: cartItems.fold(0.0, (sum, c) => sum + c.totalPrice) * 1.18,
    );
    _orders.insert(0, newOrder);
    notifyListeners();
  }
}

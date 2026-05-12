class CartItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final String size;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.size,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

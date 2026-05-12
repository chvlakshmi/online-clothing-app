class OrderItem {
  final String productId;
  final String productName;
  final String size;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.size,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      size: json['size'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  double get totalPrice => price * quantity;
}

class Order {
  final String id;
  final String orderNumber;
  final String orderDate;
  final String status;
  final List<OrderItem> items;
  final double grossPrice;
  final double tax;
  final double totalPrice;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.grossPrice,
    required this.tax,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      orderDate: json['orderDate'],
      status: json['status'],
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      grossPrice: (json['grossPrice'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}

class UserAddress {
  String addressLine1;
  String landmark;
  String city;
  String state;
  String country;
  String postalCode;

  UserAddress({
    required this.addressLine1,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      addressLine1: json['addressLine1'],
      landmark: json['landmark'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
    );
  }

  String get formatted =>
      '$addressLine1\n$landmark\n$city, $postalCode\n$state, $country';
}

class PaymentMethod {
  String cardHolderName;
  String cardNumber;
  String expiryDate;

  PaymentMethod({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  UserAddress billingAddress;
  PaymentMethod paymentMethod;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.billingAddress,
    required this.paymentMethod,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      billingAddress: UserAddress.fromJson(json['billingAddress']),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
    );
  }
}

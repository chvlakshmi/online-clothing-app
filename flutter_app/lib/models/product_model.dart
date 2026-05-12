class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final String imageUrl;
  final List<String> images;
  final bool isFeatured;
  final bool isNew;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.imageUrl,
    required this.images,
    required this.isFeatured,
    required this.isNew,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      description: json['description'],
      sizes: List<String>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
      imageUrl: json['imageUrl'],
      images: List<String>.from(json['images']),
      isFeatured: json['isFeatured'],
      isNew: json['isNew'],
    );
  }

  double get discount =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();
}

class Category {
  final String id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], icon: json['icon']);
  }
}

class Banner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String color;

  Banner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['imageUrl'],
      color: json['color'],
    );
  }
}

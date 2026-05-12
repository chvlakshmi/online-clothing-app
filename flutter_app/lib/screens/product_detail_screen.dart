import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = '';
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
  }

  void _addToCart() {
    if (_selectedSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a size',
              style: TextStyle(fontSize: 14)),
          backgroundColor: AppColors.highlight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    context.read<CartProvider>().addItem(
          productId: widget.product.id,
          productName: widget.product.name,
          imageUrl: widget.product.imageUrl,
          price: widget.product.price,
          size: _selectedSize,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart!',
            style: TextStyle(fontSize: 14)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CartScreen())),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final discount = ((p.originalPrice - p.price) / p.originalPrice * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image hero section
                  Stack(
                    children: [
                      Container(
                        height: 340,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F4F4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          child: Image.network(
                            p.images.isNotEmpty
                                ? p.images[_currentImage]
                                : p.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported_outlined,
                                size: 80,
                                color: AppColors.textLight),
                          ),
                        ),
                      ),
                      // Price tag overlay
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark)),
                                    RatingBarIndicator(
                                      rating: p.rating,
                                      itemBuilder: (context, _) => const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.gold),
                                      itemSize: 18,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${p.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark),
                                  ),
                                  Text(
                                    '\$${p.originalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textGrey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Discount badge
                      if (discount > 0)
                        Positioned(
                          top: 80,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.highlight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('-$discount%',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      // AppBar row
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleBtn(
                                  icon: Icons.arrow_back_ios_new,
                                  onTap: () => Navigator.pop(context)),
                              Row(
                                children: [
                                  Consumer<CartProvider>(
                                    builder: (context, cart, _) => Stack(
                                      children: [
                                        _circleBtn(
                                            icon:
                                                Icons.shopping_cart_outlined,
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const CartScreen()))),
                                        if (cart.itemCount > 0)
                                          Positioned(
                                            right: 4,
                                            top: 4,
                                            child: Container(
                                              width: 16,
                                              height: 16,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.highlight,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                  child: Text(
                                                      '${cart.itemCount}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold))),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _circleBtn(
                                      icon: Icons.person_outline,
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ProfileScreen()))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Size selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: p.sizes
                              .map((size) => _sizeChip(size))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        Text('Description',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        const SizedBox(height: 10),
                        Text(
                          p.description,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey,
                              height: 1.7),
                        ),
                        const SizedBox(height: 20),
                        // Reviews count
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: p.rating,
                              itemBuilder: (context, _) => const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.gold),
                              itemSize: 20,
                            ),
                            const SizedBox(width: 8),
                            Text('${p.rating} (${p.reviewCount} reviews)',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGrey)),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add to cart button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _addToCart,
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              label: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeChip(String size) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}

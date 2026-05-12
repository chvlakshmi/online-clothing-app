import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final bool isHorizontal;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isHorizontal = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) return _buildHorizontalCard(context);
    return _buildGridCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    final discount = ((product.originalPrice - product.price) / product.originalPrice * 100).round();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.divider,
                        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textLight, size: 40),
                      ),
                    ),
                  ),
                  if (product.isNew)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
                        child: Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  if (discount > 0)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.highlight, borderRadius: BorderRadius.circular(6)),
                        child: Text('-$discount%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 8,
                      right: discount > 0 ? 40 : 8,
                      child: GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? AppColors.highlight : AppColors.textGrey,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 3),
                  RatingBarIndicator(
                    rating: product.rating,
                    itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.gold),
                    itemSize: 14,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('\$${product.price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(width: 6),
                      Text('\$${product.originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 11, color: AppColors.textLight,
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, _) {
        final isFav = wishlistProvider.isInWishlist(product);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 160,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.divider,
                            child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textLight, size: 36),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => wishlistProvider.toggleWishlist(product),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFav ? AppColors.highlight : AppColors.textGrey,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      const SizedBox(height: 2),
                      Text('\$${product.price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.accent)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

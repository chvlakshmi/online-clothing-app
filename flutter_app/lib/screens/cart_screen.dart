import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'checkout_screen.dart';
import 'profile_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 26),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Add items to get started!',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.imageUrl,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 75,
                                height: 75,
                                color: AppColors.divider,
                                child: const Icon(Icons.image_outlined,
                                    color: AppColors.textLight),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark)),
                                Text('Size: ${item.size}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey)),
                                const SizedBox(height: 4),
                                Text(
                                    '\$${item.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  _qtyBtn(
                                    icon: Icons.remove,
                                    onTap: () => cart.decreaseQuantity(
                                        item.productId, item.size),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('${item.quantity}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  _qtyBtn(
                                    icon: Icons.add,
                                    onTap: () => cart.increaseQuantity(
                                        item.productId, item.size),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CheckoutScreen())),
                  child: Text(
                      'Checkout (Total: \$${cart.grossTotal.toStringAsFixed(2)})'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

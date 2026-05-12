import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'address_screen.dart';
import 'payment_screen.dart';
import 'wishlist_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 26),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen())),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 4, top: 4,
                    child: Container(
                      width: 18, height: 18,
                      decoration: const BoxDecoration(color: AppColors.highlight, shape: BoxShape.circle),
                      child: Center(child: Text('${cart.itemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final profile = appProvider.userProfile;
          if (profile == null) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFF8F00)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(profile.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                Text(profile.email, style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                const SizedBox(height: 24),
                _menuTile(icon: Icons.receipt_long_outlined, label: 'My Orders',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
                const SizedBox(height: 12),
                _menuTile(icon: Icons.favorite_border_outlined, label: 'Wishlist',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()))),
                const SizedBox(height: 12),
                _menuTile(icon: Icons.settings_outlined, label: 'Settings',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                const SizedBox(height: 12),
                _infoCard(
                  title: 'Billing Address',
                  content: profile.billingAddress.formatted,
                  onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressScreen())),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  title: 'Payment Method',
                  content: 'Card Holder Name: ${profile.paymentMethod.cardHolderName}\nCard Number: ${profile.paymentMethod.cardNumber}\nExpiry Date: ${profile.paymentMethod.expiryDate}',
                  onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen())),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.highlight, foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard({required String title, required String content, required VoidCallback onEdit}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(content, style: TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.6))),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: Text('Edit', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _menuTile({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Row(children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey, size: 22),
        ]),
      ),
    );
  }
}

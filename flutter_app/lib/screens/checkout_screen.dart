import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import 'profile_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
      body: Consumer2<CartProvider, AppProvider>(
        builder: (context, cart, appProvider, _) {
          final profile = appProvider.userProfile;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order items summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8)
                          ],
                        ),
                        child: Column(
                          children: [
                            ...cart.items.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item.productName}(${item.size})',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.textDark,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '\$${item.price.toStringAsFixed(0)} x ${item.quantity}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(height: 20),
                            _priceRow('Gross Price',
                                '\$${cart.grossTotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 4),
                            _priceRow('Tax (18%)',
                                '\$${cart.tax.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _priceRow('Total Price',
                                '\$${cart.total.toStringAsFixed(2)}',
                                isBold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Billing Address
                      _sectionCard(
                        title: 'Billing Address',
                        content: profile?.billingAddress.formatted ??
                            'No address added',
                        onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen())),
                      ),
                      const SizedBox(height: 16),
                      // Payment Method
                      _sectionCard(
                        title: 'Payment Method',
                        content: profile != null
                            ? 'Card Holder Name: ${profile.paymentMethod.cardHolderName}\nCard Number: ${profile.paymentMethod.cardNumber}\nExpiry Date: ${profile.paymentMethod.expiryDate}'
                            : 'No card added',
                        onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen())),
                      ),
                    ],
                  ),
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
                        offset: const Offset(0, -4))
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final orderNumber = (1000 + appProvider.orders.length * 7 + 42).toString();
                    appProvider.placeOrder(cart.items);
                    cart.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => OrderSuccessScreen(
                          orderNumber: orderNumber,
                          totalAmount: cart.total,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('Place Order'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
              fontSize: 13,
              color: isBold ? AppColors.textDark : AppColors.textGrey,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _sectionCard(
      {required String title,
      required String content,
      required VoidCallback onEdit}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(content,
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textGrey, height: 1.6)),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Edit',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

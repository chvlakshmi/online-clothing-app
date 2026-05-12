import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? _expandedOrderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Orders'),
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
          IconButton(
            icon: const Icon(Icons.person_outline, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final orders = appProvider.orders;
          if (orders.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.receipt_long_outlined, size: 72, color: AppColors.textLight),
                const SizedBox(height: 16),
                Text('No orders yet', style: TextStyle(fontSize: 17, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isExpanded = _expandedOrderId == order.id;
              final isCancelled = order.status == 'Cancelled';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _expandedOrderId = isExpanded ? null : order.id),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isExpanded ? 0 : 16),
                            bottomRight: Radius.circular(isExpanded ? 0 : 16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Order Number: ${order.orderNumber}',
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                Text('Order Date: ${order.orderDate}',
                                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ]),
                            ),
                            Text(order.status,
                                style: TextStyle(color: isCancelled ? Colors.redAccent : Colors.greenAccent,
                                    fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 6),
                            Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('${item.productName}(${item.size})',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                  Text('\$${item.price.toStringAsFixed(0)} x ${item.quantity}',
                                      style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                ])),
                                Text('\$${item.totalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              ]),
                            )),
                            const Divider(height: 20),
                            _priceRow('Gross Price', '\$${order.grossPrice.toStringAsFixed(2)}'),
                            _priceRow('Tax(18%)', '\$${order.tax.toStringAsFixed(2)}'),
                            _priceRow('Total Price', '\$${order.totalPrice.toStringAsFixed(2)}', bold: true),
                            if (!isCancelled) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w700)),
                                        content: Text('Are you sure you want to cancel this order?',
                                            style: TextStyle(fontSize: 14)),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context),
                                              child: Text('No', style: TextStyle(color: AppColors.textGrey))),
                                          TextButton(onPressed: () {
                                            appProvider.cancelOrder(order.id);
                                            Navigator.pop(context);
                                          }, child: Text('Yes', style: TextStyle(color: AppColors.highlight, fontWeight: FontWeight.w600))),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text('Cancel Order'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text('$label: ', style: TextStyle(fontSize: 12, color: bold ? AppColors.textDark : AppColors.textGrey,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        Text(value, style: TextStyle(fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: AppColors.textDark)),
      ]),
    );
  }
}

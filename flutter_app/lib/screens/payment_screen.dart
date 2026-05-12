import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberCtrl;
  late TextEditingController _expiryCtrl;
  late TextEditingController _cvvCtrl;
  late TextEditingController _holderCtrl;

  @override
  void initState() {
    super.initState();
    final pm = context.read<AppProvider>().userProfile?.paymentMethod;
    _numberCtrl = TextEditingController(text: pm?.cardNumber ?? '');
    _expiryCtrl = TextEditingController(text: pm?.expiryDate ?? '');
    _cvvCtrl = TextEditingController();
    _holderCtrl = TextEditingController(text: pm?.cardHolderName ?? '');
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AppProvider>().updatePaymentMethod(PaymentMethod(
      cardHolderName: _holderCtrl.text,
      cardNumber: _numberCtrl.text,
      expiryDate: _expiryCtrl.text,
    ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Card updated!', style: TextStyle(fontSize: 14)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Card Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline, size: 26), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card visual
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF283593)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(width: 40, height: 28,
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(6))),
                    Text('Capstone', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                  ]),
                  const Spacer(),
                  Text(_numberCtrl.text.isEmpty ? '•••• •••• •••• ••••' : _numberCtrl.text,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('VALID THRU', style: TextStyle(color: Colors.white54, fontSize: 9)),
                      Text(_expiryCtrl.text.isEmpty ? 'MM/YY' : _expiryCtrl.text,
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                    const Spacer(),
                    Text(_holderCtrl.text.isEmpty ? 'CARD HOLDER' : _holderCtrl.text.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Stack(children: [
                      Container(width: 28, height: 28, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
                      Positioned(left: 14, child: Container(width: 28, height: 28,
                          decoration: const BoxDecoration(color: Color(0xFFF79E1B), shape: BoxShape.circle))),
                    ]),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _field(controller: _numberCtrl, label: 'Number', hint: '1234 5678 9012 3456', onChanged: (_) => setState(() {})),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _field(controller: _expiryCtrl, label: 'Expired Date', hint: 'MM/YY', onChanged: (_) => setState(() {}))),
                    const SizedBox(width: 16),
                    Expanded(child: _field(controller: _cvvCtrl, label: 'CVV', hint: '•••', isObscure: true)),
                  ]),
                  const SizedBox(height: 16),
                  _field(controller: _holderCtrl, label: 'Card Holder', hint: 'Full name', onChanged: (_) => setState(() {})),
                  const SizedBox(height: 36),
                  ElevatedButton(onPressed: _save, child: const Text('Add Card')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String label, String? hint,
      bool isObscure = false, void Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}

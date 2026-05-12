import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _line1Ctrl;
  late TextEditingController _landmarkCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _postalCtrl;

  @override
  void initState() {
    super.initState();
    final addr = context.read<AppProvider>().userProfile?.billingAddress;
    _line1Ctrl = TextEditingController(text: addr?.addressLine1 ?? '');
    _landmarkCtrl = TextEditingController(text: addr?.landmark ?? '');
    _cityCtrl = TextEditingController(text: addr?.city ?? '');
    _stateCtrl = TextEditingController(text: addr?.state ?? '');
    _countryCtrl = TextEditingController(text: addr?.country ?? '');
    _postalCtrl = TextEditingController(text: addr?.postalCode ?? '');
  }

  @override
  void dispose() {
    _line1Ctrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AppProvider>().updateAddress(UserAddress(
      addressLine1: _line1Ctrl.text,
      landmark: _landmarkCtrl.text,
      city: _cityCtrl.text,
      state: _stateCtrl.text,
      country: _countryCtrl.text,
      postalCode: _postalCtrl.text,
    ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Address updated!', style: TextStyle(fontSize: 14)),
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
        title: const Text('Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Billing Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark))),
              const SizedBox(height: 24),
              _field(controller: _line1Ctrl, label: 'Address Line 1'),
              const SizedBox(height: 16),
              _field(controller: _landmarkCtrl, label: 'Landmark'),
              const SizedBox(height: 16),
              _field(controller: _cityCtrl, label: 'City'),
              const SizedBox(height: 16),
              _field(controller: _stateCtrl, label: 'State'),
              const SizedBox(height: 16),
              _field(controller: _countryCtrl, label: 'Country'),
              const SizedBox(height: 16),
              _field(controller: _postalCtrl, label: 'Postal Code', isNumber: true),
              const SizedBox(height: 36),
              ElevatedButton(onPressed: _save, child: const Text('Update Address')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String label, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}

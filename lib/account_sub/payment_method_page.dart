import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String selectedMethod = "Orange Money";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Choose your preferred payment method:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildOption("Orange Money", Icons.account_balance_wallet),
          _buildOption("MTN Mobile Money", Icons.phone_android),
          _buildOption("Visa Card", Icons.credit_card),
          _buildOption("Mastercard", Icons.credit_card_rounded),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Handle saving payment method
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Saved: $selectedMethod")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Save Method",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String method, IconData icon) {
    return RadioListTile(
      value: method,
      groupValue: selectedMethod,
      onChanged: (val) {
        setState(() => selectedMethod = val.toString());
      },
      title: Text(method),
      secondary: Icon(icon, color: Colors.blue),
    );
  }
}
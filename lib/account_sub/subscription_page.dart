import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Prices
    double monthly = 1500;
    double threeMonths = monthly * 3 * 0.9; // 10% discount
    double sixMonths = monthly * 6 * 0.85; // 15% discount
    double yearly = monthly * 12 * 0.8; // 20% discount

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subscription",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPlan(context, "1 Month", monthly),
          _buildPlan(context, "3 Months (10% off)", threeMonths),
          _buildPlan(context, "6 Months (15% off)", sixMonths),
          _buildPlan(context, "12 Months (20% off)", yearly),
        ],
      ),
    );
  }

  Widget _buildPlan(BuildContext context, String title, double price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${price.toStringAsFixed(0)} Frs"),
        trailing: ElevatedButton(
          onPressed: () {
            _showPaymentForm(context, title, price);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Buy", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _showPaymentForm(BuildContext context, String plan, double price) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        String? paymentMethod;
        final TextEditingController phoneController = TextEditingController();

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text("Payment for $plan",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Amount: ${price.toStringAsFixed(0)} Frs",
                      style:
                      const TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 20),

                  // Payment method radio buttons
                  const Text("Choose Payment Method",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  RadioListTile<String>(
                    value: "Orange Money",
                    groupValue: paymentMethod,
                    title: const Text("Orange Money"),
                    onChanged: (value) => setState(() => paymentMethod = value),
                  ),
                  RadioListTile<String>(
                    value: "MTN Mobile Money",
                    groupValue: paymentMethod,
                    title: const Text("MTN Mobile Money"),
                    onChanged: (value) => setState(() => paymentMethod = value),
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (paymentMethod == null ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select payment method and enter phone number"),
                            ),
                          );
                          return;
                        }

                        // Simulate USSD confirmation depending on method
                        String ussdCode = paymentMethod == "MTN Mobile Money"
                            ? "*126#"
                            : "#150#";

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Dial $ussdCode on your phone to confirm $paymentMethod payment for ${phoneController.text}"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Confirm Payment",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

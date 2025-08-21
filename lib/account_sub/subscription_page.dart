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
        title: const Text("Subscription",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPlan("1 Month", monthly),
          _buildPlan("3 Months (10% off)", threeMonths),
          _buildPlan("6 Months (15% off)", sixMonths),
          _buildPlan("12 Months (20% off)", yearly),
        ],
      ),
    );
  }

  Widget _buildPlan(String title, double price) {
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
            // Handle payment logic
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
}
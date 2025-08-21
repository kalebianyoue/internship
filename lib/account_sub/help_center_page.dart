import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> faqs = [
      {
        "q": "How do I reset my password?",
        "a": "Go to Account > Security > Change Password."
      },
      {
        "q": "How do I contact support?",
        "a": "Click 'Contact Support' button below."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center", style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold), ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("FAQs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq['q']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faq['a']!),
              )
            ],
          )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.support_agent, color: Colors.white),
            label: const Text("Contact Support",
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              // open email / chat system
            },
          )
        ],
      ),
    );
  }
}

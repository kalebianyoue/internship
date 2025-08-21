import 'package:flutter/material.dart';

class PersonalInformationPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonalInformationPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoTile("Full Name", userData['name'] ?? "Unknown"),
          _buildInfoTile("Email", userData['email'] ?? "example@mail.com"),
          _buildInfoTile("Phone Number", userData['phone'] ?? "+237 600000000"),
          _buildInfoTile("Address", userData['address'] ?? "Not provided"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle edit profile
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Edit Information",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blue),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
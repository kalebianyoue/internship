import 'package:flutter/material.dart';

// =================== BLOCKED PROVIDERS ===================
class BlockedProvidersPage extends StatelessWidget {
  const BlockedProvidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example dummy list of blocked providers
    List<String> blocked = ["Guy Mike", "Josue Epee", "Charles Atangana"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked Providers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: blocked.isEmpty
          ? const Center(
        child: Text("You haven’t blocked any providers."),
      )
          : ListView.builder(
        itemCount: blocked.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: Text(blocked[index]),
            trailing: TextButton(
              child: const Text(
                "Unblock",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                // implement unblock logic here
              },
            ),
          );
        },
      ),
    );
  }
}

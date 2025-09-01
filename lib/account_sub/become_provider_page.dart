import 'package:flutter/material.dart';

class BecomeProviderPage extends StatelessWidget {
  const BecomeProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? serviceName;
    String? description;
    String? phone;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Become a Provider"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Fill in your details to offer your services",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Service Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Service Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter a service name" : null,
                onSaved: (value) => serviceName = value,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter a description" : null,
                onSaved: (value) => description = value,
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter your phone number" : null,
                onSaved: (value) => phone = value,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // TODO: Save provider info to Firestore or backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Application submitted successfully!")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Submit Application",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

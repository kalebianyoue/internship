import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? idCardImage;
  File? profileImage;
  String? homeLocation;

  final ImagePicker _picker = ImagePicker();

  // pick image function
  Future<void> _pickImage(bool isIdCard) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // you can also add camera option
      imageQuality: 75, // compress a little
    );

    if (pickedFile != null) {
      setState(() {
        if (isIdCard) {
          idCardImage = File(pickedFile.path);
        } else {
          profileImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text("Account Verification",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Verify Your Account",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "To get a blue tick on your profile, please provide the following details.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Upload ID Card
          _buildUploadCard(
            title: "Upload ID Card",
            subtitle: "National ID, Passport, or Driver’s License",
            icon: Icons.badge,
            imageFile: idCardImage,
            onTap: () => _pickImage(true),
          ),

          // Upload Profile Picture
          _buildUploadCard(
            title: "Upload Profile Picture",
            subtitle: "A clear recent photo of you",
            icon: Icons.person,
            imageFile: profileImage,
            onTap: () => _pickImage(false),
          ),

          // Home Location (text input for now)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text("Home Location",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(homeLocation ?? "Provide your residential address"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final location = await _showLocationDialog(context);
                  if (location != null) {
                    setState(() {
                      homeLocation = location;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Subscription Info
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Text(
                    "Verification Subscription",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You will be charged 2000 Frs/month to maintain your verified badge.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Verify Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              if (idCardImage != null && profileImage != null && homeLocation != null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Verification request submitted. Await approval.")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please complete all required fields before submitting.")));
              }
            },
            child: const Text(
              "Verify Now",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    File? imageFile,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: imageFile != null
            ? CircleAvatar(backgroundImage: FileImage(imageFile), radius: 25)
            : Icon(icon, size: 30, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(imageFile != null ? "Uploaded" : subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: onTap,
        ),
      ),
    );
  }

  Future<String?> _showLocationDialog(BuildContext context) async {
    String? locationInput;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Home Location"),
        content: TextField(
          onChanged: (value) => locationInput = value,
          decoration: const InputDecoration(hintText: "e.g., Yaoundé, Cameroon"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, locationInput),
              child: const Text("Save")),
        ],
      ),
    );
  }
}
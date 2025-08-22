import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http; // Removed API for now
// import 'package:shared_preferences/shared_preferences.dart'; // Optional later

// Models (keep structure)
class VerificationResponse {
  final bool success;
  final String message;
  final String? verificationId;
  final String? paymentUrl;

  VerificationResponse({
    required this.success,
    required this.message,
    this.verificationId,
    this.paymentUrl,
  });
}

class PaymentResponse {
  final bool success;
  final String message;
  final String? transactionId;
  final String? status;

  PaymentResponse({
    required this.success,
    required this.message,
    this.transactionId,
    this.status,
  });
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? idCardImage;
  File? profileImage;
  String? homeLocation;
  bool isLoading = false;
  bool isVerified = false;
  String? verificationStatus;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Later: check verification status with API
  }

  // Pick image (works offline)
  Future<void> _pickImage(bool isIdCard) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          if (isIdCard) {
            idCardImage = File(pickedFile.path);
          } else {
            profileImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  // Submit verification (dummy for now)
  Future<void> _submitVerification() async {
    if (!_validateInputs()) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate waiting

    if (mounted) {
      setState(() {
        isVerified = true;
        verificationStatus = "Pending Approval";
        isLoading = false;
      });
    }

    // Show success dialog (dummy)
    _showSuccessDialog(PaymentResponse(
      success: true,
      message: "Dummy payment processed",
      transactionId: "TXN123456",
      status: "completed",
    ));
  }

  // Validate inputs
  bool _validateInputs() {
    if (idCardImage == null) {
      _showErrorSnackBar('Please upload your ID card');
      return false;
    }
    if (profileImage == null) {
      _showErrorSnackBar('Please upload your profile picture');
      return false;
    }
    if (homeLocation == null || homeLocation!.isEmpty) {
      _showErrorSnackBar('Please provide your home location');
      return false;
    }
    return true;
  }

  // Error snackbar
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Success dialog
  void _showSuccessDialog(PaymentResponse paymentResponse) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verification Submitted!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Your verification request has been submitted successfully.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (paymentResponse.transactionId != null)
              Text(
                'Transaction ID: ${paymentResponse.transactionId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Back
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Account Verification",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (isVerified) _buildVerifiedStatus(),
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

          _buildUploadCard(
            title: "Upload ID Card",
            subtitle: "National ID, Passport, or Driver's License",
            icon: Icons.badge,
            imageFile: idCardImage,
            onTap: () => _pickImage(true),
          ),

          _buildUploadCard(
            title: "Upload Profile Picture",
            subtitle: "A clear recent photo of you",
            icon: Icons.person,
            imageFile: profileImage,
            onTap: () => _pickImage(false),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text(
                "Home Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                homeLocation ?? "Provide your residential address",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final location = await _showLocationDialog(context);
                  if (location != null && location.isNotEmpty && mounted) {
                    setState(() {
                      homeLocation = location;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.verified, color: Colors.blue, size: 32),
                  SizedBox(height: 8),
                  Text(
                    "Verification Subscription",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You will be charged 2000 XAF/month to maintain your verified badge. Payment will be processed securely.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: isVerified ? null : _submitVerification,
            child: Text(
              isVerified ? "Already Verified" : "Verify Now & Pay",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Accepted Payment Methods",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(label: Text("Mobile Money")),
                      Chip(label: Text("Orange Money")),
                      Chip(label: Text("MTN MoMo")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedStatus() {
    return Card(
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account Verified",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Status: ${verificationStatus ?? 'Active'}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            ? ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.file(
            imageFile,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        )
            : Icon(icon, size: 30, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(imageFile != null ? "✓ Uploaded" : subtitle),
        trailing: IconButton(
          icon: Icon(
            imageFile != null ? Icons.check_circle : Icons.upload_file,
            color: imageFile != null ? Colors.green : Colors.blue,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }

  Future<String?> _showLocationDialog(BuildContext context) async {
    final controller = TextEditingController(text: homeLocation);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Home Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "e.g., Yaoundé, Cameroon",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
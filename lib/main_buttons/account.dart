import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/account_sub/blocked_providers_page.dart';
import 'package:untitled/account_sub/help_center_page.dart';
import 'package:untitled/account_sub/invite_friends_page.dart';
import 'package:untitled/account_sub/language_page.dart';
import 'package:untitled/account_sub/notification_page.dart';
import 'package:untitled/account_sub/payment_method_page.dart';
import 'package:untitled/account_sub/personal_information_page.dart';
import 'package:untitled/account_sub/privacy_page.dart';
import 'package:untitled/account_sub/report_problem_page.dart';
import 'package:untitled/account_sub/security_page.dart';
import 'package:untitled/account_sub/subscription_page.dart';
import 'package:untitled/account_sub/terms_page.dart';
import 'package:untitled/account_sub/verification.dart';
import 'package:untitled/main_buttons/homepage.dart';

class Account extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const Account({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Get the name in priority order
    final String displayName = userData?['name'] ??
        user?.displayName ??
        user?.email?.split('@').first ??
        'User';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Account",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile card
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.white,
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome",
                            style:
                            TextStyle(fontSize: 16, color: Colors.grey)),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.person,
                        size: 40, color: Colors.blue),
                  )
                ],
              ),
            ),
          ),

          // Manage Account Section
          _buildSectionTitle("Manage Account"),
          _buildListTile(
            icon: Icons.person,
            title: "Personal Information",
            subtitle: "Name, Email, Phone",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PersonalInformationPage(userData: userData ?? {})),
              );
            },
          ),
          _buildListTile(
            icon: Icons.language,
            title: "Language",
            subtitle: "English",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.payment,
            title: "Payment Methods",
            subtitle: "MOMO, Orange Money",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymentMethodsPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.notifications_active_outlined,
            title: "Notifications",
            subtitle: "Enabled",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.lock_outline,
            title: "Security",
            subtitle: "Change Password, 2FA",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityPage()),
              );
            },
          ),

          // Verification Section
          _buildSectionTitle("Verification"),
          _buildListTile(
            icon: Icons.verified,
            title: "Get Verified",
            subtitle:
            "Submit ID, Home location, Photo • 2000 Frs/month for blue tick",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VerificationScreen()));
            },
          ),

          // Product Section
          _buildSectionTitle("Product"),
          _buildListTile(
            icon: Icons.person_add,
            title: "Invite Friends",
            subtitle: "Earn 5% of the amount spent by your friends for life",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InviteFriendsPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.group,
            title: "Direct Workers",
            subtitle: "Manage people working under you",
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.subscriptions,
            title: "Subscription",
            subtitle: "Manage your monthly plan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionPage()),
              );
            },
          ),

          // Help & Support Section
          _buildSectionTitle("Help & Support"),
          _buildListTile(
            icon: Icons.help_outline,
            title: "Help Center",
            subtitle: "FAQs, Contact Support",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.report_problem_outlined,
            title: "Report a Problem",
            subtitle: "Notify us about issues",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportProblemPage()),
              );
            },
          ),

          // Legal Section
          _buildSectionTitle("Legal"),
          _buildListTile(
            icon: Icons.article_outlined,
            title: "Terms & Services",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy & Policy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPage()),
              );
            },
          ),

          // Confidence & Security Section
          _buildSectionTitle("Confidence & Security"),
          _buildListTile(
            icon: Icons.block,
            title: "Blocked Providers",
            subtitle: "See providers you blocked",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BlockedProvidersPage()),
              );
            },
          ),

          const SizedBox(height: 30),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ListTile Widget Builder
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
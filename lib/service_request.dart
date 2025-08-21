import 'package:flutter/material.dart';
import 'package:untitled/services_detail.dart';

class ServiceRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Request a Service",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  hintText: "Search Services",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // 📋 Categories
            _buildCategoryItem(context, icon: Icons.eco, text: 'Gardening', subServices: [
              "Cultivating", "Exterior Equipment", "Bush Clearing", "Tree Pruning"
            ]),
            _buildCategoryItem(context, icon: Icons.cleaning_services, text: 'Cleaning', subServices: [
              "House Cleaning", "Office Cleaning", "Laundry", "Deep Cleaning"
            ]),
            _buildCategoryItem(context, icon: Icons.construction, text: 'Repairs', subServices: [
              "General Repairs", "Appliance Fixing", "Roof Repairs", "Window & Door Fixing"
            ]),
            _buildCategoryItem(context, icon: Icons.local_shipping, text: 'Delivery', subServices: [
              "Food Delivery", "Grocery Delivery", "Package Delivery", "Furniture Delivery"
            ]),
            _buildCategoryItem(context, icon: Icons.plumbing, text: 'Plumbing', subServices: [
              "Pipe Installation", "Leak Repairs", "Bathroom Fittings", "Water Tank Cleaning"
            ]),
            _buildCategoryItem(context, icon: Icons.electrical_services, text: 'Electrician', subServices: [
              "Wiring", "Lighting Installation", "Generator Maintenance", "Troubleshooting"
            ]),
            _buildCategoryItem(context, icon: Icons.home_repair_service, text: 'Carpentry', subServices: [
              "Furniture Making", "Wood Repairs", "Cabinet Installation", "Polishing"
            ]),
            _buildCategoryItem(context, icon: Icons.brush, text: 'Painting', subServices: [
              "Interior Painting", "Exterior Painting", "Wall Designs", "Repainting"
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context,
      {required IconData icon,
        required String text,
        required List<String> subServices}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubServicePage(category: text, subServices: subServices),
            ),
          );
        },
      ),
    );
  }
}

// 🌟 SubService Page
class SubServicePage extends StatelessWidget {
  final String category;
  final List<String> subServices;

  const SubServicePage(
      {Key? key, required this.category, required this.subServices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: subServices.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blue),
              title: Text(
                subServices[index],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServicesDetail(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
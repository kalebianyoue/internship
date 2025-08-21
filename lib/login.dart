import 'package:flutter/material.dart';
import 'package:untitled/services_detail.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String selectedCategory = "For you";

  final Map<String, List<Map<String, dynamic>>> categoryServices = {
    "For you": [
      {
        "title": "House Cleaning",
        "description": "Professional home cleaning service",
        "price": "20000Fcfa",
        "icon": Icons.cleaning_services,
        "subServices": ["Deep Cleaning", "Regular Cleaning", "Move-in/out Cleaning", "Window Cleaning"]
      },
      {
        "title": "Grocery Delivery",
        "description": "Fresh groceries delivered to your door",
        "price": "1500Fcfa",
        "icon": Icons.local_grocery_store,
        "subServices": ["Fresh Produce", "Pantry Items", "Dairy Products", "Frozen Foods"]
      },
      {
        "title": "Pet Walking",
        "description": "Daily pet care and walking service",
        "price": "3000Fcfa/walk",
        "icon": Icons.pets,
        "subServices": ["Dog Walking", "Pet Sitting", "Pet Feeding", "Pet Grooming"]
      },
      {
        "title": "Tutoring",
        "description": "Online & in-person lessons",
        "price": "2500Fcfa/per day",
        "icon": Icons.school,
        "subServices": ["Math Tutoring", "English Tutoring", "Science Help", "Test Prep"]
      },
      {
        "title": "Laundry Service",
        "description": "Wash, dry & fold service",
        "price": "2000/load",
        "icon": Icons.local_laundry_service,
        "subServices": ["Wash & Fold", "Dry Cleaning", "Ironing", "Pickup & Delivery"]
      },
    ],
    "Domestic": [
      {
        "title": "House Cleaning",
        "description": "Deep cleaning service for homes",
        "price": "3500Fcafa/session",
        "icon": Icons.cleaning_services,
        "subServices": ["House Cleaning", "Office Cleaning", "Laundry", "Deep Cleaning"]
      },
      {
        "title": "Cooking Service",
        "description": "Personal chef experience at home",
        "price": "5000Fcfa/meal",
        "icon": Icons.restaurant,
        "subServices": ["Meal Prep", "Special Occasions", "Dietary Plans", "Cooking Classes"]
      },
      {
        "title": "Babysitting",
        "description": "Trusted childcare services",
        "price": "4000Fcfa/hr",
        "icon": Icons.child_care,
        "subServices": ["Evening Care", "Weekend Care", "Emergency Care", "Overnight Care"]
      },
      {
        "title": "Elder Care",
        "description": "Companion services for seniors",
        "price": "3000Fcfa/day",
        "icon": Icons.elderly,
        "subServices": ["Companion Care", "Medical Assistance", "Meal Preparation", "Transportation"]
      },
    ],
    "Outdoor": [
      {
        "title": "Gardening",
        "description": "Complete garden maintenance",
        "price": "3000Fcfa/visit",
        "icon": Icons.eco,
        "subServices": ["Cultivating", "Exterior Equipment", "Bush Clearing", "Tree Pruning"]
      },
      {
        "title": "Pool Cleaning",
        "description": "Weekly pool maintenance service",
        "price": "5000Fcfa/clean",
        "icon": Icons.pool,
        "subServices": ["Chemical Balancing", "Filter Cleaning", "Debris Removal", "Equipment Check"]
      },
      {
        "title": "Landscaping",
        "description": "Garden design & maintenance",
        "price": "10000Fcfa/project",
        "icon": Icons.nature,
        "subServices": ["Garden Design", "Plant Installation", "Irrigation", "Maintenance"]
      },
      {
        "title": "Pressure Washing",
        "description": "Exterior surface cleaning",
        "price": "2000Fcfa/service",
        "icon": Icons.water_drop,
        "subServices": ["Driveway Cleaning", "House Exterior", "Deck Cleaning", "Concrete Cleaning"]
      },
    ],
    "Mechanics": [
      {
        "title": "General Repairs",
        "description": "All types of mechanical repairs",
        "price": "2000Fcfa/hr",
        "icon": Icons.construction,
        "subServices": ["General Repairs", "Appliance Fixing", "Roof Repairs", "Window & Door Fixing"]
      },
      {
        "title": "Automotive Service",
        "description": "Complete car maintenance",
        "price": "From 10000Fcfa/service",
        "icon": Icons.car_repair,
        "subServices": ["Oil Change", "Tire Service", "Battery Replace", "Brake Service"]
      },
      {
        "title": "Electrical Work",
        "description": "Professional electrical services",
        "price": "From 5000Fcfa",
        "icon": Icons.electrical_services,
        "subServices": ["Wiring", "Lighting Installation", "Generator Maintenance", "Troubleshooting"]
      },
      {
        "title": "Plumbing Service",
        "description": "Expert plumbing solutions",
        "price": "From 5000Fcfa",
        "icon": Icons.plumbing,
        "subServices": ["Pipe Installation", "Leak Repairs", "Bathroom Fittings", "Water Tank Cleaning"]
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Home Services",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  hintText: "Search Services",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Buttons
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ["For you", "Domestic", "Outdoor", "Mechanics"]
                    .map((category) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: selectedCategory == category ? [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ] : [],
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.blue,
                          fontWeight: selectedCategory == category
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Section Title
            const Text(
              "Most Wanted",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 15),

            // Service Cards
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 4),
                itemCount: categoryServices[selectedCategory]?.length ?? 0,
                itemBuilder: (context, index) {
                  final service = categoryServices[selectedCategory]![index];
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to SubServicePage like in your ServiceRequest
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubServicePage(
                              category: service['title'],
                              subServices: service['subServices'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service Icon
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(
                                  service['icon'],
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Service Title
                              Text(
                                service['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Service Description
                              Text(
                                service['description']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                              const Spacer(),

                              // Price and Book Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    service['price']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubServicePage(
                                            category: service['title'],
                                            subServices: service['subServices'],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      elevation: 2,
                                    ),
                                    child: const Text("Book",
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // All Services Section (matching your ServiceRequest categories)
            const Text(
              "All Services",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 15),

            // Service Categories (from your ServiceRequest)
            _buildCategoryItem(context, icon: Icons.eco, text: 'Gardening', subServices: [
              "Cultivating",
              "Exterior Equipment",
              "Bush Clearing",
              "Tree Pruning",
            ]),
            _buildCategoryItem(context, icon: Icons.cleaning_services, text: 'Cleaning', subServices: [
              "House Cleaning",
              "Office Cleaning",
              "Laundry",
              "Deep Cleaning",
            ]),
            _buildCategoryItem(context, icon: Icons.construction, text: 'Repairs', subServices: [
              "General Repairs",
              "Appliance Fixing",
              "Roof Repairs",
              "Window & Door Fixing",
            ]),
            _buildCategoryItem(context, icon: Icons.local_shipping, text: 'Delivery', subServices: [
              "Food Delivery",
              "Grocery Delivery",
              "Package Delivery",
              "Furniture Delivery",
            ]),
            _buildCategoryItem(context, icon: Icons.plumbing, text: 'Plumbing', subServices: [
              "Pipe Installation",
              "Leak Repairs",
              "Bathroom Fittings",
              "Water Tank Cleaning",
            ]),
            _buildCategoryItem(context, icon: Icons.electrical_services, text: 'Electrician', subServices: [
              "Wiring",
              "Lighting Installation",
              "Generator Maintenance",
              "Troubleshooting",
            ]),
            _buildCategoryItem(context, icon: Icons.home_repair_service, text: 'Carpentry', subServices: [
              "Furniture Making",
              "Wood Repairs",
              "Cabinet Installation",
              "Polishing",
            ]),
            _buildCategoryItem(context, icon: Icons.brush, text: 'Painting', subServices: [
              "Interior Painting",
              "Exterior Painting",
              "Wall Designs",
              "Repainting",
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        onTap: () {
          // Navigate to Sub-service Page (same as your ServiceRequest)
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

// Sub-service Page (matching your existing one)
class SubServicePage extends StatelessWidget {
  final String category;
  final List<String> subServices;

  const SubServicePage({Key? key, required this.category, required this.subServices})
      : super(key: key);



 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subServices.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.check_circle, color: Colors.blue),
              ),
              title: Text(
                subServices[index],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicesDetail(),
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

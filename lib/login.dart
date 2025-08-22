import 'package:flutter/material.dart';
import 'package:untitled/services_detail.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String selectedCategory = "For you";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> categoryServices = {
    "For you": [
      {
        "title": "House Cleaning",
        "description": "Professional home cleaning service",
        "price": "20000Fcfa",
        "icon": Icons.cleaning_services,
        "subServices": ["Deep Cleaning", "Regular Cleaning", "Move-in/out Cleaning", "Window Cleaning"],
        "searchKeywords": ["house", "cleaning", "clean", "home", "deep", "regular", "window"]
      },
      {
        "title": "Grocery Delivery",
        "description": "Fresh groceries delivered to your door",
        "price": "1500Fcfa",
        "icon": Icons.local_grocery_store,
        "subServices": ["Fresh Produce", "Pantry Items", "Dairy Products", "Frozen Foods"],
        "searchKeywords": ["grocery", "delivery", "food", "fresh", "produce", "pantry", "dairy", "frozen"]
      },
      {
        "title": "Pet Walking",
        "description": "Daily pet care and walking service",
        "price": "3000Fcfa/walk",
        "icon": Icons.pets,
        "subServices": ["Dog Walking", "Pet Sitting", "Pet Feeding", "Pet Grooming"],
        "searchKeywords": ["pet", "dog", "walking", "sitting", "feeding", "grooming", "animal"]
      },
      {
        "title": "Tutoring",
        "description": "Online & in-person lessons",
        "price": "2500Fcfa/per day",
        "icon": Icons.school,
        "subServices": ["Math Tutoring", "English Tutoring", "Science Help", "Test Prep"],
        "searchKeywords": ["tutoring", "tutor", "math", "english", "science", "test", "lessons", "teaching", "education"]
      },
      {
        "title": "Laundry Service",
        "description": "Wash, dry & fold service",
        "price": "2000/load",
        "icon": Icons.local_laundry_service,
        "subServices": ["Wash & Fold", "Dry Cleaning", "Ironing", "Pickup & Delivery"],
        "searchKeywords": ["laundry", "wash", "dry", "fold", "ironing", "cleaning", "clothes"]
      },
    ],
    "Domestic": [
      {
        "title": "House Cleaning",
        "description": "Deep cleaning service for homes",
        "price": "3500Fcafa/session",
        "icon": Icons.cleaning_services,
        "subServices": ["House Cleaning", "Office Cleaning", "Laundry", "Deep Cleaning"],
        "searchKeywords": ["house", "cleaning", "clean", "home", "office", "deep", "laundry"]
      },
      {
        "title": "Cooking Service",
        "description": "Personal chef experience at home",
        "price": "5000Fcfa/meal",
        "icon": Icons.restaurant,
        "subServices": ["Meal Prep", "Special Occasions", "Dietary Plans", "Cooking Classes"],
        "searchKeywords": ["cooking", "chef", "meal", "food", "prep", "dietary", "kitchen"]
      },
      {
        "title": "Babysitting",
        "description": "Trusted childcare services",
        "price": "4000Fcfa/hr",
        "icon": Icons.child_care,
        "subServices": ["Evening Care", "Weekend Care", "Emergency Care", "Overnight Care"],
        "searchKeywords": ["babysitting", "childcare", "kids", "children", "care", "nanny"]
      },
      {
        "title": "Elder Care",
        "description": "Companion services for seniors",
        "price": "3000Fcfa/day",
        "icon": Icons.elderly,
        "subServices": ["Companion Care", "Medical Assistance", "Meal Preparation", "Transportation"],
        "searchKeywords": ["elder", "senior", "elderly", "companion", "medical", "care"]
      },
    ],
    "Outdoor": [
      {
        "title": "Gardening",
        "description": "Complete garden maintenance",
        "price": "3000Fcfa/visit",
        "icon": Icons.eco,
        "subServices": ["Cultivating", "Exterior Equipment", "Bush Clearing", "Tree Pruning"],
        "searchKeywords": ["gardening", "garden", "plants", "cultivating", "bush", "tree", "pruning", "landscaping"]
      },
      {
        "title": "Pool Cleaning",
        "description": "Weekly pool maintenance service",
        "price": "5000Fcfa/clean",
        "icon": Icons.pool,
        "subServices": ["Chemical Balancing", "Filter Cleaning", "Debris Removal", "Equipment Check"],
        "searchKeywords": ["pool", "swimming", "cleaning", "chemical", "filter", "water", "maintenance"]
      },
      {
        "title": "Landscaping",
        "description": "Garden design & maintenance",
        "price": "10000Fcfa/project",
        "icon": Icons.nature,
        "subServices": ["Garden Design", "Plant Installation", "Irrigation", "Maintenance"],
        "searchKeywords": ["landscaping", "landscape", "garden", "design", "plants", "irrigation", "outdoor"]
      },
      {
        "title": "Pressure Washing",
        "description": "Exterior surface cleaning",
        "price": "2000Fcfa/service",
        "icon": Icons.water_drop,
        "subServices": ["Driveway Cleaning", "House Exterior", "Deck Cleaning", "Concrete Cleaning"],
        "searchKeywords": ["pressure", "washing", "cleaning", "driveway", "exterior", "deck", "concrete"]
      },
    ],
    "Mechanics": [
      {
        "title": "General Repairs",
        "description": "All types of mechanical repairs",
        "price": "2000Fcfa/hr",
        "icon": Icons.construction,
        "subServices": ["General Repairs", "Appliance Fixing", "Roof Repairs", "Window & Door Fixing"],
        "searchKeywords": ["repairs", "fixing", "appliance", "roof", "window", "door", "maintenance", "mechanic"]
      },
      {
        "title": "Automotive Service",
        "description": "Complete car maintenance",
        "price": "From 10000Fcfa/service",
        "icon": Icons.car_repair,
        "subServices": ["Oil Change", "Tire Service", "Battery Replace", "Brake Service"],
        "searchKeywords": ["automotive", "car", "vehicle", "oil", "tire", "battery", "brake", "mechanic"]
      },
      {
        "title": "Electrical Work",
        "description": "Professional electrical services",
        "price": "From 5000Fcfa",
        "icon": Icons.electrical_services,
        "subServices": ["Wiring", "Lighting Installation", "Generator Maintenance", "Troubleshooting"],
        "searchKeywords": ["electrical", "wiring", "lighting", "generator", "electricity", "electrician"]
      },
      {
        "title": "Plumbing Service",
        "description": "Expert plumbing solutions",
        "price": "From 5000Fcfa",
        "icon": Icons.plumbing,
        "subServices": ["Pipe Installation", "Leak Repairs", "Bathroom Fittings", "Water Tank Cleaning"],
        "searchKeywords": ["plumbing", "plumber", "pipe", "leak", "bathroom", "water", "tank", "fittings"]
      },
    ],
  };

  // Get all services from all categories for search
  List<Map<String, dynamic>> getAllServices() {
    List<Map<String, dynamic>> allServices = [];
    categoryServices.forEach((category, services) {
      for (var service in services) {
        // Add category information to each service
        var serviceWithCategory = Map<String, dynamic>.from(service);
        serviceWithCategory['category'] = category;
        allServices.add(serviceWithCategory);
      }
    });
    return allServices;
  }

  // Filter services based on search query
  List<Map<String, dynamic>> getFilteredServices() {
    if (searchQuery.isEmpty) {
      return categoryServices[selectedCategory] ?? [];
    }

    List<Map<String, dynamic>> allServices = getAllServices();
    String query = searchQuery.toLowerCase();

    return allServices.where((service) {
      // Search in title
      if (service['title'].toString().toLowerCase().contains(query)) {
        return true;
      }

      // Search in description
      if (service['description'].toString().toLowerCase().contains(query)) {
        return true;
      }

      // Search in subServices
      List<String> subServices = List<String>.from(service['subServices']);
      for (String subService in subServices) {
        if (subService.toLowerCase().contains(query)) {
          return true;
        }
      }

      // Search in keywords
      if (service['searchKeywords'] != null) {
        List<String> keywords = List<String>.from(service['searchKeywords']);
        for (String keyword in keywords) {
          if (keyword.toLowerCase().contains(query)) {
            return true;
          }
        }
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayServices = getFilteredServices();

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
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  hintText: "Search Services (e.g., cleaning, plumbing, tutoring...)",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = "";
                      });
                    },
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Buttons (hidden when searching)
            if (searchQuery.isEmpty) ...[
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
            ],

            // Section Title
            Text(
              searchQuery.isEmpty
                  ? "Most Wanted"
                  : "Search Results (${displayServices.length} found)",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 15),

            // Service Cards
            if (displayServices.isNotEmpty) ...[
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 4),
                  itemCount: displayServices.length,
                  itemBuilder: (context, index) {
                    final service = displayServices[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(
                                        service['icon'],
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                    ),
                                    if (searchQuery.isNotEmpty && service['category'] != null) ...[
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          service['category'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.orange.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
            ] else if (searchQuery.isNotEmpty) ...[
              // No results found
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No services found for '$searchQuery'",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try searching for: cleaning, plumbing, tutoring, gardening, repairs",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            // All Services Section (only show when not searching)
            if (searchQuery.isEmpty) ...[
              const SizedBox(height: 30),
              const Text(
                "All Services",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 15),

              // Service Categories
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

// Sub-service Page (unchanged)
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
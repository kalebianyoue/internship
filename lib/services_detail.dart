import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(ServicesDetail());
}

class FirebaseService {
  Future<String> addBooking(BookingData bookingData) async {
    try {
      // Save to 'jobs' collection instead of 'bookings'
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('jobs')  // Changed to match your second app
          .add(bookingData.toMap());

      return docRef.id;
    } catch (e) {
      print('Error adding booking: $e');
      throw e;
    }
  }
}

class BookingData {
  String? id; // Firestore document ID
  String jobName;
  String UserId;
  int hours;
  DateTime selectedDate;
  String selectedTime;
  String location;
  String phoneNumber;
  File? workImage;
  String imageUrl; // URL for the uploaded image
  String description;
  double? latitude;
  double? longitude;
  double? budgetAmount;
  String budgetType;
  DateTime createdAt;
  String serviceCategory; // New field for service category
  String serviceTags; // New field for service tags/keywords

  BookingData({
    this.id,
    required this.jobName,
    required this.UserId,
    this.hours = 2,
    DateTime? selectedDate,
    this.selectedTime = '12:00',
    this.location = '',
    this.phoneNumber = '',
    this.workImage,
    this.imageUrl = '',
    this.description = '',
    this.latitude,
    this.longitude,
    this.budgetAmount,
    this.budgetType = 'none',
    DateTime? createdAt,
    this.serviceCategory = '',
    this.serviceTags = '',
  }) :
        selectedDate = selectedDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  final User? user = FirebaseAuth.instance.currentUser;

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'jobName': jobName,
      'UserId': user?.uid ?? UserId,
      'hours': hours,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
      'location': location,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'budgetAmount': budgetAmount,
      'budgetType': budgetType,
      'createdAt': createdAt,
      'serviceCategory': serviceCategory,
      'serviceTags': serviceTags,
      'status': 'active', // Job status
    };
  }

  // Create from Firestore document
  static BookingData fromMap(Map<String, dynamic> map, String id) {
    return BookingData(
      id: id,
      UserId: map['UserId'] ?? '',
      jobName: map['jobName'] ?? '',
      hours: map['hours'] ?? 0,
      selectedDate: (map['selectedDate'] as Timestamp).toDate(),
      selectedTime: map['selectedTime'] ?? '',
      location: map['location'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      budgetAmount: map['budgetAmount']?.toDouble(),
      budgetType: map['budgetType'] ?? 'none',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      serviceCategory: map['serviceCategory'] ?? '',
      serviceTags: map['serviceTags'] ?? '',
    );
  }
}

class ServicesDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ServiceSelectionPage(), // Start with service selection
    );
  }
}

// ------------------ PAGE 0: SERVICE SELECTION ------------------
class ServiceSelectionPage extends StatefulWidget {
  @override
  _ServiceSelectionPageState createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  final List<Map<String, dynamic>> services = [
    {
      'name': 'House Cleaning',
      'icon': Icons.cleaning_services,
      'category': 'Home Services',
      'description': 'Deep cleaning, regular cleaning, post-construction cleanup'
    },
    {
      'name': 'Plumbing',
      'icon': Icons.plumbing,
      'category': 'Home Repairs',
      'description': 'Pipe repairs, installations, leak fixes, drain cleaning'
    },
    {
      'name': 'Electrical Work',
      'icon': Icons.electrical_services,
      'category': 'Home Repairs',
      'description': 'Wiring, installations, repairs, electrical maintenance'
    },
    {
      'name': 'Carpentry',
      'icon': Icons.construction,
      'category': 'Home Repairs',
      'description': 'Furniture assembly, repairs, custom woodwork'
    },
    {
      'name': 'Painting',
      'icon': Icons.format_paint,
      'category': 'Home Improvement',
      'description': 'Interior/exterior painting, wall preparation, touch-ups'
    },
    {
      'name': 'Gardening',
      'icon': Icons.grass,
      'category': 'Outdoor Services',
      'description': 'Lawn care, landscaping, plant maintenance, weeding'
    },
    {
      'name': 'Moving Help',
      'icon': Icons.local_shipping,
      'category': 'Transportation',
      'description': 'Packing, loading, transportation, unpacking services'
    },
    {
      'name': 'Tutoring',
      'icon': Icons.school,
      'category': 'Education',
      'description': 'Academic support, language lessons, skill training'
    },
    {
      'name': 'Computer Repair',
      'icon': Icons.computer,
      'category': 'Technology',
      'description': 'Hardware repairs, software installation, troubleshooting'
    },
    {
      'name': 'Pet Care',
      'icon': Icons.pets,
      'category': 'Pet Services',
      'description': 'Walking, feeding, grooming, pet sitting'
    },
    {
      'name': 'Laundry Service',
      'icon': Icons.local_laundry_service,
      'category': 'Home Services',
      'description': 'Washing, drying, ironing, dry cleaning'
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz,
      'category': 'Custom',
      'description': 'Describe your custom service needs'
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredServices = services.where((service) {
      return service['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          service['category'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          service['description'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Service'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for services...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Services grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return ServiceCard(
                  service: service,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectHoursPage(
                          jobName: service['name'],
                          serviceCategory: service['category'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;

  const ServiceCard({Key? key, required this.service, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  service['icon'],
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              SizedBox(height: 12),
              Text(
                service['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                service['category'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  service['description'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ PAGE 1: SELECT HOURS ------------------
class SelectHoursPage extends StatefulWidget {
  final String jobName;
  final String? serviceCategory;
  final BookingData? bookingData;

  SelectHoursPage({required this.jobName, this.serviceCategory, this.bookingData});

  @override
  _SelectHoursPageState createState() => _SelectHoursPageState();
}

class _SelectHoursPageState extends State<SelectHoursPage> {
  late BookingData bookingData;

  @override
  void initState() {
    super.initState();
    bookingData = widget.bookingData ?? BookingData(
      jobName: widget.jobName,
      UserId: 'user123',
      serviceCategory: widget.serviceCategory ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 1/7), // 1 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookingData.jobName.toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  if (bookingData.serviceCategory.isNotEmpty)
                    Text(
                      bookingData.serviceCategory,
                      style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "How many hours of work?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Estimate the time needed for this service",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "minus",
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    if (bookingData.hours > 1) {
                      setState(() {
                        bookingData.hours--;
                      });
                    }
                  },
                  child: Icon(Icons.remove, size: 30, color: Colors.white),
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      "${bookingData.hours}h00",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "hours",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                FloatingActionButton(
                  heroTag: "plus",
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    setState(() {
                      bookingData.hours++;
                    });
                  },
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectDatePage(bookingData: bookingData),
                      ),
                    );
                  },
                  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 2: SELECT DATE ------------------
class SelectDatePage extends StatefulWidget {
  final BookingData bookingData;

  SelectDatePage({required this.bookingData});

  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 2/7), // 2 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Which day is best for you?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Select your preferred date for the service",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            Expanded(
              child: CalendarDatePicker(
                initialDate: widget.bookingData.selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    widget.bookingData.selectedDate = date;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectTimePage(bookingData: widget.bookingData),
                      ),
                    );
                  },
                  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 3: SELECT TIME ------------------
class SelectTimePage extends StatefulWidget {
  final BookingData bookingData;

  SelectTimePage({required this.bookingData});

  @override
  _SelectTimePageState createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  final List<String> timeSlots = [
    "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
    "11:00", "11:30", "12:00", "12:30", "13:00", "13:30",
    "14:00", "14:30", "15:00", "15:30", "16:00", "16:30"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 3/7), // 3 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "What time is best for you?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Choose your preferred time slot",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  String time = timeSlots[index];
                  bool isSelected = time == widget.bookingData.selectedTime;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.bookingData.selectedTime = time;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectLocationPage(bookingData: widget.bookingData),
                      ),
                    );
                  },
                  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 4: SELECT LOCATION ------------------
class SelectLocationPage extends StatefulWidget {
  final BookingData bookingData;

  SelectLocationPage({required this.bookingData});

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final List<String> cameroonCities = [
    'Yaoundé', 'Douala', 'Garoua', 'Bamenda', 'Maroua', 'Bafoussam',
    'Mokolo', 'Ngaoundéré', 'Bertoua', 'Loum', 'Kumba', 'Nkongsamba',
    'Mbouda', 'Dschang', 'Foumban', 'Ebolowa', 'Limbé', 'Kribi'
  ];

  String? selectedCity;
  TextEditingController phoneController = TextEditingController();
  MapController mapController = MapController();

  LatLng? selectedPoint;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.bookingData.phoneNumber;
    selectedCity = widget.bookingData.location.isNotEmpty ? widget.bookingData.location : null;

    // If we have saved coordinates, use them
    if (widget.bookingData.latitude != null && widget.bookingData.longitude != null) {
      selectedPoint = LatLng(widget.bookingData.latitude!, widget.bookingData.longitude!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 4/7), // 4 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Where and how to contact you?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Provide your location and contact information",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select your location:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      hint: Text("Choose a city in Cameroon"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: cameroonCities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                          widget.bookingData.location = value ?? '';
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Or choose on map:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),

                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            center: selectedPoint ?? LatLng(3.848, 11.502), // Yaoundé as default
                            zoom: selectedPoint != null ? 13.0 : 6.0,
                            onTap: (tapPosition, point) {
                              setState(() {
                                selectedPoint = point;
                                widget.bookingData.latitude = point.latitude;
                                widget.bookingData.longitude = point.longitude;
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName: 'com.example.booking_app',
                              maxZoom: 19,
                            ),
                            if (selectedPoint != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: selectedPoint!,
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Phone Number:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        prefixText: "+237 ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      onChanged: (value) {
                        widget.bookingData.phoneNumber = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (selectedCity != null || selectedPoint != null) && phoneController.text.isNotEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PricingPage(bookingData: widget.bookingData),
                      ),
                    );
                  }
                      : null,
                  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 5: PRICING (IMPROVED) ------------------
class PricingPage extends StatefulWidget {
  final BookingData bookingData;

  PricingPage({required this.bookingData});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  TextEditingController priceController = TextEditingController();
  String selectedBudgetType = 'none';
  bool showPriceInput = false;

  @override
  void initState() {
    super.initState();
    selectedBudgetType = widget.bookingData.budgetType;
    showPriceInput = selectedBudgetType != 'none';

    if (widget.bookingData.budgetAmount != null) {
      priceController.text = widget.bookingData.budgetAmount!.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 5/7), // 5 of 7 steps

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Set your budget preference",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Choose how you'd like to handle pricing for this service",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Option 1: Let service providers set price
                    Card(
                      elevation: selectedBudgetType == 'none' ? 3 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedBudgetType == 'none' ? Colors.blue : Colors.grey[300]!,
                          width: selectedBudgetType == 'none' ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedBudgetType = 'none';
                            showPriceInput = false;
                            widget.bookingData.budgetType = 'none';
                            widget.bookingData.budgetAmount = null;
                            priceController.clear();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'none',
                                groupValue: selectedBudgetType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedBudgetType = value!;
                                    showPriceInput = false;
                                    widget.bookingData.budgetType = 'none';
                                    widget.bookingData.budgetAmount = null;
                                    priceController.clear();
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Let Service Providers Quote",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: selectedBudgetType == 'none' ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Service providers will send you their price proposals. You can compare and choose the best offer.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chat_bubble_outline,
                                color: selectedBudgetType == 'none' ? Colors.blue : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Option 2: Set your own budget
                    Card(
                      elevation: selectedBudgetType != 'none' ? 3 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedBudgetType != 'none' ? Colors.blue : Colors.grey[300]!,
                          width: selectedBudgetType != 'none' ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedBudgetType = 'total';
                            showPriceInput = true;
                            widget.bookingData.budgetType = 'total';
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'total',
                                groupValue: selectedBudgetType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedBudgetType = value!;
                                    showPriceInput = true;
                                    widget.bookingData.budgetType = 'total';
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Set My Budget",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: selectedBudgetType != 'none' ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Specify your budget range. Service providers will know your price expectations upfront.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.attach_money,
                                color: selectedBudgetType != 'none' ? Colors.blue : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Price input field (shown when budget option is selected)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: showPriceInput ? null : 0,
                      child: showPriceInput ? Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Budget Amount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Budget (XAF)",
                                  hintText: "e.g. 15000",
                                  prefixText: "XAF ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  suffixIcon: priceController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      priceController.clear();
                                      widget.bookingData.budgetAmount = null;
                                    },
                                  )
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isNotEmpty) {
                                      widget.bookingData.budgetAmount = double.tryParse(value);
                                    } else {
                                      widget.bookingData.budgetAmount = null;
                                    }
                                  });
                                },
                              ),
                              if (priceController.text.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Your budget: XAF ${priceController.text} for ${widget.bookingData.hours} hours of ${widget.bookingData.jobName.toLowerCase()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ) : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedBudgetType == 'none')
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Price will be determined by Service Providers",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddImagePage(bookingData: widget.bookingData),
                    ),
                  );
                },
                child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 6: ADD IMAGE ------------------
class AddImagePage extends StatefulWidget {
  final BookingData bookingData;

  AddImagePage({required this.bookingData});

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          widget.bookingData.workImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 6/7), // 6 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Add a picture of the work area (optional)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "A photo helps service providers understand your needs better",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (widget.bookingData.workImage != null) ...[
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            widget.bookingData.workImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: Icon(Icons.camera_alt),
                              label: Text("Retake"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  widget.bookingData.workImage = null;
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: Text("Remove", style: TextStyle(color: Colors.red)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                          color: Colors.grey[50],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              "Add a photo to help\nservice providers understand your needs",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "(Optional)",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: Icon(Icons.camera_alt),
                              label: Text("Take Photo"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text("From Gallery"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DescriptionPage(bookingData: widget.bookingData),
                      ),
                    );
                  },
                  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ PAGE 7: DESCRIPTION ------------------
class DescriptionPage extends StatefulWidget {
  final BookingData bookingData;

  DescriptionPage({required this.bookingData});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.bookingData.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData.jobName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: 7/7), // 7 of 7 steps
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Describe the work",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Provide details to help service providers understand exactly what you need",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: "Provide details about the work you need done...\n\nExample: I need deep cleaning of my 3-bedroom apartment including kitchen, bathrooms, and living areas. Please bring your own supplies and focus on areas that haven't been cleaned in a while.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    widget.bookingData.description = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryPage(bookingData: widget.bookingData),
                ),
              );
            },
            child: Text("Review & Post", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ------------------ PAGE 8: IMPROVED SUMMARY & EDIT ------------------
class SummaryPage extends StatefulWidget {
  final BookingData bookingData;

  SummaryPage({required this.bookingData});

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  bool _isPosted = false;

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatBudget() {
    if (widget.bookingData.budgetType == 'none' || widget.bookingData.budgetAmount == null) {
      return "To be determined by Service Provider";
    } else {
      return "XAF ${widget.bookingData.budgetAmount!.toStringAsFixed(0)}";
    }
  }

  Color _getBudgetColor() {
    if (widget.bookingData.budgetType == 'none' || widget.bookingData.budgetAmount == null) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  IconData _getBudgetIcon() {
    if (widget.bookingData.budgetType == 'none' || widget.bookingData.budgetAmount == null) {
      return Icons.schedule;
    } else {
      return Icons.attach_money;
    }
  }

  Future<void> _postService() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Save booking to Firebase
      String bookingId = await _firebaseService.addBooking(widget.bookingData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('Service posted successfully! Service providers will contact you soon.'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        _isPosted = true;
      });

      // Auto navigate back to home after success
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Error posting service: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Your Booking"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work_outline, color: Colors.blue, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.bookingData.jobName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.bookingData.serviceCategory.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        widget.bookingData.serviceCategory,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Service Details Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),

                      _buildDetailRow(
                        icon: Icons.access_time,
                        title: "Duration",
                        value: "${widget.bookingData.hours} hour${widget.bookingData.hours > 1 ? 's' : ''}",
                        onEdit: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectHoursPage(
                              jobName: widget.bookingData.jobName,
                              serviceCategory: widget.bookingData.serviceCategory,
                              bookingData: widget.bookingData,
                            ),
                          ),
                        ),
                      ),

                      Divider(height: 24),

                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: "Date & Time",
                        value: "${_formatDate(widget.bookingData.selectedDate)} at ${widget.bookingData.selectedTime}",
                        onEdit: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDatePage(bookingData: widget.bookingData),
                          ),
                        ),
                      ),

                      Divider(height: 24),

                      _buildDetailRow(
                        icon: Icons.location_on,
                        title: "Location",
                        value: widget.bookingData.location.isNotEmpty ? widget.bookingData.location :
                        (widget.bookingData.latitude != null && widget.bookingData.longitude != null
                            ? "Custom location selected"
                            : "Not selected"),
                        onEdit: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationPage(bookingData: widget.bookingData),
                          ),
                        ),
                      ),

                      Divider(height: 24),

                      _buildDetailRow(
                        icon: Icons.phone,
                        title: "Contact",
                        value: "+237 ${widget.bookingData.phoneNumber}",
                        onEdit: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationPage(bookingData: widget.bookingData),
                          ),
                        ),
                      ),

                      Divider(height: 24),

                      _buildDetailRow(
                        icon: _getBudgetIcon(),
                        title: "Budget",
                        value: _formatBudget(),
                        valueColor: _getBudgetColor(),
                        onEdit: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PricingPage(bookingData: widget.bookingData),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Image Card (if image is added)
              if (widget.bookingData.workImage != null) ...[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.image, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Work Area Image",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddImagePage(bookingData: widget.bookingData),
                                ),
                              ),
                              child: Text("Edit", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.bookingData.workImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Description Card (if description is provided)
              if (widget.bookingData.description.isNotEmpty) ...[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DescriptionPage(bookingData: widget.bookingData),
                                ),
                              ),
                              child: Text("Edit", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            widget.bookingData.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ] else ...[
                SizedBox(height: 30),
              ],

              // Post button or success message
              _isLoading
                  ? Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Posting your service...",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
                  : _isPosted
                  ? Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 64),
                    SizedBox(height: 16),
                    Text(
                      "Service Posted Successfully!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Service providers in your area will contact you soon. You'll receive notifications when they send proposals.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.green[800]),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Returning to home page...",
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Ready to post? Service providers will see your request and send you proposals.",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: _postService,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Post My Service Request",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onEdit,
          child: Text("Edit", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}

// ------------------ JOB LIST APPLICATION ------------------
class JobListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Joblist(),
    );
  }
}

class Joblist extends StatelessWidget {
  const Joblist({super.key});

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatBudget(Map<String, dynamic> job) {
    if (job['budgetType'] == 'none' || job['budgetAmount'] == null) {
      return "To be determined by SP";
    } else {
      return "Budget: XAF ${job['budgetAmount'].toStringAsFixed(0)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Jobs",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading available jobs..."),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    "No job requests available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Check back later for new opportunities",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              var data = job.data() as Map<String, dynamic>;

              var jobName = data['jobName'] ?? 'Untitled Job';
              var description = data['description'] ?? 'No description provided';
              var location = data['location'] ?? 'Location not specified';
              var hours = data['hours'] ?? 'Hours not specified';
              var date = data['selectedDate'] != null
                  ? _formatDate((data['selectedDate'] as Timestamp).toDate())
                  : 'Date not specified';
              var time = data['selectedTime'] ?? 'Time not specified';
              var phone = data['phoneNumber'] ?? 'Phone not provided';
              var serviceCategory = data['serviceCategory'] ?? '';
              var createdAt = data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now();

              // Calculate how long ago the job was posted
              var timeAgo = DateTime.now().difference(createdAt).inHours;
              String timeAgoText = timeAgo < 1
                  ? "Just posted"
                  : timeAgo < 24
                  ? "${timeAgo}h ago"
                  : "${timeAgo ~/ 24}d ago";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with job title and time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.work_outline, color: Colors.blue, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jobName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (serviceCategory.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      serviceCategory,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeAgoText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "ACTIVE",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Description
                      if (description != 'No description provided') ...[
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                      ],

                      // Job details in a grid-like layout
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: Icons.access_time,
                                    label: "Duration",
                                    value: "$hours hrs",
                                  ),
                                ),
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: Icons.calendar_today,
                                    label: "Date",
                                    value: date,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: Icons.schedule,
                                    label: "Time",
                                    value: time,
                                  ),
                                ),
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: Icons.location_on,
                                    label: "Location",
                                    value: location,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: Icons.phone,
                                    label: "Contact",
                                    value: "+237 $phone",
                                  ),
                                ),
                                Expanded(
                                  child: _buildInfoItem(
                                    icon: data['budgetType'] == 'none'
                                        ? Icons.schedule
                                        : Icons.attach_money,
                                    label: "Budget",
                                    value: _formatBudget(data),
                                    valueColor: data['budgetType'] == 'none'
                                        ? Colors.orange[700]
                                        : Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Handle contact action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Contact feature coming soon!"),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                          icon: Icon(Icons.send, color: Colors.white, size: 18),
                          label: Text(
                            "Send Proposal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
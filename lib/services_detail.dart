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
    );
  }
}

class ServicesDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Booking Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SelectHoursPage(jobName: "y"  ), // Default job name
    );
  }
}

// ------------------ PAGE 1: SELECT HOURS ------------------
class SelectHoursPage extends StatefulWidget {
  final String jobName;
  final BookingData? bookingData;

  SelectHoursPage({required this.jobName, this.bookingData});

  @override
  _SelectHoursPageState createState() => _SelectHoursPageState();
}

class _SelectHoursPageState extends State<SelectHoursPage> {
  late BookingData bookingData;

  @override
  void initState() {
    super.initState();
    bookingData = widget.bookingData ?? BookingData(jobName: widget.jobName, UserId: 'user123');
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
              child: Text(
                bookingData.jobName.toUpperCase(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "How many hours of work?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                Text(
                  "${bookingData.hours}h00",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                        builder: (context) => AddImagePage(bookingData: widget.bookingData),
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

// ------------------ PAGE 5: ADD IMAGE ------------------
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
                "Add a picture of the work area (optional)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            widget.bookingData.workImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.bookingData.workImage = null;
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text("Remove Image", style: TextStyle(color: Colors.red)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ] else ...[
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          color: Colors.grey[50],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                            SizedBox(height: 10),
                            Text(
                              "Add a photo to help\nservice providers understand your needs",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
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
                              label: Text("Camera"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text("Gallery"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
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

// ------------------ PAGE 6: DESCRIPTION ------------------
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
                "Describe the work",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    hintText: "Provide details about the work you need done...\n\nExample: I need deep cleaning of my 3-bedroom apartment including kitchen, bathrooms, and living areas. Please bring your own supplies.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
                  builder: (context) => PricingPage(bookingData: widget.bookingData),
                ),
              );
            },
            child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ------------------ PAGE 7: PRICING (OPTIONAL) ------------------
class PricingPage extends StatefulWidget {
  final BookingData bookingData;

  PricingPage({required this.bookingData});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bookingData.budgetAmount != null) {
      priceController.text =
          widget.bookingData.budgetAmount!.toStringAsFixed(0);
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
            LinearProgressIndicator(value: 7/7), // 7 of 7 steps

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Set your budget (optional)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "You can suggest a budget. If you leave it empty, service providers will propose their own prices.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),

            // Price input field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Budget (XAF)",
                  hintText: "e.g. 10000",
                  prefixText: "XAF ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    widget.bookingData.budgetAmount = double.tryParse(value);
                  } else {
                    widget.bookingData.budgetAmount = null;
                  }
                },
              ),
            ),

            // Suggestion if empty
            if (priceController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "No budget set. Providers will send you their price offers.",
                  style: TextStyle(color: Colors.blue[700], fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),

      // Next button
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
                  builder: (context) =>
                      SummaryPage(bookingData: widget.bookingData),
                ),
              );
            },
            child: Text("Next",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ------------------ PAGE 8: SUMMARY & EDIT ------------------
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
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatBudget() {
    if (widget.bookingData.budgetType == 'none' || widget.bookingData.budgetAmount == null) {
      return "No budget specified";
    } else if (widget.bookingData.budgetType == 'total') {
      return "XAF ${widget.bookingData.budgetAmount!.toStringAsFixed(0)} (total)";
    } else {
      return "XAF ${widget.bookingData.budgetAmount!.toStringAsFixed(0)} per hour";
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
          content: Text('Booking posted successfully! Service providers will contact you soon.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _isPosted = true;
      });

      // You can navigate to a confirmation page or back to home
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ConfirmationPage(bookingId: bookingId)),
      // );

    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting service: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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
        title: Text("Booking Summary"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Review Your Booking",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                        context,
                        "Service",
                        widget.bookingData.jobName,
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectHoursPage(
                                      jobName: widget.bookingData.jobName,
                                      bookingData: widget.bookingData,
                                    ),
                              ),
                            ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Duration",
                        "${widget.bookingData.hours}h00",
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectHoursPage(
                                      jobName: widget.bookingData.jobName,
                                      bookingData: widget.bookingData,
                                    ),
                              ),
                            ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Date",
                        _formatDate(widget.bookingData.selectedDate),
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectDatePage(bookingData: widget.bookingData),
                              ),
                            ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Time",
                        widget.bookingData.selectedTime,
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectTimePage(bookingData: widget.bookingData),
                              ),
                            ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Location",
                        widget.bookingData.location.isNotEmpty ? widget.bookingData.location :
                        (widget.bookingData.latitude != null &&
                            widget.bookingData.longitude != null
                            ? "Custom location (${widget.bookingData.latitude!
                            .toStringAsFixed(4)}, ${widget.bookingData.longitude!
                            .toStringAsFixed(4)})"
                            : "Not selected"),
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectLocationPage(
                                        bookingData: widget.bookingData),
                              ),
                            ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Phone",
                        "+237 ${widget.bookingData.phoneNumber}",
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectLocationPage(
                                        bookingData: widget.bookingData),
                              ),
                            ),
                      ),
                      if (widget.bookingData.workImage != null) ...[
                        Divider(),
                        _buildImageRow(context),
                      ],
                      if (widget.bookingData.description.isNotEmpty) ...[
                        Divider(),
                        _buildDescriptionRow(context),
                      ],
                      Divider(),
                      _buildSummaryRow(
                        context,
                        "Budget",
                        _formatBudget(),
                            () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PricingPage(bookingData: widget.bookingData),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _isPosted
                  ? Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 50),
                    SizedBox(height: 16),
                    Text(
                      "Service Posted Successfully!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Service providers will contact you soon.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _postService,
                  child: Text(
                    "Post Service",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String title, String value, VoidCallback onEdit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(value, style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Work Image",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 8),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      widget.bookingData.workImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddImagePage(bookingData: widget.bookingData),
                  ),
                ),
            child: Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 4),
                Text(
                  widget.bookingData.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DescriptionPage(bookingData: widget.bookingData),
                  ),
                ),
            child: Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Job List",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No job posts available."));
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              var jobName = job['jobName'] ?? 'Untitled Job';
              var description = job['description'] ?? 'No description provided';
              var location = job['location'] ?? 'Location not specified';
              var hours = job['hours'] ?? 'Hours not specified';
              var date = job['selectedDate'] != null
                  ? (job['selectedDate'] as Timestamp).toDate().toString().substring(0, 10)
                  : 'Date not specified';
              var time = job['selectedTime'] ?? 'Time not specified';
              var phone = job['phoneNumber'] ?? 'Phone not provided';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(jobName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      SizedBox(height: 4),
                      Text("Location: $location"),
                      Text("Duration: ${hours} hours"),
                      Text("Date: $date at $time"),
                      Text("Contact: +237 $phone"),
                    ],
                  ),
                  isThreeLine: true,
                  leading: const Icon(Icons.work, color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
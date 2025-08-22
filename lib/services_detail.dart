import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(ServicesDetail());
}

class BookingData {
  String jobName;
  int hours;
  DateTime selectedDate;
  String selectedTime;
  String location;
  String phoneNumber;
  File? workImage;
  String description;
  double? latitude;
  double? longitude;

  BookingData({
    this.jobName = 'House',
    this.hours = 2,
    DateTime? selectedDate,
    this.selectedTime = '12:00',
    this.location = '',
    this.phoneNumber = '',
    this.workImage,
    this.description = '',
    this.latitude,
    this.longitude,
  }) : selectedDate = selectedDate ?? DateTime.now();
}

class ServicesDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SelectHoursPage(jobName: ''), // Pass job name here
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
    bookingData = widget.bookingData ?? BookingData(jobName: widget.jobName);
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
            LinearProgressIndicator(value: 0.16), // Updated for 6 steps
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
            LinearProgressIndicator(value: 0.33),
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
            LinearProgressIndicator(value: 0.50),
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
            LinearProgressIndicator(value: 0.66),
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
            LinearProgressIndicator(value: 0.83),
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
            LinearProgressIndicator(value: 1.0),
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
                  builder: (context) => SummaryPage(bookingData: widget.bookingData),
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

// ------------------ PAGE 7: SUMMARY & EDIT ------------------
class SummaryPage extends StatelessWidget {
  final BookingData bookingData;

  SummaryPage({required this.bookingData});

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
                        "Service",
                        bookingData.jobName,
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectHoursPage(
                              jobName: bookingData.jobName,
                              bookingData: bookingData,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        "Duration",
                        "${bookingData.hours}h00",
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectHoursPage(
                              jobName: bookingData.jobName,
                              bookingData: bookingData,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        "Date",
                        _formatDate(bookingData.selectedDate),
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDatePage(bookingData: bookingData),
                          ),
                        ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        "Time",
                        bookingData.selectedTime,
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectTimePage(bookingData: bookingData),
                          ),
                        ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        "Location",
                        bookingData.location.isNotEmpty ? bookingData.location :
                        (bookingData.latitude != null && bookingData.longitude != null
                            ? "Custom location (${bookingData.latitude!.toStringAsFixed(4)}, ${bookingData.longitude!.toStringAsFixed(4)})"
                            : "Not selected"),
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationPage(bookingData: bookingData),
                          ),
                        ),
                      ),
                      Divider(),
                      _buildSummaryRow(
                        "Phone",
                        "+237 ${bookingData.phoneNumber}",
                            () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationPage(bookingData: bookingData),
                          ),
                        ),
                      ),
                      if (bookingData.workImage != null) ...[
                        Divider(),
                        _buildImageRow(context),
                      ],
                      if (bookingData.description.isNotEmpty) ...[
                        Divider(),
                        _buildDescriptionRow(context),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                    // Navigate to service providers list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking completed! Searching for service providers...')),
                    );
                  },
                  child: Text(
                    "See Service Providers",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, VoidCallback onEdit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                Text("Work Image", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
                      bookingData.workImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddImagePage(bookingData: bookingData),
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
                Text("Description", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 4),
                Text(
                  bookingData.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DescriptionPage(bookingData: bookingData),
              ),
            ),
            child: Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
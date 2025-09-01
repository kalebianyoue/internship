import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OperatingAreaPage extends StatefulWidget {
  const OperatingAreaPage({super.key});

  @override
  State<OperatingAreaPage> createState() => _OperatingAreaPageState();
}

class _OperatingAreaPageState extends State<OperatingAreaPage> {
  static const LatLng _defaultLocation = LatLng(3.8480, 11.5021); // Yaoundé
  static const double _defaultZoom = 10.0;
  static const double _selectedZoom = 12.0;
  static const double _radiusKm = 30.0;

  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  LatLng _selectedLocation = _defaultLocation;
  bool _isLoadingLocation = false;
  String? _errorMessage;
  Timer? _searchDebouncer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer?.cancel();
    super.dispose();
  }

  /// Set circle around location
  void _setOperatingArea(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _errorMessage = null;
    });
  }

  /// Show error
  void _showError(String message) {
    setState(() => _errorMessage = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Search with Nominatim
  Future<List<LocationSuggestion>> _searchLocation(String query) async {
    if (query.isEmpty || query.length < 3) return [];
    _searchDebouncer?.cancel();

    final completer = Completer<List<LocationSuggestion>>();
    _searchDebouncer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final encodedQuery = Uri.encodeComponent('$query, Cameroon');
        final url =
            'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'FlutterApp/1.0',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final suggestions = data
              .map((item) =>
              LocationSuggestion.fromJson(item as Map<String, dynamic>))
              .where((s) => s.isValid)
              .toList();
          completer.complete(suggestions);
        } else {
          throw Exception('Server returned ${response.statusCode}');
        }
      } catch (e) {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  /// Go to current location
  Future<void> _goToCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLocation, _selectedZoom);
      _setOperatingArea(currentLocation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Current location found!'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to get location: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  /// Handle suggestion chosen
  void _onLocationSelected(LocationSuggestion suggestion) {
    LatLng selected = LatLng(suggestion.latitude, suggestion.longitude);
    _mapController.move(selected, _selectedZoom);
    _setOperatingArea(selected);
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  /// Save and return area
  void _saveArea() {
    Navigator.pop(context, {
      "center": _selectedLocation,
      "radiusKm": _radiusKm,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Define Operating Area"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          if (_errorMessage != null) _buildErrorMessage(),
          Expanded(child: _buildMap()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: TypeAheadField<LocationSuggestion>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search in Cameroon',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        suggestionsCallback: _searchLocation,
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: const Icon(Icons.location_city, color: Colors.blue),
            title: Text(suggestion.displayName,
                maxLines: 2, overflow: TextOverflow.ellipsis),
          );
        },
        onSuggestionSelected: _onLocationSelected,
        noItemsFoundBuilder: (context) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No locations found."),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade800))),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _selectedLocation,
        zoom: _defaultZoom,
        minZoom: 5.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) => _setOperatingArea(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.operating_area_selector',
          maxZoom: 18,
        ),
        CircleLayer(circles: [
          CircleMarker(
            point: _selectedLocation,
            radius: _radiusKm * 1000, // in meters
            color: Colors.blue.withOpacity(0.2),
            borderStrokeWidth: 2,
            borderColor: Colors.blue,
          ),
        ]),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
              icon: _isLoadingLocation
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.my_location),
              label: Text(_isLoadingLocation ? "Locating..." : "Use Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveArea,
              icon: const Icon(Icons.save),
              label: const Text("Save Operating Area"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Selected: ${_selectedLocation.latitude.toStringAsFixed(4)}, ${_selectedLocation.longitude.toStringAsFixed(4)}\nRadius: $_radiusKm km",
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

class LocationSuggestion {
  final String displayName;
  final double latitude;
  final double longitude;

  LocationSuggestion({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      displayName: json['display_name'] ?? 'Unknown',
      latitude: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['lon']?.toString() ?? '0') ?? 0.0,
    );
  }

  bool get isValid => latitude != 0.0 || longitude != 0.0;
}

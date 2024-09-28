import 'package:cab_sample_app/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Add this package for geocoding

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  LatLng _currentPosition = const LatLng(0, 0);
  LatLng? _destinationPosition;
  late MapController _mapController;
  late TabController _tabController; // Add TabController to manage tab selection
  List<String> _suggestions = [];
  TextEditingController destinationController = TextEditingController();

  final List<String> cabTypes = ['Standard', 'Luxury', 'SUV'];
  bool _showConfirmBookingButton = false; // To control the visibility of the "Confirm Booking" button

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _tabController = TabController(length: cabTypes.length, vsync: this); // Initialize TabController
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController when the widget is destroyed
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location access is denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Denied Forever", "Please enable location permissions in the app settings.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition, 14); // Move map to current location
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom; // Get the keyboard height

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Ride'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _currentPosition,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (_destinationPosition != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _destinationPosition!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_destinationPosition != null) // Display only after the destination is confirmed
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Location: ${_currentPosition.latitude}, ${_currentPosition.longitude}'),
                      const SizedBox(height: 5),
                      Text('Destination: ${_destinationPosition?.latitude}, ${_destinationPosition?.longitude}'),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 50 + bottomPadding, // Adjust based on keyboard height
            left: 15,
            right: 15,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Pass the selected tab index to the showRideRequestForm
                        showRideRequestForm(context, _tabController.index);
                      },
                      child: const Text('Request a Ride'),
                    ),
                    if (_showConfirmBookingButton) // Show "Confirm Booking" button after destination is set
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to PaymentScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                cabType: cabTypes[_tabController.index], // Use the selected cab type
                                destinationLocation: destinationController.text,
                                currentLocation: _currentPosition,
                              ),
                            ),
                          );
                        },
                        child: const Text('Confirm Booking'),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white70,
                  child: TabBar(
                    controller: _tabController, // Bind TabController
                    tabs: cabTypes.map((String cabType) {
                      return Tab(text: cabType);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showRideRequestForm(BuildContext context, int index) {
    showModalBottomSheet(
      useSafeArea: true,
      isDismissible: false, // Prevent accidental dismissal
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true, // Makes the modal sheet full height
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                  ),
                  onChanged: (value) {
                    fetchSuggestions(value);
                  },
                ),
                const SizedBox(height: 10),
                if (_suggestions.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            destinationController.text = _suggestions[index];
                            _suggestions.clear();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String destination = destinationController.text;
                    locateDestination(destination);
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm Destination'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      // If the user closed the bottom sheet, refocus the destination text field
      if (value == null) {
        FocusManager.instance.primaryFocus?.requestFocus();
      }
    });
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isNotEmpty) {
      _suggestions = [
        '123 Main St, Springfield',
        '456 Elm St, Springfield',
        '789 Maple St, Springfield',
      ].where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();

      setState(() {});
    } else {
      _suggestions.clear();
    }
  }

  Future<void> locateDestination(String destination) async {
    try {
      List<Location> locations = await locationFromAddress(destination);
      if (locations.isNotEmpty) {
        setState(() {
          _destinationPosition = LatLng(locations.first.latitude, locations.first.longitude);
          _mapController.move(_destinationPosition!, 14);
          _showConfirmBookingButton = true; // Show "Confirm Booking" button after destination is set
        });
      } else {
        Get.snackbar("Location Not Found", "Unable to locate the destination.");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not find any result for the supplied address.");
    }
  }
}

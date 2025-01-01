import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapWithMarker extends StatefulWidget {
  final LatLng initialLocation;

  /// Constructor to initialize the map with a specific initial location.
  const GoogleMapWithMarker({
    Key? key,
    required this.initialLocation,
  }) : super(key: key);

  @override
  _GoogleMapWithMarkerState createState() => _GoogleMapWithMarkerState();
}

class _GoogleMapWithMarkerState extends State<GoogleMapWithMarker> {
  GoogleMapController? _mapController; // Nullable controller
  late LatLng _currentPosition; // Non-nullable but initialized in initState

  @override
  void initState() {
    super.initState();
    _currentPosition =
        widget.initialLocation; // Initialize with the provided initial location
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _currentPosition =
                    position.target; // Update position during movement
              });
            },
            onCameraIdle: () {
              _showAddressFromLatLng(
                  _currentPosition); // Fetch and show address
            },
          ),
          Center(
            child: const Icon(
              Icons.location_on,
              size: 40,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddressFromLatLng(LatLng position) async {
    try {
      // Fetch placemarks for the given position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        print(place.locality);

        // Show the address in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Current Address: $address"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No address found for this location."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }}

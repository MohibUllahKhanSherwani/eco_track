import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapWithMarker extends StatefulWidget {
  final LatLng initialLocation;
  final Function(String) onLocationSelected;

  const GoogleMapWithMarker({
    Key? key,
    required this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _GoogleMapWithMarkerState createState() => _GoogleMapWithMarkerState();
}

class _GoogleMapWithMarkerState extends State<GoogleMapWithMarker> {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialLocation;
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
                _currentPosition = position.target;
              });
            },
            onCameraIdle: () {
              _showAddressFromLatLng(_currentPosition);
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // String address =
        //     "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        String address =
        "${place.locality}, ${place.street}, ${place.administrativeArea}, ${place.country}";


        widget.onLocationSelected(address);
      } else {
        widget.onLocationSelected("No address found");
      }
    } catch (e) {
      widget.onLocationSelected("Error: ${e.toString()}");
    }
  }
}


import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../map.dart';


class EcoFriendlyActivity extends StatefulWidget {
  const EcoFriendlyActivity({required this.userId, super.key});

  final int userId;

  @override
  State<EcoFriendlyActivity> createState() => _EcoState();
}

class _EcoState extends State<EcoFriendlyActivity> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  void _onLocationSelected(String address) {
    setState(() {
      _locationController.text = address;
    });
  }
  void _initActivity() async {
    final conn = DatabaseConnection().connection;

    // Check database connection
    if (conn == null || !conn.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not connect to database. Make sure you have internet',
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final location = _locationController.text;
      final title = _titleController.text;
      final description = _descriptionController.text;
      final participants = int.tryParse(_participantsController.text);
      final date = _dateController.text;


      try {
        // Insert into environmental issues table
        await conn.execute(
          'INSERT INTO `eco_friendly_activities` (location, organizer_id, title, description, `participants_count`, date) VALUES (:location, :organizer_id, :title, :description, :participants_count, :date)',
          {
            "location": location,
            "organizer_id": widget.userId,
            "title": title,
            "description": description,
            "participants_count": participants,
            "date": date
          },
        );

        await conn.execute('UPDATE user SET points = points + 30 where id = :user_id',
            {
              "user_id": widget.userId,
            }
        );

        // Show confirmation snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity intitated!')),
        );
      } catch (e) {
        print('Error while initiating activity: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Initiate an activity",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Utils.primaryBlueAdmin,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Activity details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onTap: () async {
                  String address = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapWithMarker(
                        initialLocation: LatLng(34.1688, 73.2215),
                        onLocationSelected: _onLocationSelected,
                      ),
                    ),
                  );
                  _locationController.text = address;
                },
                readOnly: true,
              ),
              const SizedBox(height: 16.0),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Participants count
              TextFormField(
                controller: _participantsController,
                decoration: const InputDecoration(
                  labelText: 'Participants required',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                readOnly: true, // Prevents manual editing
                decoration: const InputDecoration(
                  labelText: 'Select a date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _initActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Utils.primaryBlueAdmin,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                  ),
                  child: const Text(
                    'Initiate Activity',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

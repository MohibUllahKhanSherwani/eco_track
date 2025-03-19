
import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'map.dart';
import 'notification_service.dart';

class Report extends StatefulWidget {
  const Report({required this.userId, super.key});

  final int userId;

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = ['Air', 'Land', 'Water', 'Noise'];

  void _submitReport() async {
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
      final category = _selectedCategory;

      try {
        // Insert into environmental issues table
        await conn.execute(
          'INSERT INTO enviromental_issues (status, location, reporter_id, title, description, category) VALUES (:status, :location, :reporter_id, :title, :description, :category)',
          {
            "status": 0,
            "location": location,
            "reporter_id": widget.userId,
            "title": title,
            "description": description,
            "category": category,
          },
        );

        await conn.execute('UPDATE user SET points = points + 50 where id = :user_id',
            {
              "user_id": widget.userId,
            }
        );

        // Insert into notifications table
        final notificationMessage =
            'Your report "$title" has been submitted successfully.';
        String timestamp = DateFormat('yyyy-MM-dd').format(DateTime.now());

        await conn.execute(
          'INSERT INTO notification (user_id, message, time_stamp, title, description) VALUES (:user_id, :message, :time_stamp, :title, :description)',
          {
            "user_id": widget.userId,
            "message": notificationMessage,
            "time_stamp": timestamp,
            "title": title,
            "description": description,
          },
        );

        // Show notification
        final notificationService = NotificationService();
        await notificationService.showNotification(
          title,
          notificationMessage,
        );

        // Show confirmation snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );
      } catch (e) {
        print('Error while submitting the report or adding notification: $e');
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

  void _onLocationSelected(String address) {
    setState(() {
      _locationController.text = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report an Issue",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Utils.c3,
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
                "Report Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

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

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                    value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              const SizedBox(height: 24.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Utils.c3,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                  ),
                  child: const Text(
                    'Submit Report',
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


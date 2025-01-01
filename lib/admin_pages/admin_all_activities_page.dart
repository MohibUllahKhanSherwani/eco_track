import 'package:flutter/material.dart';

import '../ecotrack_db.dart';
import '../utilities.dart';
class AdminAllActivities extends StatefulWidget {
  final int userId;


  const AdminAllActivities(
      {
        super.key,
        required this.userId
      });

  @override
  State<AdminAllActivities> createState() => _AdminAllActivities();
}
class _AdminAllActivities extends State<AdminAllActivities> {
  bool isLoading = true;
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    setState(() {
      isLoading = true;
    });

    try {
      final conn = DatabaseConnection().connection;
      if (conn != null) {
        final results = await conn.execute(
          "SELECT title, description, location, participants_count, date, name FROM eco_friendly_activities JOIN user WHERE eco_friendly_activities.organizer_id = user.id",
        );

        setState(() {
          activities = results.rows
              .map((row) => {
            'title': row.colAt(0),
            'description': row.colAt(1),
            'location': row.colAt(2),
            'participants_count': row.colAt(3),
            'date': row.colAt(4),
            'name': row.colAt(5)
          })
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching activities: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.primaryBlueAdmin,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Eco-Friendly Activities',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:  Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade100,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // List of Activities
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : activities.isEmpty
                    ? const Center(
                  child: Text(
                    "No activities found!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Location: ${activity['location'] ?? 'Unknown'}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activity['description'] ?? 'No Description',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Participants: ${activity['participants_count'] ?? 0}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Date: ${activity['date'] ?? 'Unknown'}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Organized by: ${activity['name'] ?? 'Unknown'}",
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Close Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Utils.primaryBlueAdmin,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
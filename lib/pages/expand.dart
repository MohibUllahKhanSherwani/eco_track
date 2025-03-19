import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../ecotrack_db.dart';
import '../map.dart';

class ExpandedContainer1 extends StatelessWidget {
  final String title;
  final IconData icon;

  const ExpandedContainer1(
      {super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.c3,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Expanded View',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Hero(
          tag: '$title-container-1',
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.6,
            // Expanded size
            width: MediaQuery.of(context).size.width * 0.7,
            // Expanded size
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.black54),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black54),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandedContainer2 extends StatefulWidget {
  final int userId;
  final String title;
  final IconData icon;

  const ExpandedContainer2(
      {super.key,
      required this.title,
      required this.icon,
      required this.userId});

  @override
  State<ExpandedContainer2> createState() => _ExpandedContainer2State();
}
class _ExpandedContainer2State extends State<ExpandedContainer2> {
  bool isLoading = true;
  List<Map<String, dynamic>> issues = [];

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  Future<void> fetchIssues() async {
    setState(() {
      isLoading = true;
    });

    try {
      final conn = DatabaseConnection().connection;
      if (conn != null) {
        final results = await conn.execute(
          "SELECT status, location, title, description, category FROM `enviromental_issues` WHERE reporter_id = :userId",
          {"userId": widget.userId},
        );

        setState(() {
          issues = results.rows
              .map((row) => {
            'status': int.tryParse(row.colAt(0).toString()) == 1 ? "Closed" : "Open",
           // 'status': row.colAt(0) == 1 ? "Closed" : "Open",
            'location': row.colAt(1),
            'title': row.colAt(2),
            'description': row.colAt(3),
            'category': row.colAt(4),
          })
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching issues: $e");
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
        backgroundColor: Utils.c3,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Environmental Issues',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Hero(
        tag: '${widget.title}-container-2',
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            boxShadow:  [
              BoxShadow(
                color: Colors.green.shade100, //Background
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // List of Issues
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : issues.isEmpty
                    ? const Center(
                  child: Text(
                    "No issues found!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  issue['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    issue['status'],
                                    style: TextStyle(
                                      color:  Colors.white,
                                    ),
                                  ),
                                  backgroundColor: issue['status'] ==
                                      "Open"
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Location: ${issue['location']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              issue['description'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Category: ${issue['category']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
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
                  backgroundColor: Utils.c3,
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
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
class ExpandedContainer3 extends StatefulWidget {
  final int userId;
  final String title;
  final IconData icon;

  const ExpandedContainer3(
      {
        super.key,
        required this.title,
        required this.icon,
        required this.userId
      });

  @override
  State<ExpandedContainer3> createState() => _ExpandedContainer3State();
}
class _ExpandedContainer3State extends State<ExpandedContainer3> {
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
          "SELECT title, description, location, participants_count, date FROM eco_friendly_activities",
        );

        setState(() {
          activities = results.rows
              .map((row) => {
            'title': row.colAt(0),
            'description': row.colAt(1),
            'location': row.colAt(2),
            'participants_count': row.colAt(3),
            'date': row.colAt(4),
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
        backgroundColor: Utils.c3,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Eco-Friendly Activities',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Hero(
        tag: '${widget.title}-container-2',
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
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
                  backgroundColor: Utils.c3,
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
      ),
    );
  }
}
class MarkerMap extends StatelessWidget {
  final IconData icon;

  const MarkerMap({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Expanded View',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Hero(
              tag:
              'small-button-$icon', // Matching the tag from the "Completed" container
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                height:
                MediaQuery.of(context).size.height * 0.7, // Expanded size
                width: MediaQuery.of(context).size.width * 0.9, // Expanded size
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: GoogleMapWithMarker(
                  initialLocation:
                  LatLng(37.7749, -122.4194), onLocationSelected: (String ) {  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red.shade300),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(200, 50),
                ),
              ))
        ],
      ),
    );
  }
}
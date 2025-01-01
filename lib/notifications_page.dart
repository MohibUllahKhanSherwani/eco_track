import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final int userId;
  const Notifications({super.key, required this.userId});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final conn = DatabaseConnection().connection;
      if (conn != null) {
        final results = await conn.execute(
          "SELECT title, description, time_stamp FROM notification WHERE user_id = :userId",
          {"userId": widget.userId},
        );

        setState(() {
          notifications = results.rows
              .map((row) => {
            'title': row.colAt(0),
            'description': row.colAt(1),
            'time_stamp': row.colAt(2),
          })
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching notifications: $e");
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
        title: const Text("Notifications"),
        backgroundColor: Utils.c3,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(
        child: Text(
          "No notifications available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                notification["title"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification["description"]),
                  const SizedBox(height: 4),
                  Text(
                    notification["time_stamp"] ,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


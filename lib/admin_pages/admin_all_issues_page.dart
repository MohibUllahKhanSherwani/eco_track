import 'package:flutter/material.dart';

import '../ecotrack_db.dart';
import '../utilities.dart';
class AdminAllIssues extends StatefulWidget {
  final int userId;


  const AdminAllIssues(
      {super.key,
        required this.userId});

  @override
  State<AdminAllIssues> createState() => _AdminAllIssuesState();
}
class _AdminAllIssuesState extends State<AdminAllIssues> {
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
          "SELECT status, location, title, description, category, name FROM `enviromental_issues` join user where enviromental_issues.reporter_id = user.id",
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
            'name': row.colAt(5)
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
        backgroundColor: Utils.primaryBlueAdmin,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Environmental Issues',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
         Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Utils.primaryBlueAdmin.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            boxShadow:  [
              BoxShadow(
                color: Colors.green.shade100,
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
                            Text(
                              "Submitted by: ${issue['name']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
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
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
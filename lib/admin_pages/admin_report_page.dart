import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ecotrack_db.dart';
import '../utilities.dart';

class AdminReportPage extends StatefulWidget {
  final int userId;
  const AdminReportPage({super.key, required this.userId});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
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
          "SELECT issue_id, status, location, title, description, category FROM `enviromental_issues` WHERE status = 0",
        );

        setState(() {
          issues = results.rows
              .map((row) => {
            'issueId': row.colAt(0),
            'status': "Open",
            'location': row.colAt(2),
            'title': row.colAt(3),
            'description': row.colAt(4),
            'category': row.colAt(5),
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

  Future<void> handleIssue(int issueId) async {
    TextEditingController resolutionStepsController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Report for Issue"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date Picker
                    Row(
                      children: [
                        const Text("Issue Date: "),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                                formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                              });
                            }
                          },
                          child: Text(
                            formattedDate,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    // Resolution Steps
                    TextField(
                      controller: resolutionStepsController,
                      decoration: const InputDecoration(
                        labelText: "Resolution Steps",
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (resolutionStepsController.text.isNotEmpty) {
                      await createReport(
                        issueId,
                        formattedDate,
                        resolutionStepsController.text,
                        widget.userId,
                      );
                      Navigator.pop(context);
                      fetchIssues();
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Future<void> createReport(
      int issueId, String issueDate, String resolutionSteps, int authorityId) async {
    try {
      final conn = DatabaseConnection().connection;
      if (conn != null) {
        // Insert into the report table
        await conn.execute(
          "INSERT INTO report (issue_date, resolution_steps, authority_id, issue_id) "
              "VALUES (:issueDate, :resolutionSteps, :authorityId, :issueId)",
          {
            "issueDate": issueDate,
            "resolutionSteps": resolutionSteps,
            "authorityId": authorityId,
            "issueId": issueId,
          },
        );

        // Update the issue's status to Closed
        await conn.execute(
          "UPDATE enviromental_issues SET status = 1 WHERE issue_id = :issueId",
          {"issueId": issueId},
        );

        print("Report created and issue status updated successfully.");
      }
    } catch (e) {
      print("Error creating report: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Utils.primaryBlueAdmin,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Admin Reports',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : issues.isEmpty
          ? const Center(
        child: Text(
          "No open issues found!",
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
            child: ListTile(
              title: Text(
                issue['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Issue ID: ${issue['issueId']}"),
                  Text("Status: ${issue['status']}"),
                  Text("Location: ${issue['location']}"),
                  Text("Category: ${issue['category']}"),
                ],
              ),
              trailing: IconButton(
                icon:  Icon(Icons.edit, color: Utils.primaryBlueAdmin),
                onPressed: () {
                  handleIssue(int.tryParse(issue['issueId'].toString())?? 0);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

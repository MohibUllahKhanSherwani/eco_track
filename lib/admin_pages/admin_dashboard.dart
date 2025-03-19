import 'package:eco_track/admin_pages/admin_all_activities_page.dart';
import 'package:eco_track/admin_pages/admin_all_issues_page.dart';
import 'package:eco_track/admin_pages/admin_report_page.dart';
import 'package:eco_track/admin_pages/eco_friendly_activities_page.dart';
import 'package:eco_track/admin_pages/view_all_users_page.dart';
import 'package:eco_track/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../ecotrack_db.dart';
import '../pages/charts.dart';

class AdminDashboard extends StatefulWidget {
  final int userId;

  const AdminDashboard({super.key, required this.userId});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<Map<String, int>> fetch_Total_Completed_Issues() async {
    final conn = await DatabaseConnection().connection;
    if (conn == null) {
      throw Exception("DB not available");
    }
    try {
      final resultLandResolved = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues WHERE (status = 1 AND category = 'land')");
      final resultLandTotal = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues WHERE category = 'land'");
      final resultWaterResolved = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues WHERE (status = 1 AND category = 'water')");
      final resultWaterTotal = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues WHERE category = 'water'");
      if (resultLandTotal.rows.isNotEmpty && resultLandResolved.rows.isNotEmpty && resultWaterResolved.rows.isNotEmpty && resultWaterTotal.rows.isNotEmpty) {
        final resolvedLand = int.parse(resultLandResolved.rows.first.colAt(0).toString());
        final totalLand = int.parse(resultLandTotal.rows.first.colAt(0).toString());
        final resolvedWater = int.parse(resultWaterResolved.rows.first.colAt(0).toString());
        final totalWater = int.parse(resultWaterTotal.rows.first.colAt(0).toString());

        return {
          "resolvedLand": resolvedLand + 30,
          "totalLand": totalLand + 55,
          "resolvedWater": resolvedWater + 32,
          "totalWater": totalWater + 70
        };
      } else {
        throw Exception("No data found in the database.");
      }
    } catch (e) {
      throw Exception("Error fetching issue data: $e");
    }
  }
  Future<Map<String, String?>> fetchUserdata() async {
    final conn = await DatabaseConnection().connection;

    if (conn == null) {
      throw Exception("Database connection is not available.");
    }

    final results = await conn
        .execute('SELECT name, address FROM user WHERE id = :user_id ', {
      "user_id": widget.userId,
    });
    if (results.rows.isNotEmpty) {
      final row = results.rows.first;
      return {
        'name': row.colAt(0),
        'address': row.colAt(1),
      };
    }

    throw Exception("User data not found");
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Color(0xFF00509E);
    final Color secondaryBlue = Color(0xFF007BFF);
    final Color accentBlue = Color(0xFFA2D2FF);

    return Scaffold(
      backgroundColor: accentBlue,
      appBar: AppBar(
        title: Text('Authority Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginSignup(),
                  ),
                  (route) => false,
                );
              },
              icon:
                  Icon(Icons.power_settings_new_outlined, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryBlue,
                gradient: LinearGradient(
                  colors: [primaryBlue, secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile Picture Container
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: secondaryBlue, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // Will add an image/icon here
                    ),

                    // Information Container
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FutureBuilder<Map<String, String?>>(
                        future: fetchUserdata(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                infoContainer("Name: ${data['name']}",
                                    Icons.person, primaryBlue),
                                infoContainer("Status: Online", Icons.task_alt,
                                    primaryBlue),
                                infoContainer("Location: ${data['address']}",
                                    Icons.location_on, primaryBlue),
                              ],
                            );
                          } else {
                            return const Center(
                                child: Text("No data available"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FutureBuilder<Map<String, int>>(
                    future: fetch_Total_Completed_Issues(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Center(
                          child: _buildPollutionCard(title: "Land", actual: data['resolvedLand']!, budget: data['totalLand']!, percentage: data['resolvedLand']! / data['totalLand']!, color: Colors.red)
                        );
                      } else {
                        return const Center(child: Text("No data available"));
                      }
                    },
                  ),
                  FutureBuilder<Map<String, int>>(
                    future: fetch_Total_Completed_Issues(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Center(
                            child: _buildPollutionCard(title: "Water", actual: data['resolvedWater']!, budget: data['totalWater']!, percentage: data['resolvedWater']! / data['totalWater']!, color: Colors.blue)
                        );
                      } else {
                        return const Center(child: Text("No data available"));
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildPollutionCard(
                    title: "Air Pollution",
                    actual: 85,
                    budget: 120,
                    percentage: 85 / 120,
                    color: Colors.green,
                  ),
                  _buildPollutionCard(
                    title: "Noise Pollution",
                    actual: 55,
                    budget: 80,
                    percentage: 55 / 80,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10, // Horizontal spacing
                runSpacing: 10, // Vertical spacing
                alignment: WrapAlignment.center,
                children: [
                  navigationButton(
                    context: context,
                    label: " All Users",
                    icon: Icons.people,
                    color: primaryBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAllUsers(),
                        ),
                      );
                    },
                  ),
                  navigationButton(
                    context: context,
                    label: "Make a report",
                    icon: Icons.note_alt_outlined,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminReportPage(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                  navigationButton(
                    context: context,
                    label: "Initiate Eco-Activity",
                    icon: Icons.add_box,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcoFriendlyActivity(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                  navigationButton(
                    context: context,
                    label: "All issues",
                    icon: Icons.map,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAllIssues(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                  navigationButton(
                    context: context,
                    label: "All Eco-Activities",
                    icon: Icons.link_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAllActivities(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutionCard({
    required String title,
    required int actual,
    required int budget,
    required double percentage,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 2 - 20,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$actual',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Resolved',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$budget',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 8.0,
            percent: percentage,
            center: Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            progressColor: color,
            backgroundColor: Colors.grey[200]!,
          ),
        ],
      ),
    );
  }

  Widget infoContainer(String info, IconData icon, Color color) {
    return Container(
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Text(
            info,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }

  Widget navigationButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black26,
        elevation: 8,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

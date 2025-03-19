import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/notifications_page.dart';
import 'package:eco_track/pages/charts.dart';
import 'package:eco_track/utilities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../report_page.dart';
import 'expand.dart';

class Dashboard2 extends StatefulWidget {
  final int userId;

  Dashboard2({required this.userId, Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard2> {
  Future<Map<String, int>> fetchTotal_Completed_Issues() async {
    final conn = await DatabaseConnection().connection;
    if (conn == null) {
      throw Exception("DB not available");
    }
    try {
      final resultClosed = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues WHERE status = 1");
      final resultTotal = await conn.execute(
          "SELECT COUNT(*) FROM enviromental_issues");

      if (resultClosed.rows.isNotEmpty && resultTotal.rows.isNotEmpty) {
        final closed = int.parse(resultClosed.rows.first.colAt(0).toString());
        final total = int.parse(resultTotal.rows.first.colAt(0).toString());
        final opened = total - closed;


        return {
          "closed": closed,
          "opened": opened,
        };
      } else {
        throw Exception("No data found in the database.");
      }
    } catch (e) {
      throw Exception("Error fetching issue data: $e");
    }
  }
  Future<String> fetchFact() async {
    final conn = await DatabaseConnection().connection;
    if (conn == null) {
      throw Exception("Database connection is not available.");
    } else {
      final results = await conn.execute(
        'SELECT fact FROM facts ORDER BY RAND() LIMIT 1',
      );

      if (results.rows.isNotEmpty) {
        final row = results.rows.first;
        return row.colAt(0) as String;
      } else {
        throw Exception("No facts found in the database.");
      }
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

  final Color TopBarColor = const Color(0xFFF1F7EE);
  final Color MainColor = const Color(0xFFC5E6A6);
  final Color SecondaryColor = const Color(0xFFE0EDC5);
  final Color TertiaryColor = const Color(0xFF92AA83);
  final Color OptionalColor = const Color(0xFFBDC667);
  final Color BottomBarColor = const Color(0xFF697268);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopBarColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Utils.c3,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Welcome to EcoTrack',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(context),
            _buildScrollableCards(context),
            _buildActionsSection(context),
            _buildReportButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Utils.c2,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProfilePicture(),
            _buildUserDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableCards(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildGraphCard(context),
          _buildMapCard(context),
          _buildFactCard(context),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.25,
      width: MediaQuery
          .of(context)
          .size
          .height * 0.5,
      decoration: BoxDecoration(
        color: Utils.c1,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buttonsContainers("Reported", Icons.report, "2"),
              buttonsContainers("Eco-Friendly Activities",
                  Icons.hourglass_empty, "3"),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27),
                  bottomLeft: Radius.circular(27),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Utils.c2,
              ),
              child: Column(
                children: [
                  small_button_containers(Icons.notifications_active_rounded,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Notifications(userId: widget.userId),
                          ),
                        );
                      }),
                  small_button_containers(Icons.map_outlined, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MarkerMap(icon: Icons.map_outlined)));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Report(userId: widget.userId),
            ),
          );
        },
        child: const Text(
          "Report an issue",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
      ),
    );
  }

  Container _buildGraphCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.black54, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: graph(),
      ),
    );
  }

  Container _buildMapCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: SecondaryColor,
        border: Border.all(color: Colors.black54, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
     child: FutureBuilder<Map<String, int>>(
       future: fetchTotal_Completed_Issues(),
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         } else if (snapshot.hasError) {
           return Center(child: Text("Error: ${snapshot.error}"));
         } else if (snapshot.hasData) {
           final data = snapshot.data!;
           return Center(
            child: IssuePieChart(issuesCompleted: data['closed']!, issuesRemaining:  3 +  data['opened'] !),
           );
         } else {
           return const Center(child: Text("No data available"));
         }
       },
     ),
     // child: IssuePieChart(issuesCompleted: 6, issuesRemaining: 5),
    );
  }

  Container _buildFactCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.black54, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Did you know?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<String>(
                future: fetchFact(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Center(
                      child: Text(
                        data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChart graph() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) =>
          const FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            axisNameWidget: Text(
              "No of Tasks",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  "W${value.toInt() + 1}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black12, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 2.5),
              FlSpot(2, 3),
              FlSpot(3, 2.5),
              FlSpot(4, 4),
              FlSpot(5, 4),
            ],
            color: Colors.green.shade600,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildProfilePicture() {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green[100],
        border: Border.all(color: Colors.black54, width: 5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        size: 70,
        color: Colors.green.shade700,
      ),
    );
  }

  Container _buildUserDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery
          .of(context)
          .size
          .width * 0.5,
      height: MediaQuery
          .of(context)
          .size
          .width * 0.35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: const [
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Name: ${data['name'] ?? 'No data available'}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "City: ${data['address'] ?? 'No data available'}",
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Status: Online",
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No user data found"));
          }
        },
      ),
    );
  }

  GestureDetector buttonsContainers(String title, IconData icon,
      String uniqueId) {
    return GestureDetector(
      onTap: () {
        if (title == "Completed") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpandedContainer1(
                    title: title,
                    icon: icon,
                  ),
            ),
          );
        } else if (title == "Reported") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpandedContainer2(
                    userId: widget.userId,
                    title: title,
                    icon: icon,
                  ),
            ),
          );
        } else if (title == "Eco-Friendly Activities") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpandedContainer3(
                    userId: widget.userId,
                    title: title,
                    icon: icon,
                  ),
            ),
          );
        }
      },
      child: Hero(
        tag: '$title-container-$uniqueId', // Ensuring this tag is unique
        child: Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(5),
          height: MediaQuery
              .of(context)
              .size
              .height * 0.09,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: Colors.black54),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector small_button_containers(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'small-button-$icon',
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          height: MediaQuery
              .of(context)
              .size
              .height * 0.05,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.2,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
          child: GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}


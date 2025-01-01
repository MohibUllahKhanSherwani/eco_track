import 'package:eco_track/pages/dashbord2.dart';
import 'package:eco_track/report_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final int userId;

  Dashboard({required this.userId, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Dashboard - User: ${widget.userId}"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Report(userId: widget.userId),
                  ),
                );
              },
              child: const Text("Report"),
            ),


          ],
        ),
      ),
    );
  }
}

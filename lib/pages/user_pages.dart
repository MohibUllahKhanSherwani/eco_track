import 'package:eco_track/pages/dashboard.dart';
import 'package:eco_track/pages/leaderboard_page.dart';
import 'package:eco_track/pages/setting_page.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';

import 'dashbord2.dart';

class UserPages extends StatefulWidget {
  final int userId;

  UserPages({required this.userId, Key? key}) : super(key: key);
  @override
  State<UserPages> createState() => _UserPagesState();
}

class _UserPagesState extends State<UserPages> {
  int selectedIndex = 0;

  late List<Widget> pages = [
    Dashboard2(userId: widget.userId),
    Leaderboard(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Utils.c2,
        selectedItemColor: Utils.c3,
        unselectedItemColor: Colors.grey.shade800,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_sharp),
            label: "Leaderboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> leaderboard = [];
  List<Map<String, dynamic>> filteredLeaderboard = [];

  // Function to fetch leaderboard data
  Future<void> fetchLeaderboard() async {
    final conn = await DatabaseConnection().connection;

    if (conn == null) {
      throw Exception("Database connection is not available.");
    }

    final results = await conn.execute(
      'SELECT name, points FROM user ORDER BY points DESC',
    );

    setState(() {
      leaderboard = results.rows
          .map((row) => {
        'name': row.colAt(0),
        'points': int.tryParse(row.colAt(1).toString()) ?? 0,
      })
          .toList();
      filteredLeaderboard = List.from(leaderboard);
    });
  }

  // Function to filter leaderboard based on the search query
  void filterLeaderboard(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLeaderboard = List.from(leaderboard);
      } else {
        filteredLeaderboard = leaderboard.where((user) {
          return user['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
    searchController.addListener(() {
      filterLeaderboard(searchController.text); // Call filter on text change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Leaderboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Utils.c3,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search user...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: filteredLeaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredLeaderboard.length,
        itemBuilder: (context, index) {
          final user = filteredLeaderboard[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: index == 0 ? Colors.amber.shade100 : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Utils.c1,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                user['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                "Points: ${user['points'] ?? 0}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.green.shade800,
                ),
              ),
              trailing: Icon(
                Icons.star,
                color: _getStarColor(user['points']),
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to get the color for the star icon based on the highest points user
  Color _getStarColor(int points) {
    final highestPoints = leaderboard.isNotEmpty ? leaderboard[0]['points'] : 0;
    final secondHighestPoints = leaderboard[1]['points'];
    final thirdHighestPoints = leaderboard[2]['points'];
    if (points == highestPoints)
    {
      return Colors.amber;
    }
    else if(points == secondHighestPoints)
    {
      return Colors.grey.shade600;
    }
    else if (points == thirdHighestPoints)
    {
      return Colors.brown;
    }
    return Colors.grey; // Gray for other users
  }
}

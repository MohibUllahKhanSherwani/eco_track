import 'package:flutter/material.dart';
import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/utilities.dart';

class AdminAllUsers extends StatefulWidget {
  const AdminAllUsers({super.key});

  @override
  State<AdminAllUsers> createState() => _AdminAllUsersState();
}

class _AdminAllUsersState extends State<AdminAllUsers> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> all = [];
  List<Map<String, dynamic>> filtered = [];

  // Function to fetch  data
  Future<void> fetchAll() async {
    final conn = await DatabaseConnection().connection;

    if (conn == null) {
      throw Exception("Database connection is not available.");
    }

    final results = await conn.execute(
      'SELECT name, points, date_joined FROM user',
    );

    setState(() {
      all = results.rows
          .map((row) => {
        'name': row.colAt(0),
        'points': int.tryParse(row.colAt(1).toString()) ?? 0,
        'date_joined': row.colAt(2)
      })
          .toList();
      filtered = List.from(all);
    });
  }

  void filterAll(String query) {
    setState(() {
      if (query.isEmpty) {
        filtered = List.from(all);
      } else {
        filtered = all.where((user) {
          return user['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAll();
    searchController.addListener(() {
      filterAll(searchController.text); // Call filter on text change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: const Text(
          "All Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Utils.primaryBlueAdmin,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
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
      body: filtered.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final user = filtered[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Utils.accentBlueAdmin,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Utils.secondaryBlueAdmin,
                child: Text(
                  user['name'][0].toUpperCase(),
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
                "Points: ${user['points']}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              trailing: const Icon(
                Icons.person,
                color: Utils.primaryBlueAdmin,
              ),
            ),
          );
        },
      ),
    );
  }
}

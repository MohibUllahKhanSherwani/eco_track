import 'package:flutter/material.dart';

class ExpandedContainer1 extends StatelessWidget {
  final String title;
  final IconData icon;

  const ExpandedContainer1(
      {super.key, required this.title, required this.icon});

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
      body: Center(
        child: Hero(
          tag: '$title-container-1',
          // Matching the tag from the "Completed" container
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

class ExpandedContainer2 extends StatelessWidget {
  final String title;
  final IconData icon;

  const ExpandedContainer2(
      {super.key, required this.title, required this.icon});

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
      body: Center(
        child: Hero(
          tag: '$title-container-2',
          // Matching the tag from the "Completed" container
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            // Expanded size
            width: MediaQuery.of(context).size.width * 0.9,
            // Expanded size
            decoration: BoxDecoration(
              color: Colors.green,
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
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: 50, color: Colors.black54),
                    Row(),
                    SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 20),

                  ],
                ),
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

class ExpandedContainer3 extends StatelessWidget {
  final String title;
  final IconData icon;

  const ExpandedContainer3(
      {super.key, required this.title, required this.icon});

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
      body: Center(
        child: Hero(
          tag: '$title-container-3',
          // Matching the tag from the "Completed" container
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.4,
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

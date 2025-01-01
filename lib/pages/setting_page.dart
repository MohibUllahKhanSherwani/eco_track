import 'package:eco_track/login_signup.dart';
import 'package:eco_track/pages/dashboard.dart';
import 'package:eco_track/utilities.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Utils.c3,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blue),
            title: const Text('Change Password'),
            onTap: () => _showChangePasswordDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6, color: Colors.orange),
            title: const Text('Change Theme'),
            onTap: () => _showThemeDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: const Text('Notification Settings'),
            onTap: () => _showNotificationSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.purple),
            title: const Text('Language Settings'),
            onTap: () => _showLanguageSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out'),
            onTap: () => _logOut(context),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController oldPasswordController =
            TextEditingController();
        final TextEditingController newPasswordController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle password change logic here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.light_mode, color: Colors.yellow),
                title: const Text('Light Theme'),
                onTap: () {
                  // Switch to light theme
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode, color: Colors.black),
                title: const Text('Dark Theme'),
                onTap: () {
                  // Switch to dark theme
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Navigate to a Notification Settings page or show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Settings'),
          content: SwitchListTile(
            title: const Text('Enable Notifications'),
            value: true,
            onChanged: (bool value) {
              // Handle notification toggle logic
            },
          ),
        );
      },
    );
  }

  void _showLanguageSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  // Switch to English
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Spanish'),
                onTap: () {
                  // Switch to Spanish
                  Navigator.of(context).pop();
                },
              ),
              // Add more languages as needed
            ],
          ),
        );
      },
    );
  }

  void _logOut(BuildContext context) {
    // Handle logout logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: ()
              {
                // Perform logout
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to login page after logout
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginSignup()));
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

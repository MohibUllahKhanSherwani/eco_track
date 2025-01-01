import 'package:eco_track/ecotrack_db.dart';
import 'package:eco_track/login_signup.dart';
import 'package:eco_track/notification_service.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConnection().initializeConnection();
  NotificationService().initialize();
  runApp(const EcoTrack());
}

class EcoTrack extends StatelessWidget {
  const EcoTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginSignup(),
    );
  }
}

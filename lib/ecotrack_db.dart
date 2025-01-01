import 'package:mysql_client/mysql_client.dart';

class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  late final MySQLConnection? _connection;

  factory DatabaseConnection() {
    return _instance;
  }

  DatabaseConnection._internal();

  Future<void> initializeConnection() async {
    try {
      _connection = await MySQLConnection.createConnection(
        host: "10.0.2.2",
        port: 3306,
        userName: "root",
        password: "mohib123",
        databaseName: "eco_track",
      );
      await _connection?.connect();
      print("Database connected: ${_connection?.connected}");
    } catch (e) {
      print("Failed to connect to the database: $e");
      _connection = null;
    }
  }

  MySQLConnection? get connection => _connection;

  Future<void> closeConnection() async {
    if (_connection != null && _connection!.connected) {
      await _connection?.close();
      print("Database connection closed.");
    }
  }
}

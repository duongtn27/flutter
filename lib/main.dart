import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Import path for file operations
import 'screens/hike_list_page.dart'; // Import HikeListPage

void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Delete the database for testing purposes
  String path = join(await getDatabasesPath(), 'hike_database.db');
  await deleteDatabase(path); // Correct usage of the deleteDatabase function
  print("Database deleted");

  runApp(HikingApp());
}

class HikingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiking App',       // Set a title for the app
      theme: ThemeData(
        primarySwatch: Colors.green,  // You can customize the theme color
      ),
      home: HikeListPage(),      // Set HikeListPage as the home screen
      debugShowCheckedModeBanner: false,  // Remove the debug banner
    );
  }
}

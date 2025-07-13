import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the WelcomePage

void main() {
  runApp(const MyApp()); // Added const for better performance
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RelaxRead', // Updated app title
      debugShowCheckedModeBanner:
          false, // Optional: Hides the debug banner during development
      theme: ThemeData(
        // You can define a global theme here if needed
        primarySwatch:
            Colors.green, // Example: sets primary color for some widgets
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          const WelcomePage(), // Set WelcomePage as the initial screen of the app
    );
  }
}

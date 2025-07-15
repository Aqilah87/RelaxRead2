import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin/dashboard_page.dart';
import 'welcome_page.dart';
import 'theme_provider.dart'; // Make sure you created this file

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'RelaxRead',
      debugShowCheckedModeBanner: false,
      themeMode:
          themeProvider.themeMode, // Automatically switches between light/dark
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      initialRoute: '/', // Set your initial route
      routes: {
        '/': (context) => const WelcomePage(), // Your welcome page
        '/admin_dashboard': (context) =>
            const AdminDashboardPage(), // Your admin dashboard
      },
    );
  }
}

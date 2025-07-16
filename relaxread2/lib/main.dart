import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin/dashboard_page.dart'; // Ensure this path is correct
import 'welcome_page.dart'; // Ensure this path is correct
import 'user/homepage.dart'; // Import HomePage
import 'theme_provider.dart'; // Make sure you created this file

void main() {
  runApp(
    ChangeNotifierProvider(
      // The `create` function provides an instance of ThemeProvider
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the ThemeProvider to rebuild MaterialApp when the theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'RelaxRead',
          debugShowCheckedModeBanner: false,
          // Use the themeMode from your ThemeProvider
          themeMode: themeProvider.themeMode,

          // --- Light Theme Definition ---
          theme: ThemeData(
            brightness: Brightness.light,
            // Primary branding colors for the light theme
            primaryColor: const Color(0xFF6B923C), // primaryGreen
            scaffoldBackgroundColor: const Color(
              0xFFF0F2EB,
            ), // Light background
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor:
                  Colors.black, // Default text/icon color for light app bar
              elevation: 1.0,
            ),
            cardColor: Colors.white, // Card background
            dividerColor: Colors.grey, // Divider color in light mode
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                color: Colors.grey[800],
              ), // General text color
              bodySmall: TextStyle(
                color: Colors.grey[600],
              ), // Subtitle/hint text color
              titleLarge: const TextStyle(
                color: Color(0xFF5A7F30),
              ), // Heading text (e.g., 'Hello Reader,')
              titleMedium: const TextStyle(
                color: Colors.black,
              ), // Other titles/headings
            ),
            iconTheme: const IconThemeData(
              color: Colors.grey, // Default icon color for light theme
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white, // Text field background
              hintStyle: TextStyle(color: Colors.grey[600]), // Hint text color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Color(0xFF6B923C),
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF5A7F30), // loginPrimaryGreen
              unselectedItemColor: Colors.grey[600],
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B923C), // primaryGreen
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            dropdownMenuTheme: DropdownMenuThemeData(
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                surfaceTintColor: MaterialStateProperty.all(Colors.white),
              ),
              textStyle: const TextStyle(color: Colors.black),
            ),
          ),

          // --- Dark Theme Definition ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            // Primary branding colors for the dark theme
            primaryColor: const Color(0xFF6B923C), // primaryGreen
            scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(
                0xFF1E1E1E,
              ), // Slightly lighter for app bar
              foregroundColor: Colors.white, // Text/icon color for dark app bar
              elevation: 1.0,
            ),
            cardColor: const Color(0xFF2C2C2C), // Dark card background
            dividerColor: Colors.grey[700], // Divider color in dark mode
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // General text color
              bodySmall: TextStyle(
                color: Colors.grey,
              ), // Subtitle/hint text color
              titleLarge: TextStyle(color: Color(0xFF5A7F30)), // Heading text
              titleMedium: TextStyle(
                color: Colors.white,
              ), // Other titles/headings
            ),
            iconTheme: const IconThemeData(
              color: Colors.grey, // Default icon color for dark theme
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C), // Text field background
              hintStyle: const TextStyle(color: Colors.grey), // Hint text color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Color(0xFF6B923C),
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
              selectedItemColor: const Color(0xFF5A7F30), // loginPrimaryGreen
              unselectedItemColor: Colors.grey[400],
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B923C), // primaryGreen
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            dropdownMenuTheme: DropdownMenuThemeData(
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xFF2C2C2C),
                ),
                surfaceTintColor: MaterialStateProperty.all(
                  const Color(0xFF2C2C2C),
                ),
              ),
              textStyle: const TextStyle(color: Colors.white),
            ),
          ),

          // Define your app routes
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomePage(),
            '/home': (context) => const HomePage(
              userName: '',
              userEmail: '',
            ), // Add your HomePage route
            '/admin_dashboard': (context) => const AdminDashboardPage(),
          },
        );
      },
    );
  }
}
